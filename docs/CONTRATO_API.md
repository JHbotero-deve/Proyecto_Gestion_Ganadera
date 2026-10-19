# Contrato inicial de API

## Estado
Contrato inicial en evolución. Las rutas de recuperación de contraseña descritas aquí están implementadas; las demás rutas siguen sujetas a revisión de su estado en el backend.

## Convenciones
- Prefijo propuesto: /api/v1.
- Intercambio de datos JSON.
- Fechas en formato ISO 8601.
- Errores controlados, sin información interna sensible.
- Autenticación y permisos verificados en el backend.

## Rutas candidatas
- POST /api/v1/auth/login
- POST /api/v1/auth/password-reset/request
- POST /api/v1/auth/password-reset/confirm
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
- Renovación de sesiones y cierre de sesión.

## Recuperación de contraseña
- `POST /api/v1/auth/password-reset/request` recibe `email` y devuelve la misma respuesta genérica exista o no la cuenta. El correo solo se entrega si SMTP está configurado.
- `POST /api/v1/auth/password-reset/confirm` recibe `email`, `code` de ocho dígitos y `new_password` de 10 a 128 caracteres. El código vence a los 10 minutos, permite hasta cinco intentos y se invalida después de usarse.
- Las solicitudes de código se limitan a una por minuto por cuenta.
- La sesión JWT vence a los 60 minutos desde su emisión, independientemente de la actividad.
- Estas rutas ya están implementadas; SMTP debe configurarse como variables de entorno del backend.

## Pruebas mínimas
- Solicitudes válidas e inválidas.
- Acceso sin autenticación o permisos.
- Separación de datos entre fincas.
- Reintentos y conflictos de sincronización.

Estado: contrato preliminar pendiente de revisión técnica.
