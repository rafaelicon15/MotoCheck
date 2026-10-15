# PRD — MotoCheck

> Documento de requisitos de producto. Describe la app tal como existe en el código (versión 1.0.0+3, octubre 2026) y lo que falta para el lanzamiento público.

## 1. Resumen

MotoCheck es una app Android para que un motociclista lleve el historial de su moto: cargas de combustible, servicios de mantenimiento y refacciones con su vida útil en kilómetros. Con esos registros le dice cuánto rinde su moto (km/L), qué servicio toca y qué pieza está por vencer.

Funciona sin cuenta y sin internet. Google Drive es un respaldo opcional.

**Promesa:** *Conoce tu moto. Cuídala mejor.*

## 2. Problema

- El historial de una moto vive en notas del celular, tickets de taller, la memoria del dueño o en ningún lado.
- El dueño no sabe cuándo le toca el siguiente cambio de aceite, cadena o balatas hasta que algo falla.
- No sabe si su moto rinde bien de gasolina ni si el octanaje o un aditivo hacen diferencia.
- Las apps existentes son generalistas de vehículos (Drivvo) o piden cuenta antes de dejarte usarlas.

## 3. Usuario objetivo

**Primario:** dueño de moto de uso diario en Latinoamérica hispanohablante (empezando por México), moto de 110 a 400 cc, que hace él mismo parte del mantenimiento o lo manda al taller y quiere llevar el control.

**Ejemplos:** repartidor que vive de su moto y necesita que no se detenga; commuter que usa la moto para ir al trabajo; aficionado que cuida su moto como proyecto.

**Secundario:** dueño de varias motos (la app soporta varias y alterna la activa).

**No es para (por ahora):** talleres que administran motos de clientes, flotillas, autos.

## 4. Propuesta de valor

| Para el usuario | Cómo lo resuelve la app |
|---|---|
| "No quiero registrarme para probarla" | Botón "Usar sin cuenta"; todo se guarda en el teléfono |
| "Quiero saber qué toca" | Alertas de refacciones por km y recordatorios de servicio |
| "¿Cuánto rinde mi moto?" | km/L por carga, promedio, autonomía y comparativa por tipo de gasolina |
| "La app no conoce mi moto" | El perfil adapta categorías y refacciones a 2T/4T, carburada/inyección, cadena/cardán/CVT y tipo de rin |
| "Si cambio de celular pierdo todo" | Respaldo opcional en Google Drive y restauración al iniciar sesión |

## 5. Funcionalidades actuales (v1.0.0+3)

Prioridad: **P0** imprescindible para lanzar, **P1** importante, **P2** deseable.

| Módulo | Funcionalidad | Prioridad | Estado |
|---|---|---|---|
| Bienvenida | Usar sin cuenta o continuar con Google | P0 | ✅ |
| Motos | Alta, edición, varias motos, moto activa, eliminar (borra sus registros) | P0 | ✅ |
| Motos | Perfil técnico: motor 2T/4T, combustible, transmisión, rin, refrigeración, aceite, filtro, tanque | P0 | ✅ |
| Combustible | Registrar carga: fecha, litros, precio/L, odómetro, tipo de gasolina, aditivo, lleno/parcial | P0 | ✅ |
| Combustible | km/L full-to-full, promedio, autonomía, gráfica, comparativa por gasolina/aditivo, filtros | P1 | ✅ |
| Combustible | Detección de anomalías (fuera de 3–60 km/L) y cargas parciales excluidas de estadísticas | P1 | ✅ |
| Mantenimiento | Registrar servicio: tipo, ítems, costo, taller, aceite, próximo servicio por fecha y/o km | P0 | ✅ |
| Mantenimiento | Categorías e ítems según el perfil de la moto | P1 | ✅ |
| Refacciones | Lista con intervalo en km y progreso; cargar refacciones comunes según la moto | P0 | ✅ |
| Refacciones | Registrar cambio (actualiza km y guarda historial); historial editable | P0 | ✅ |
| Refacciones | Un servicio registrado actualiza las refacciones relacionadas | P1 | ✅ |
| Dashboard | Moto activa, último km/L, próximo servicio, alertas de refacciones (≤ 500 km) | P0 | ✅ |
| Recordatorios | Notificación 3 días antes y el día del servicio; aviso agrupado de refacciones por km | P1 | ✅ (falta probar en dispositivo) |
| Respaldo | Conectar Google Drive, respaldar, restaurar; respaldo automático tras cada cambio | P1 | ✅ |
| Ajustes | Moneda (20 monedas de LATAM, USD y EUR) | P2 | ✅ |
| Todos | Editar y eliminar cualquier registro | P0 | ✅ |

## 6. Fuera de alcance (v1)

- iOS (el proyecto compila, pero no se publica en App Store en esta etapa).
- Cuentas propias, servidores o sincronización entre dispositivos en tiempo real.
- Funciones sociales, comunidad o compartir historial.
- Recordatorios por kilómetros en segundo plano (sin GPS ni lectura del odómetro: los km se actualizan solo cuando el usuario registra algo).
- Monetización (la app es gratis).

## 7. Backlog (después del lanzamiento)

| Idea | Valor | Prioridad |
|---|---|---|
| Exportar historial a PDF/CSV (útil para vender la moto) | Alto | P1 |
| Documentos y vencimientos: seguro, tenencia, verificación, licencia | Alto | P1 |
| Foto de la moto en el perfil | Medio | P2 |
| Widget de pantalla de inicio con la refacción más crítica | Medio | P2 |
| Inglés | Bajo para LATAM | P2 |
| Gasto total y costo por km | Alto | P1 |

## 8. Métricas de éxito

| Etapa | Métrica | Dónde se mide |
|---|---|---|
| Adquisición | Visitas y clics en descargar por campaña/creador (`utm_*`, `ref`) | Landing: GA4 / Meta Pixel (evento `app_download`) |
| Adquisición | Instalaciones | Google Play Console |
| Activación | % que registra una moto y al menos un registro en las primeras 24 h | Pendiente: la app no tiene analítica |
| Retención | % activo a los 30 días | Play Console (retención de instalaciones) |
| Calidad | Calificación en Play ≥ 4.3, crashes < 1% | Play Console |

> La app no tiene analítica propia. Decidir si se agrega (y declararlo en Play y en el aviso de privacidad) antes de medir activación.

## 9. Riesgos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| La migración de base de datos borra todo al cambiar el esquema | **Crítico**: pérdida de datos de usuarios | Migraciones incrementales antes de publicar (ver plan) |
| Perder la llave de firma | No se puede actualizar la app | Guardar keystore y contraseñas en dos lugares |
| La landing promete algo que la app no hace | Malas reseñas, desconfianza de creadores | Revisar landing contra este PRD en cada release |
| El APK de prueba (firma debug) no se puede actualizar a la versión firmada | Usuarios de prueba pierden datos | Pedirles respaldar en Drive antes de reinstalar |
| Intervalos de mantenimiento incorrectos para una moto concreta | Daño a la moto / confianza | Intervalos editables y aviso de seguir el manual del fabricante |

## 10. Documentos relacionados

- [02 — Requisitos técnicos](../ESTADO.md#stack-técnico) (stack en `ESTADO.md`) y [RELEASE.md](../RELEASE.md)
- [03 — Flujo de la app](03-FLUJO-APP.md)
- [04 — Diseño](../ESTADO.md#notas-de-diseño) (notas en `ESTADO.md`)
- [05 — Esquema de datos](05-ESQUEMA-DATOS.md)
- [06 — Plan de lanzamiento](06-PLAN-LANZAMIENTO.md)
