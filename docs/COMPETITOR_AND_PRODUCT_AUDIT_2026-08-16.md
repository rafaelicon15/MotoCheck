# MotoCheck — Auditoría de competidores y producto

**Fecha:** 2026-08-16
**Autor:** Manus AI
**Propósito:** comparar MotoMeteo, MotorCheck, Detecht y Calimoto; identificar qué genera valor, qué riesgos conviene evitar y qué debe permanecer fuera de la v1 de MotoCheck.

## Resumen ejecutivo

Las aplicaciones analizadas no triunfan por acumular funciones, sino por resolver un momento concreto del rider con una promesa fácil de entender. **MotorCheck** se concentra en combustible, kilometraje, mantenimiento y estadísticas; **MotoMeteo** convierte el clima en una decisión de salida contextualizada por ruta y hora; **Detecht** combina navegación con seguridad y comunidad; **Calimoto** compite en planificación, navegación específica para motocicleta y rutas escénicas, con mapas offline y una base de usuarios mucho mayor que la de las otras referencias públicas revisadas.

MotoCheck tiene una oportunidad distinta: ser la herramienta **local-first de mantenimiento y conocimiento de la moto**, con respaldo opcional, alertas claras y datos que siguen funcionando sin cuenta. No debe intentar ser simultáneamente un navegador, una red social, un marketplace y una aplicación meteorológica en la v1.

## Comparación

| Aplicación | Promesa principal | Funciones diferenciadoras observadas | Señales públicas | Riesgo o límite observado |
|---|---|---|---|---|
| MotorCheck Fuel Tracker | Control simple de combustible, kilometraje y mantenimiento | Cargas, gastos, estadísticas, programación por kilometraje y detección de consumo inusual | Google Play muestra 4.6/5 con 5 reseñas y 500+ descargas; la ficha enfatiza claridad y sencillez [1] | La muestra pública es pequeña; no debe tratarse como prueba de escala |
| MotoMeteo | Saber qué clima habrá en cada tramo y a qué hora llegará el rider | Pronóstico por checkpoints, ETA, comparación de ventanas de salida, peligros para motociclistas, recomendaciones de vestimenta, GPX y rutas guardadas [2] | Producto con diferenciación muy concreta y modelo gratuito/PRO [2] | Requiere rutas, ubicación, mapas/GPX, proveedor meteorológico y tratamiento de datos de localización |
| Detecht | Planificar, navegar y aumentar la seguridad del viaje | Detección automática de accidentes, seguimiento para contactos, avisos de peligros, rutas curvas/redondas, navegación por voz, GPX, estadísticas y comunidad [3] | App Store muestra 4.6 con 3.8K valoraciones [3] | Las reseñas públicas también reportan cierres, recálculos defectuosos, waypoints imposibles, consumo térmico y problemas offline [3] |
| Calimoto | Navegación y rutas escénicas hechas para motociclistas | Rutas sinuosas, navegación giro a giro, tracking, mapas offline, límites de velocidad, peligros, puntos de interés y comunidad [4] [5] | Google Play muestra 4.2 con aproximadamente 54.5K reseñas [4] | Es un producto maduro y costoso de igualar; entrar por navegación sería una expansión desproporcionada |

## Qué las hace exitosas

La primera constante es la **especialización contextual**. MotoMeteo no muestra simplemente “el clima”; lo relaciona con el trazado y el horario de llegada. Detecht no ofrece solamente un mapa; conecta ruta, seguridad y contactos. Calimoto no se presenta como un GPS genérico; convierte el criterio de ruta escénica en su identidad. MotorCheck simplifica la captura de combustible y mantenimiento para producir estadísticas comprensibles.

La segunda constante es la **reducción de decisiones**. Las mejores pantallas muestran una recomendación o un siguiente paso: cuándo salir, qué peligro viene, qué mantenimiento toca o qué ruta elegir. MotoCheck debe aplicar esto a la tarjeta de la moto y a sus alertas: menos chips simultáneos, mayor jerarquía y una acción principal evidente.

La tercera constante es la **continuidad de uso**. Calimoto y Detecht obtienen valor de planificar, guardar y repetir rutas; MotorCheck del historial; MotoMeteo de recalcular cuando cambia el pronóstico. Para MotoCheck, esa continuidad debe ser local y confiable: el usuario registra un servicio o carga sin iniciar sesión y puede respaldar cuando lo decida.

La cuarta constante es una **monetización coherente con el núcleo**. MotoMeteo reserva planificación ilimitada y comparación de salidas para PRO [2]. Detecht usa una suscripción opcional [3]. MotoCheck no debe monetizar todavía hasta estabilizar la base: el primer producto vendible debe ser confianza, no catálogo.

