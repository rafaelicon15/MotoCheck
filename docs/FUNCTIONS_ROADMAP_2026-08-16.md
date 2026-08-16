# MotoCheck — Hoja de ruta de funciones posteriores a v1

**Fecha:** 2026-08-16

**Autor:** Manus AI

**Estado:** Propuesta de producto y arquitectura; no autoriza implementación automática fuera de los gates definidos.
**Marco:** "cuestionar → eliminar → simplificar → acelerar → automatizar".

## 1. Propósito y decisión de producto

MotoCheck no debe competir con Calimoto, Detecht y MotoMeteo copiando cada módulo. Su ventaja defendible es otra: ser el historial **local-first y confiable** que ayuda a cada rider a conocer, cuidar y anticipar las necesidades de su motocicleta. La primera regla de esta hoja de ruta es preservar esa promesa.

> **Regla de alcance.** Toda capacidad futura debe aumentar la decisión de mantenimiento, seguridad o compatibilidad de la moto. Si solamente añade una pantalla, un feed o datos sin una acción clara para el rider, se elimina o se pospone.

| Horizonte | Resultado que se busca | Lo que queda explícitamente fuera |
|---|---|---|
| **v1 — noviembre de 2026** | Perfil de moto, combustible, mantenimiento, refacciones, alertas, calendario opcional y respaldo Drive opcional. | Marketplace, rutas, mapas, clima, comunidad, pagos y seguimiento de ubicación. |
| **v1.x — confianza y profundidad** | Historial más útil, documentos, exportación y alertas realmente accionables. | Navegación, pagos, chat y redes sociales. |
| **v2 — valor contextual para riders** | Compatibilidad de piezas y clima asociado a una ruta voluntaria. | Navegación giro a giro, tracking en segundo plano y comercio transaccional. |
| **v3+ — plataformas** | Marketplace, rutas, seguridad y comunidad solo como productos separados, respaldados por backend, privacidad y operaciones. | Lanzar simultáneamente pagos, mapas, rastreo y comunidad. |

## 2. Aprendizajes que sí se incorporan

Las referencias públicas confirman que las apps exitosas reducen una decisión concreta del rider: MotorCheck ordena combustible y mantenimiento; MotoMeteo contextualiza el clima para un recorrido; Detecht vincula viaje y seguridad; Calimoto se especializa en rutas de motocicleta [1] [2] [3] [4] [5]. MotoCheck adopta ese patrón sin copiar sus superficies completas.

| Referencia | Capacidad observada | Decisión de MotoCheck | Razón de simplificación |
|---|---|---|---|
| **MotorCheck** | Cargas de combustible, gastos, mantenimiento y consumo anómalo. | Incorporar primero gastos por servicio y señal de consumo anómalo. | Reutiliza datos locales existentes y genera una acción verificable. |
| **MotoMeteo** | Clima por checkpoints y hora estimada de llegada. | Posponer hasta v2; iniciar con puntos de ruta introducidos voluntariamente. | Evita ubicación permanente, navegación y recolección innecesaria. |
| **Detecht** | Rutas, seguridad, contactos, peligros y comunidad. | Posponer seguridad conectada hasta contar con backend, consentimiento y operación. | Un falso positivo de accidente o una alerta que no llega tiene riesgo alto. |
| **Calimoto** | Rutas escénicas, navegación, mapas offline y tracking. | Mantener fuera de v1 y v2 inicial; aceptar GPX solo como importación futura. | Reproducir navegación offline exige mapas, licencia, batería y soporte especializado. |

## 3. Backlog estructurado por fases

### Fase A — Cierre de v1: estabilidad antes de expansión

Esta fase no añade funciones inspiradas en competidores. Elimina la deuda que impediría confiar en cualquiera de ellas.

| Épica | Requisito con responsable | Criterio de aceptación | Dependencias | Estado |
|---|---|---|---|---|
| **A1. OAuth multiplataforma** | Engineering: registrar huellas SHA-1/SHA-256 de debug y release Android; completar cliente iOS. | Drive opcional funciona o falla de forma entendible en Android, iOS y Web; ninguna pantalla bloquea la operación local. | Google Cloud, dispositivo físico Android/iOS. | Bloqueado parcialmente. |
| **A2. Migraciones** | Engineering: tests de snapshots Drift v7–v11. | La actualización desde cada versión conserva perfiles, servicios, cargas y piezas. | Fixtures versionados. | Pendiente. |
| **A3. Matriz física** | QA: probar calendario, backup, restauración, permisos y alertas en dispositivos reales. | Evidencia por plataforma y rollback documentado. | APK/iPhone de prueba. | Android listo para instalar; iOS pendiente. |
| **A4. Accesibilidad y rendimiento** | UX/Engineering: contraste, foco, tamaño táctil y medición release. | No hay overflow en 360–430 px, controles táctiles útiles y tamaño medido en AAB. | Dispositivos y build release. | En curso. |

