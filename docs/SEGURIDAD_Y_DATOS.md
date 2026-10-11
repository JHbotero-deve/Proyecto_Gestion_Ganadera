# Seguridad y protección de datos

## 1. Principios
- Aplicar mínimo privilegio.
- Validar todas las entradas en el backend.
- No confiar únicamente en las restricciones del frontend.
- Proteger los datos tanto en tránsito como en almacenamiento.

## 2. Autenticación
- Definir un mecanismo seguro de inicio y cierre de sesión.
- Aplicar políticas de contraseñas y almacenamiento seguro de credenciales.
- Definir expiración, renovación y revocación de sesiones.
- No registrar contraseñas, tokens ni secretos en los logs.

## 3. Autorización
- Verificar permisos en cada operación protegida.
- Aislar los datos de cada finca según los permisos del usuario.
- Probar intentos de acceso no autorizado.

## 4. Secretos y configuración
- No subir archivos .env con credenciales reales.
- Mantener un .env.example sin secretos.
- Separar configuración de desarrollo y producción.
- Revisar los cambios antes de publicarlos en GitHub.

## 5. API y errores
- Validar tipos, formatos, límites y relaciones entre datos.
- Devolver mensajes de error controlados.
- No exponer trazas, consultas SQL ni detalles internos.
- Configurar CORS de forma restrictiva en los entornos desplegados.

## 6. Datos sin conexión
- Definir qué información puede almacenarse en el dispositivo.
- Evaluar cifrado del almacenamiento local.
- Proteger la cola de operaciones pendientes.
- Resolver conflictos sin perder cambios silenciosamente.
- Considerar el cierre de sesión y la revocación de acceso.

## 7. Auditoría y recuperación
- Registrar operaciones críticas con fecha y usuario.
- Restringir la lectura y modificación de los registros de auditoría.
- Definir copias de seguridad y pruebas de restauración.
- Establecer retención y eliminación de datos.

## 8. Pruebas mínimas
- Acceso sin sesión y con permisos insuficientes.
- Intentos de consultar datos de otra finca.
- Entradas inválidas y errores inesperados.
- Verificación de que los secretos no aparecen en logs.
- Pruebas de restauración y sincronización.

Estado: propuesta pendiente de revisión técnica y aprobación.
