from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    database_url: str = "postgresql+psycopg://ganadero:ganadero_dev@localhost:5432/gestion_ganadera"
    jwt_secret_key: str = "solo-desarrollo-cambiar-esta-clave"
    jwt_expire_minutes: int = 60
    environment: str = "development"
    cors_origins: list[str] = ["*"]

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()
