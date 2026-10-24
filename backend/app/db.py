import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# Cadena de conexión para PostgreSQL con psycopg3
DATABASE_URL = os.getenv(
    "DATABASE_URL", 
    "postgresql+psycopg://ganadero:cambiar_esta_clave_local@db:5432/gestion_ganadera"
)

# Engine configurado con pool de conexiones optimizado para Railway / Docker
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,  # Reconecta automáticamente si Railway cierra conexiones inactivas
    pool_size=10,        # Número de conexiones estables
    max_overflow=20      # Conexiones adicionales máximas en picos de tráfico
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
