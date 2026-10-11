# Proyecto Gestión Ganadera — Base de Código e Instrucciones

Base de código e infraestructura alineada con la documentación formal del proyecto (`docs/`).

## Stack Tecnológico
- **Backend:** Python 3.12, FastAPI, SQLAlchemy 2.0, Pydantic v2, PyJWT, Argon2 (pwdlib).
- **Base de Datos:** PostgreSQL 16 con migraciones de esquema Alembic.
- **Frontend / Móvil:** Flutter (Dart) con Material 3.
- **Contenedores:** Docker Compose & Dockerfile multi-stage.

## Inicio Rápido con Docker
```bash
# 1. Crear variables de entorno
cp .env.example .env

# 2. Iniciar contenedores
docker compose up --build -d

# 3. Probar salud de la API
curl http://localhost:8000/health
```

Documentación interactiva Swagger: `http://localhost:8000/docs`

## Pruebas Automatizadas
```bash
# Crear entorno e instalar dependencias
python -m venv .venv
.\.venv\Scripts\activate  # Windows PowerShell
pip install -r backend/requirements.txt

# Ejecutar test suite
pytest backend/tests
```

## Migraciones Alembic
```bash
cd backend
alembic upgrade head
```
