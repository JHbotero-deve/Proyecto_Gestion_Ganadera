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

# 2. Generar una clave y asignarla a JWT_SECRET_KEY en .env
python -c "import secrets; print(secrets.token_urlsafe(48))"

# 3. Iniciar contenedores
docker compose up --build -d

# 4. Probar salud de la API
curl http://localhost:8000/health
```

La clave JWT es obligatoria; Docker Compose no inicia la API si está vacía. En Railway, configura una clave distinta como secreto, `ENVIRONMENT=production` y `CORS_ORIGINS` con el origen HTTPS exacto de Vercel cuando esté disponible. No uses comodines ni publiques secretos en Git.

La sesión JWT dura 60 minutos desde el inicio de sesión y vence aunque haya actividad. Para enviar códigos de recuperación, configura `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD` y `SMTP_FROM_EMAIL` como variables del entorno/API. El código numérico vence a los 10 minutos, solo puede usarse una vez y limita los intentos.

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

En producción, ejecuta `alembic upgrade head` como comando previo al despliegue de la API. El arranque de la aplicación no crea ni modifica tablas fuera del entorno de desarrollo. Si la base ya contiene tablas creadas por una versión anterior que no usaba Alembic, primero verifica su esquema y el estado de migraciones; no marques ni apliques migraciones a ciegas sobre una base existente.
****