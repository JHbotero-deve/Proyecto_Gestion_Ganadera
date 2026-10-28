@echo off
echo ==========================================
echo    GAVAC - Gestion Ganadera: Inicio Total
echo ==========================================

echo [1/3] Verificando archivo .env...
if not exist .env (
    copy .env.example .env
    echo Archivo .env creado desde .env.example.
) else (
    echo El archivo .env ya existe.
)

echo [2/3] Levantando contenedores con Docker Compose...
docker compose down
docker compose up --build -d

echo [3/3] Esperando a que PostgreSQL y FastAPI estén listos...
timeout /t 5 /nobreak > nul

echo ==========================================
echo ¡Sistema listo y en funcionamiento!
echo - API Docs (Swagger): http://localhost:8001/docs
echo - Health Check: http://localhost:8001/health
echo ==========================================
pause