**Gate de salida A.** No comenzar funcionalidades nuevas mientras A1–A3 no estén cerradas y el flujo local-first no se pueda probar sin red.

### Fase B — V1.x: convertir registros en decisiones

Estas capacidades heredan datos ya presentes. No requieren cuenta, backend ni ubicación.

| ID | Función | Problema que resuelve | Diseño mínimo | Se elimina por ahora | Gate de éxito |
|---|---|---|---|---|---|
| **B1** | Gastos y coste total de propiedad | El rider conoce km, pero no cuánto cuesta mantener su moto. | Importe, moneda, categoría y nota al guardar combustible o servicio; total mensual y por km. | Facturación, impuestos, OCR de facturas y sincronización automática. | Cinco pruebas manuales y cálculo reproducible por moto. |
| **B2** | Señal de consumo anómalo | Una variación fuerte de km/L puede anticipar un problema. | Comparar últimas cinco cargas válidas con media móvil y mostrar aviso explicable, no diagnóstico. | Diagnóstico mecánico, recomendaciones automáticas o IA. | Sin falsos avisos con menos de cinco cargas. |
| **B3** | Historial, fotos y documentos | El mantenimiento pierde contexto y comprobantes. | Adjuntar fotos/documentos locales a una moto o servicio; visor y exportación. | OCR, reconocimiento de repuestos y nube obligatoria. | Datos accesibles offline y en backup opcional. |
| **B4** | Exportación controlada | El usuario debe poder salir con sus datos. | Exportar CSV/JSON y resumen PDF bajo una acción explícita. | Compartición automática, enlaces públicos o analítica sin consentimiento. | Archivo legible e importable en una hoja de cálculo. |
| **B5** | Alertas accionables | Una alerta debe llevar a una decisión. | Estado `pendiente / pospuesta / atendida`, motivo y próximo paso desde cada alerta. | Notificaciones invasivas y automatización de reservas. | Cada alerta abre un registro o una acción concreta. |

**Orden recomendado:** B5 → B1 → B2 → B4 → B3. Es el mayor valor con la menor superficie técnica.

### Fase C — V2: compatibilidad y clima sin navegar al usuario

Se habilita solo después de medir adopción de B1–B5 y obtener consentimiento de privacidad explícito.

| ID | Función | Diseño acotado | Datos y privacidad | Dependencias | Exclusiones obligatorias |
|---|---|---|---|---|---|
| **C1** | Ficha técnica y compatibilidad de repuestos | Catálogo curado por marca, modelo, año y motor; el usuario confirma compatibilidad. | Catálogo separado de datos personales; correcciones auditables. | Fuente de catálogo, moderación y modelo de datos. | Inventario de terceros, pagos y publicación abierta por vendedores. |
| **C2** | Ruta de servicio manual | Guardar origen, destino y hasta cinco paradas introducidas por el usuario. | No ubicación en segundo plano; borrar rutas bajo demanda. | Geocodificación y proveedor de mapas bajo evaluación. | Navegación por voz, tracking permanente y mapas offline. |
| **C3** | Clima para ruta planificada | Pronóstico por punto y ventana horaria; cache con fecha de actualización y aviso de cobertura. | La consulta se produce solo al tocar "Consultar clima". | Proveedor meteorológico, coste, límites y términos. | Alertas meteorológicas críticas, recomendaciones de conducción o perfilado de ubicación. |
| **C4** | Dossier de venta de la moto | Exportar historial verificable seleccionado por el usuario. | Información sensible seleccionable; sin perfil público. | B4 y política de privacidad. | Publicar motos, mensajería, pagos o clasificación automática de precios. |

**Gate de salida C.** Cualquier proveedor externo debe tener coste por usuario, límite técnico, política de retención, experiencia offline y reversión documentada antes de integrarse.

### Fase D — V3: marketplace como producto separado

El marketplace no es una pestaña adicional. Es un sistema de comercio con responsabilidades operativas y legales. Su primer experimento no debe aceptar pagos.

| Nivel | Capacidad | Qué se implementa | Qué se prohíbe hasta el siguiente nivel |
|---|---|---|---|
| **D0 — Descubrimiento** | Lista curada de talleres, marcas y proveedores compatibles. | Enlaces externos claramente identificados y reporte de datos desactualizados. | Carrito, checkout, inventario y comisión. |
| **D1 — Captación** | Solicitud de cotización o contacto con vendedor. | Lead con consentimiento, trazabilidad y límites de spam. | Pago, logística, escrow y publicación libre. |
| **D2 — Catálogo** | Piezas con compatibilidad y disponibilidad declarada. | Moderación, responsables de contenido y estado de inventario. | Precios dinámicos sin control, reseñas sin moderación y pagos. |
| **D3 — Comercio** | Carrito, pedido y pago. | Solo con backend transaccional, proveedor de pagos, antifraude, impuestos, devoluciones, soporte y webhooks idempotentes. | Lanzar en múltiples países sin validación legal y fiscal. |

