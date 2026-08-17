# MotoCheck — Registro de requisitos v1

## Criterio de uso

Cada fila debe tener dueño, dolor concreto y evidencia de salida. Los elementos sin esos campos se mantienen como hipótesis y no bloquean la versión inicial.

| ID | Requisito | Dueño | Dolor que resuelve | Evidencia de salida | Decisión actual |
|---|---|---|---|---|---|
| R-001 | Registro y gestión de motocicletas | Producto: propietario | El rider necesita identificar el vehículo al que pertenecen sus datos | Alta, edición, eliminación y cambio de moto probados | Conservar |
| R-002 | Registro de combustible | Producto: propietario | El rider necesita controlar consumo y gasto | Cálculos correctos y datos persistentes | Conservar |
| R-003 | Registro de mantenimiento y refacciones | Producto: propietario | Evitar olvidos, ordenar historial y anticipar servicios | Alertas e historial funcionan con datos reales | Conservar |
| R-004 | Respaldo/restauración opcional en Drive | Producto: propietario; técnico: ingeniería | Evitar pérdida de historial al cambiar o perder dispositivo | Login, permiso Drive, backup y restore por plataforma | Conservar; bloqueador |
| R-005 | Login con Google | Producto: propietario; técnico: ingeniería | Identificar la cuenta que respalda datos en Drive | OAuth configurado y probado Android/iOS/Web | Conservar; bloqueador |
| R-006 | Persistencia local Drift/SQLite | Técnico: ingeniería | La app debe funcionar sin red y conservar el historial | Migración no destructiva y pruebas de datos | Conservar; bloqueador |
| R-007 | Exportación PDF/CSV | Producto: propietario | Compartir historial fuera de la app | Hipótesis sin evidencia de demanda v1 | Diferir |
| R-008 | Fotos de la moto | Producto: propietario | Personalización y reconocimiento visual | No bloquea el mantenimiento ni backup inicial | Diferir |
| R-009 | Notificaciones push | Producto: propietario | Recordar servicios sin abrir la app | Requiere permisos, proveedor y privacidad | Diferir hasta post-v1 |
| R-010 | Marketplace y pagos | Producto: propietario | Comprar repuestos/motos | Requiere backend, pagos, cumplimiento, soporte y moderación | Eliminar de v1; fase futura |
| R-011 | Clima y rutas | Producto: propietario | Planear trayectos | Requiere mapas, datos meteorológicos, privacidad y batería | Eliminar de v1; validar después |
| R-012 | Comunidad y seguimiento | Producto: propietario | Compartir recorridos y conectar riders | Requiere moderación, ubicación y reglas de seguridad | Eliminar de v1; validar después |
| R-013 | Android release firmado | Técnico: ingeniería | Distribución válida en Play Console | Keystore, AAB y Play App Signing | Conservar; bloqueador |
| R-014 | iOS/TestFlight | Producto: propietario; técnico: ingeniería | Distribución y prueba en Apple | Mac/Xcode, certificados, bundle ID y TestFlight | Conservar; bloqueador |
| R-015 | Web HTTPS | Producto: propietario; técnico: ingeniería | Acceso Web y OAuth por navegador | Build Web, dominio HTTPS y origen OAuth autorizado | Conservar; bloqueador |
| R-016 | Política de privacidad y soporte | Producto: propietario | Cumplir tiendas y explicar manejo de datos | Página publicada y correo de soporte activo | Conservar; bloqueador |

## Elementos eliminados o diferidos en este ciclo

Se retiran del desarrollo activo de v1 los módulos de marketplace, pagos, clima, rutas, comunidad, tracking, publicidad contextual, exportación y fotos. La eliminación se revisará después de la beta cerrada. Si al menos dos de estos elementos se vuelven indispensables para completar un caso principal probado con riders, se reincorporarán mediante un requisito nuevo, con dueño y evidencia.
