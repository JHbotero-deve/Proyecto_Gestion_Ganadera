import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.auth_providers import InvalidProviderToken, ProviderIdentity
from app.db import Base, get_db
from app.main import app
from app.routers import social_auth

TOKEN_OK = "token-de-prueba-valido-0123456789"
TOKEN_MALO = "token-de-prueba-invalido-0123456789"


@pytest.fixture()
def client_social(monkeypatch):
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(bind=engine)
    Session = sessionmaker(bind=engine, autoflush=False, autocommit=False)

    def override_get_db():
        db = Session()
        try:
            yield db
        finally:
            db.close()

    def fake_verify(provider, id_token):
        if id_token != TOKEN_OK:
            raise InvalidProviderToken("malo")
        return ProviderIdentity(provider, f"{provider}-sub-1", f"{provider}@test.com", "Persona Test")

    monkeypatch.setattr(social_auth, "verify_provider_token", fake_verify)
    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()


def _me(client, token):
    r = client.get("/api/v1/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert r.status_code == 200
    return r.json()


@pytest.mark.parametrize("provider", ["google", "microsoft"])
def test_login_social_crea_usuario(client_social, provider):
    r = client_social.post(f"/api/v1/auth/{provider}", json={"id_token": TOKEN_OK})
    assert r.status_code == 200
    assert _me(client_social, r.json()["access_token"])["email"] == f"{provider}@test.com"


def test_segundo_login_reutiliza_el_mismo_usuario(client_social):
    t1 = client_social.post("/api/v1/auth/google", json={"id_token": TOKEN_OK}).json()["access_token"]
    t2 = client_social.post("/api/v1/auth/google", json={"id_token": TOKEN_OK}).json()["access_token"]
    assert _me(client_social, t1)["id"] == _me(client_social, t2)["id"]


def test_token_invalido_da_401(client_social):
    r = client_social.post("/api/v1/auth/google", json={"id_token": TOKEN_MALO})
    assert r.status_code == 401


def test_no_vincula_cuenta_existente_por_correo(client_social):
    client_social.post(
        "/api/v1/auth/register",
        json={"nombre": "Local", "email": "google@test.com", "password": "clave-segura-123"},
    )
    r = client_social.post("/api/v1/auth/google", json={"id_token": TOKEN_OK})
    assert r.status_code == 409


def test_usuario_social_no_puede_entrar_con_contrasena(client_social):
    client_social.post("/api/v1/auth/google", json={"id_token": TOKEN_OK})
    r = client_social.post(
        "/api/v1/auth/login", json={"email": "google@test.com", "password": "cualquier-clave-123"}
    )
    assert r.status_code == 401