La venta de motos usadas se sitúa después de D3: incrementa fraude, titularidad, documentos, jurisdicción y soporte, por lo que no debe compartir el primer lanzamiento del marketplace.

### Fase E — V4: rutas, seguridad y comunidad

La comunidad y la seguridad conectada tienen una superficie de daño mayor que una función de mantenimiento. Primero se validará una propuesta con usuarios, política de moderación, soporte y pruebas de batería. La detección automática de accidentes, el compartir ubicación en vivo y las alertas a contactos se mantienen **fuera de alcance** hasta contar con un backend resiliente, contactos verificables, consentimiento granular, cancelación, prueba de entrega y límites de responsabilidad.

| Propuesta futura | Prueba de bajo riesgo primero | Prerequisito no negociable |
|---|---|---|
| Importar GPX | Visualización local y borrado por el usuario. | Licencia de mapas y tratamiento de ubicación documentados. |
| Compartir viaje | Exportar un resumen manual, no tracking. | Consentimiento y expiración de enlace. |
| Peligros reportados | Panel moderado interno, sin mostrar a usuarios. | Moderación, reporte y proceso de retirada. |
| Grupos/comunidad | Entrevistas, lista de espera y normas. | Identidad, privacidad, moderación y soporte. |
| Alerta de accidente | Investigación y simulación, sin mensajes reales. | Servicios de emergencia/contactos, pruebas de entrega y revisión legal. |

## 4. Arquitectura que no se debe adelantar

La arquitectura se agrega solo cuando la función la exige. V1.x continúa con Drift local y Drive opcional. B1–B5 pueden vivir enteramente en el dispositivo; los adjuntos deberán tener límite de tamaño y una estrategia explícita de inclusión/exclusión en la copia de Drive.

C1 requiere un catálogo versionado y actualizable. C2–C3 requieren una capa de proveedor detrás de una interfaz para poder sustituir mapas o clima sin migrar datos locales. D1 en adelante requiere backend, identidades, auditoría, roles, almacenamiento seguro, términos, privacidad y operación humana. E necesita además tratamiento de ubicación, mensajería, moderación y observabilidad.

## 5. Priorización cuantitativa y decisiones eliminadas

| ID | Valor para el núcleo (1–5) | Complejidad (1–5) | Riesgo operativo (1–5) | Prioridad | Decisión |
|---|---:|---:|---:|---|---|
| B5 — alertas accionables | 5 | 2 | 1 | **P0** | Construir tras estabilidad. |
| B1 — gastos | 5 | 2 | 1 | **P0** | Construir tras estabilidad. |
| B2 — consumo anómalo | 4 | 2 | 2 | **P1** | Construir después de B1. |
| B4 — exportación | 4 | 3 | 2 | **P1** | Construir con controles de privacidad. |
| B3 — fotos/documentos | 4 | 3 | 3 | **P1** | Construir con presupuesto de almacenamiento. |
| C1 — compatibilidad | 4 | 4 | 3 | **P2** | Descubrir fuente de datos primero. |
| C3 — clima por ruta | 3 | 4 | 4 | **P2** | Prototipo solo con consentimiento y coste aprobado. |
| C2 — ruta manual | 3 | 4 | 4 | **P3** | No construir antes de C3. |
| D0 — directorio | 2 | 3 | 3 | **P3** | Validar interés antes de código. |
| D3 — pagos | 2 | 5 | 5 | **No antes de v3** | Eliminar del roadmap inmediato. |
| E — navegación/comunidad/seguridad | 2 | 5 | 5 | **No antes de v4** | Eliminar del roadmap inmediato. |

## 6. Próximos pasos operativos

1. Cerrar los gates A1–A4 y recopilar la primera matriz real de Android, iOS y Web.
2. Validar B5 y B1 con cinco riders por medio de prototipos y una métrica definida antes de ampliar el esquema Drift.
3. Escribir un RFC por cada épica que alcance estado `P0`; el RFC debe nombrar responsable, datos creados, migración, pruebas, permiso, coste, rollback y métrica de éxito.
4. Revisar este documento cada cuatro semanas; mover una épica solo cuando su gate esté comprobado, no por presión de calendario.

## Referencias

[1]: https://play.google.com/store/apps/details?id=com.motorcheck.app "MotorCheck Fuel Tracker — Google Play"

[2]: https://www.motometeo.com/ "MotoMeteo — Route Weather for Motorcyclists"

[3]: https://apps.apple.com/us/app/detecht-motorcycle-app-gps/id1373032762 "Detecht — App Store"

[4]: https://play.google.com/store/apps/details?id=com.calimoto.calimoto&hl=en_US "calimoto — Google Play"

[5]: https://calimoto.com/en "Calimoto — sitio oficial"