## Rendimiento y simplificación

La medición actual del repositorio registra un artefacto Web de aproximadamente **6.4 MB** sin CanvasKit local, con `main.dart.js` de aproximadamente 3.94 MB, `sqlite3.wasm` de aproximadamente 0.75 MB y `drift_worker.js` de aproximadamente 0.36 MB. El código Dart de `lib/` suma aproximadamente 14,331 líneas. Esto es razonable para un preview local-first con Drift Web, aunque el tamaño de JavaScript y la base WASM justifican una meta interna de release claramente menor que el límite técnico de las tiendas.

La app debería mejorar primero en tres puntos: carga inicial y caché del Web preview; reducción de dependencias que no aporten a v1; y separación de la lógica de autenticación, calendario y notificaciones en servicios pequeños. No conviene eliminar Drift, gráficos o respaldo sin medir: son parte del valor actual.

La revisión SpaceX sí se aplicó parcialmente: se eliminó el login obligatorio, se dejó Drive como respaldo opcional, se evitó versionar secretos, se añadió preflight/CI y se retiraron marketplace, clima, rutas y comunidad de la v1. Sin embargo, el flujo OAuth Web aún demuestra que **simplificar la UI no basta si la arquitectura depende de una sesión de navegador volátil**. Ese bloqueador debe resolverse antes de ampliar el producto.

## Calendario y notificaciones

El registro de mantenimiento ya contiene `nextServiceDate` y `nextServiceKm`, por lo que el punto correcto de integración es después de guardar o actualizar un servicio. Para Android e iOS, `device_calendar` 4.3.3 ofrece permisos, creación, actualización, eliminación, recurrencias, recordatorios y zonas horarias; requiere permisos de calendario en Android y claves de privacidad en iOS [6]. `add_2_calendar` 3.1.1 es más liviano y abre la aplicación de calendario para confirmar el evento, pero es menos adecuado si MotoCheck debe actualizar o eliminar eventos propios después [7].

La recomendación técnica es **no pedir permisos al instalar ni al abrir la app**. Cuando el usuario marca “Agregar al calendario” después de programar el próximo servicio, MotoCheck debe explicar el motivo, solicitar permiso nativo y crear un evento con título, moto, kilometraje, taller/notas, alarma y un identificador interno. En Web no existe un permiso equivalente para modificar el calendario local del sistema; debe ofrecerse un archivo `.ics` descargable o un enlace “Agregar a Google Calendar”.

El diseño mínimo de v1 debe guardar en Drift únicamente el identificador del evento, plataforma/calendario elegido, fecha sincronizada y estado de sincronización. No debe duplicar eventos si el usuario edita el servicio. El evento del calendario debe ser una proyección del registro de mantenimiento, no otra fuente de verdad.

## Decisiones propuestas

| Decisión | Recomendación | Motivo |
|---|---|---|
| Núcleo v1 | Mantenimiento, combustible, refacciones, alertas, calendario opcional y Drive opcional | Mantiene una promesa clara y local-first |
| Marketplace | Diferir | Añade pagos, inventario, logística, impuestos y soporte antes de validar el núcleo |
| Clima/rutas | Diferir a fase posterior | Requiere ubicación, mapas, proveedor, caché y seguridad de conducción |
| Comunidad | Diferir | Requiere moderación, identidad, privacidad y backend |
| Calendario | Implementar como proyección opcional del mantenimiento | Es una extensión pequeña y accionable del dato ya existente |
| OAuth Web | Resolver con arquitectura de sesión apropiada, no seguir acumulando parches | El plugin Web mantiene estado principalmente en memoria y puede requerir reautenticación |

## Fuentes

[1]: https://play.google.com/store/apps/details?id=com.motorcheck.app "MotorCheck Fuel Tracker — Google Play"

[2]: https://www.motometeo.com/ "MotoMeteo — Route Weather for Motorcyclists"

[3]: https://apps.apple.com/us/app/detecht-motorcycle-app-gps/id1373032762 "Detecht — App Store"

[4]: https://play.google.com/store/apps/details?id=com.calimoto.calimoto&hl=en_US "calimoto — Google Play"

[5]: https://calimoto.com/en "calimoto — sitio oficial"

[6]: https://pub.dev/packages/device_calendar "device_calendar 4.3.3 — Pub.dev"

[7]: https://pub.dev/packages/add_2_calendar "add_2_calendar 3.1.1 — Pub.dev"
