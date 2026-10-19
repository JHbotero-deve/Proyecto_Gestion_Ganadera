
from urllib.parse import urlsplit

from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

from app.config import settings


# Diagnóstico seguro de la conexión
url = settings.database_url
parsed = urlsplit(url)

print("DIAGNOSTICO DATABASE_URL")
print("Variable recibida:", bool(url))
print("Esquema:", parsed.scheme)
print("Tiene hostname:", bool(parsed.hostname))
print("Tiene puerto:", parsed.port is not None if parsed.port else False)
print("Parece una referencia sin resolver:", "${{" in url)


# Configuración de la base de datos
engine = create_engine(
    settings.database_url,
    pool_pre_ping=True,
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)

Base = declarative_base()


# Dependencia para obtener una sesión de base de datos
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
