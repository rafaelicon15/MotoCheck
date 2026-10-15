# Documentación de MotoCheck

Los 6 documentos que le dan a un agente (o a cualquier persona) el contexto completo de la app. Léelos en este orden antes de hacer cambios.

| # | Documento | Archivo |
|---|---|---|
| 1 | PRD — qué es, para quién, funciones, métricas, riesgos | [01-PRD.md](01-PRD.md) |
| 2 | Requisitos técnicos — stack, build, firma, despliegue | [ESTADO.md](../ESTADO.md#stack-técnico), [RELEASE.md](../RELEASE.md), [AUDITORIA.md](../AUDITORIA.md) |
| 3 | Flujo de la app — pantallas, navegación, qué hace cada botón | [03-FLUJO-APP.md](03-FLUJO-APP.md) |
| 4 | Diseño — colores, tarjetas, componentes | [ESTADO.md](../ESTADO.md#notas-de-diseño) y `lib/core/theme/app_theme.dart` |
| 5 | Esquema de datos — tablas, relaciones, auth, respaldo, migraciones | [05-ESQUEMA-DATOS.md](05-ESQUEMA-DATOS.md) |
| 6 | Plan de lanzamiento — fases, dependencias, responsables | [06-PLAN-LANZAMIENTO.md](06-PLAN-LANZAMIENTO.md) |

**Landing:** dirección visual en `motocheck-landing/ideas.md`, distribución en `motocheck-landing/docs/DISTRIBUTION_RUNBOOK.md` y SEO en `motocheck-landing/docs/SEO_GEO_STRATEGY_2026-08-18.md`.

**Regla:** si un cambio altera una función, un flujo o una tabla, actualiza el documento correspondiente en el mismo commit.
