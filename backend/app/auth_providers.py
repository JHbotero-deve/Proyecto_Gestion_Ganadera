import os
from dataclasses import dataclass

import jwt
from jwt import PyJWKClient

GOOGLE_JWKS_URL = "https://www.googleapis.com/oauth2/v3/certs"
MICROSOFT_JWKS_URL = "https://login.microsoftonline.com/common/discovery/v2.0/keys"
GOOGLE_ISSUERS = ("https://accounts.google.com", "accounts.google.com")

_google_jwks = PyJWKClient(GOOGLE_JWKS_URL, cache_keys=True)
_microsoft_jwks = PyJWKClient(MICROSOFT_JWKS_URL, cache_keys=True)

REQUIRED = ["exp", "iat", "iss", "aud", "sub"]


class InvalidProviderToken(Exception):
    pass


@dataclass
class ProviderIdentity:
    provider: str
    subject: str
    email: str | None
    name: str | None


def _client_ids(var_name: str) -> list[str]:
    return [v.strip() for v in os.environ.get(var_name, "").split(",") if v.strip()]


def verify_google(id_token: str) -> ProviderIdentity:
    audiences = _client_ids("GOOGLE_CLIENT_IDS")
    if not audiences:
        raise InvalidProviderToken("Google no está configurado")
    try:
        key = _google_jwks.get_signing_key_from_jwt(id_token).key
        payload = jwt.decode(
            id_token, key, algorithms=["RS256"], audience=audiences, options={"require": REQUIRED}
        )
    except jwt.PyJWTError as exc:
        raise InvalidProviderToken("Token de Google inválido") from exc
    if payload["iss"] not in GOOGLE_ISSUERS:
        raise InvalidProviderToken("Emisor inválido")
    if payload.get("email_verified") is not True:
        raise InvalidProviderToken("El correo de Google no está verificado")
    return ProviderIdentity("google", payload["sub"], payload.get("email"), payload.get("name"))


def verify_microsoft(id_token: str) -> ProviderIdentity:
    audience = os.environ.get("MICROSOFT_CLIENT_ID", "").strip()
    if not audience:
        raise InvalidProviderToken("Microsoft no está configurado")
    try:
        key = _microsoft_jwks.get_signing_key_from_jwt(id_token).key
        payload = jwt.decode(
            id_token, key, algorithms=["RS256"], audience=audience, options={"require": REQUIRED}
        )
    except jwt.PyJWTError as exc:
        raise InvalidProviderToken("Token de Microsoft inválido") from exc
    tenant = payload.get("tid")
    if not tenant or payload["iss"] != f"https://login.microsoftonline.com/{tenant}/v2.0":
        raise InvalidProviderToken("Emisor inválido")
    email = payload.get("email") or payload.get("preferred_username")
    return ProviderIdentity("microsoft", payload["sub"], email, payload.get("name"))