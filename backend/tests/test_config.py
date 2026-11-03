import pytest
from pydantic import ValidationError

from app.config import Settings


def make_settings(**overrides):
    values = {
        "_env_file": None,
        "database_url": "sqlite:///:memory:",
        "jwt_secret_key": "test-secret-with-at-least-32-characters",
    }
    values.update(overrides)
    return Settings(**values)


def test_jwt_secret_must_be_configured_and_long_enough():
    with pytest.raises(ValidationError):
        make_settings(jwt_secret_key="")

    with pytest.raises(ValidationError):
        make_settings(jwt_secret_key="too-short")

    with pytest.raises(ValidationError):
        make_settings(jwt_expire_minutes=0)


def test_cors_accepts_exact_https_and_local_origins():
    settings = make_settings(
        cors_origins=" https://frontend.test/ , http://localhost:5173,https://frontend.test "
    )

    assert settings.allowed_cors_origins == [
        "https://frontend.test",
        "http://localhost:5173",
    ]


@pytest.mark.parametrize(
    "origins",
    [
        "*",
        "https://frontend.test/path",
        "http://frontend.test",
        "https://user@frontend.test",
        "https://frontend.test:invalid",
        "https://frontend.test:",
    ],
)
def test_cors_rejects_wildcards_and_non_origin_urls(origins):
    with pytest.raises(ValidationError):
        make_settings(cors_origins=origins)
