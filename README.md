# GAVAC - Sistema de Gestion Ganadera (Railway + Flutter Bloc)

Plataforma integral para el control de inventario bovino, eventos sanitarios, trazabilidad reproductiva y reportes de campo.

--------------------------------------------------------------------------------

## Stack Tecnológico Oficial

- Backend: Python 3.12+ / FastAPI / SQLAlchemy 2.0 (PsychoPy3) / Alembic.
- Base de Datos: PostgreSQL 16 (Containerizado en Railway / Docker Compose).
- Mobile App: Flutter (Arquitectura limpia con gestor de estado Bloc).
- Infraestructura: Docker Compose (Desarrollo local) y Railway (Despliegue de produccion).

--------------------------------------------------------------------------------

## Reglas de Desarrollo y Arquitectura

1. Base de Datos Unificada: Toda la persistencia reside en la instancia PostgreSQL de Railway/Docker. Queda descartado el uso de Supabase.
2. Inmutabilidad y Trazabilidad (Pilar I): Ningún evento crítico (animales, pesajes, tratamientos) se elimina físicamente (DELETE). Se utiliza soft-delete (deleted_at) o registros de ajuste.
3. Móvil (Flutter + Bloc):
   - Flujo unidireccional de datos: Event -> Bloc -> State.
   - Separación estricta entre capa de UI (Widgets), Lógica de Negocio (Blocs) y Repositorios (Data/API Provider).
4. Boveda de Documentos (Pilar II): Archivos sanitarios e impresiones de hierro se sirven mediante almacenamiento privado con enlaces firmados temporales.

--------------------------------------------------------------------------------

## Inicio Rápido (Entorno Local)

1. Levantar Servicios con Docker:
   docker-compose up -d --build

- API FastAPI: http://localhost:8001/docs (Puerto local 8001 / 8000 en contenedor).
- PostgreSQL Local: localhost:5433 (usuario: ganadero, bd: gestion_ganadera).

2. Ejecutar Cliente Móvil (Flutter):
   cd mobile
   flutter pub get
   flutter run

--------------------------------------------------------------------------------

## Equipo y Responsabilidades

- Jorge Botero: Backend, API, Base de Datos y Estabilidad (FastAPI / PostgreSQL / Docker / Railway)
- Oscar Navarro: Lider / Modulo Cattle
- Juan Herrera: Modulo Auth & Testing
- Elian Martínez: Frontend / Adaptabilidad
