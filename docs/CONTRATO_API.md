# Contrato inicial de API

## Estado
Propuesta preliminar. Estas rutas no están implementadas.

## Convenciones
- Prefijo propuesto: /api/v1.
- Intercambio de datos JSON.
- Fechas en formato ISO 8601.
- Errores controlados, sin información interna sensible.
- Autenticación y permisos verificados en el backend.

## Rutas candidatas
- POST /api/v1/auth/login
- POST /api/v1/auth/logout
- GET /api/v1/farms
- POST /api/v1/farms
- GET /api/v1/animals
- POST /api/v1/animals
- GET /api/v1/animals/{animal_id}
- PATCH /api/v1/animals/{animal_id}
- GET /api/v1/animals/{animal_id}/events
- POST /api/v1/animals/{animal_id}/events
- POST /api/v1/sync/push
- GET /api/v1/sync/pull

## Pendiente de definición
- Esquemas de solicitudes y respuestas.
- Campos obligatorios y reglas de validación.
- Códigos HTTP y formato de errores.
- Roles, permisos y acceso por finca.
- Paginación y filtros.
- Idempotencia y operaciones duplicadas.
- Versionado y resolución de conflictos offline.
- Renovación y revocación de sesiones.

## Pruebas mínimas
- Solicitudes válidas e inválidas.
- Acceso sin autenticación o permisos.
- Separación de datos entre fincas.
- Reintentos y conflictos de sincronización.

Estado: contrato preliminar pendiente de revisión técnica.
