# Arquitectura propuesta

## 1. Objetivo
Definir una arquitectura mantenible para gestionar información ganadera desde web y dispositivos móviles, incluyendo escenarios de conectividad limitada.

## 2. Componentes propuestos
- Cliente web y móvil: Flutter y Dart, pendiente de aprobación.
- API backend: Python y FastAPI, pendiente de aprobación.
- Base de datos central: PostgreSQL.
- Entorno de desarrollo: Docker y Docker Compose.
- Control de versiones y colaboración: Git y GitHub.

## 3. Responsabilidades
- Frontend: interfaz, validaciones de experiencia de usuario y almacenamiento local autorizado.
- Backend: autenticación, permisos, reglas de negocio, validación y sincronización.
- Base de datos: persistencia, integridad y restricciones.
- Revisión técnica: seguridad, pruebas y calidad de los cambios.

## 4. Trabajo sin conexión
- Mantener una copia local persistente de los datos necesarios.
- Encolar operaciones pendientes de forma duradera.
- Identificar cada operación para impedir duplicados.
- Detectar cambios concurrentes y definir reglas de resolución.
- Informar al usuario del estado de sincronización.
- Definir cómo proteger los datos almacenados en el dispositivo.

## 5. Seguridad
- No guardar secretos en el repositorio.
- Verificar identidad y permisos en el backend.
- Validar las entradas y limitar los datos devueltos.
- Usar conexiones seguras en entornos desplegados.
- Registrar operaciones críticas sin almacenar contraseñas ni secretos.

## 6. Entornos
- Desarrollo local.
- Pruebas automatizadas.
- Entorno de validación antes de producción.
- Producción con configuración y secretos separados.

## 7. Decisiones pendientes
- Aprobar Flutter o evaluar una alternativa para web.
- Confirmar FastAPI y PostgreSQL.
- Definir almacenamiento local y estrategia de sincronización.
- Definir autenticación, roles y permisos.
- Establecer despliegue, copias de seguridad y recuperación.

Estado: propuesta arquitectónica; no describe una implementación existente.
