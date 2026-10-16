from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app import auth_providers
from app.auth_providers import InvalidProviderToken, ProviderIdentity
from app.db import get_db
from app.models import User
from app.schemas import TokenOut
from app.security import create_access_token

router = APIRouter(prefix="/api/v1/auth", tags=["Autenticación social"])


class SocialLoginIn(BaseModel):
    id_token: str = Field(min_length=20, max_length=8192)


def verify_provider_token(provider: str, id_token: str) -> ProviderIdentity:
    if provider == "google":
        return auth_providers.verify_google(id_token)
    return auth_providers.verify_microsoft(id_token)


def _login_or_create(db: Session, provider: str, id_token: str) -> User:
    try:
        ident = verify_provider_token(provider, id_token)
    except InvalidProviderToken:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Token inválido")

    user = db.scalar(
        select(User).where(User.auth_provider == ident.provider, User.provider_subject == ident.subject)
    )
    if user is not None:
        return user

    if not ident.email:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "La cuenta no proporcionó un correo")
    email = ident.email.lower()

    # Nunca se vincula por correo: otra persona podría tener una cuenta con ese correo.
    if db.scalar(select(User).where(User.email == email)) is not None:
        raise HTTPException(
            status.HTTP_409_CONFLICT,
            "Ya existe una cuenta con ese correo. Inicia sesión con tu método original",
        )

    user = User(
        nombre=(ident.name or email.split("@")[0])[:120],
        email=email,
        password_hash=None,
        auth_provider=ident.provider,
        provider_subject=ident.subject,
    )
    db.add(user)
    try:
        db.commit()
        db.refresh(user)
    except IntegrityError:
        db.rollback()
        raise HTTPException(status.HTTP_409_CONFLICT, "No se pudo crear la cuenta")
    return user


@router.post("/google", response_model=TokenOut)
def login_google(data: SocialLoginIn, db: Session = Depends(get_db)):
    user = _login_or_create(db, "google", data.id_token)
    return TokenOut(access_token=create_access_token(user.id))


@router.post("/microsoft", response_model=TokenOut)
def login_microsoft(data: SocialLoginIn, db: Session = Depends(get_db)):
    user = _login_or_create(db, "microsoft", data.id_token)
    return TokenOut(access_token=create_access_token(user.id))