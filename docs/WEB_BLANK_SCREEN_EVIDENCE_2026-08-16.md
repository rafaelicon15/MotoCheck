# MotoCheck — Evidencia de pantalla blanca Web

| Campo | Resultado |
|---|---|
| Fecha | 2026-08-16 GMT-4 |
| Preview | `https://motocheck-web-preview-e0ohsmt2m-rafael-s-projects-4c5bba13.vercel.app` |
| Navegador | Chrome conectado del usuario |
| Título | `MotoCheck` |
| Reproducción | La pestaña abre, pero no expone contenido visual ni elementos interactivos después de esperar la carga. |
| HTTP raíz | 200 OK, confirmado previamente |
| Recursos estáticos | HTML, `flutter_bootstrap.js`, `main.dart.js`, `drift_worker.js`, `sqlite3.wasm` y `AssetManifest.bin` respondieron 200 previamente |
| Captura | La transferencia de screenshot falla en la sesión del navegador; no se usa como prueba de que el canvas esté correcto. |
| Clasificación provisional | Bloqueador Web de runtime, causa aún no aislada |

La hipótesis inicial es un error JavaScript durante la inicialización de Flutter Web/Drift o una incompatibilidad del payload estático, no un error HTTP de Vercel. Se requiere capturar errores de consola o reproducir con un servidor local y una herramienta Chromium del sandbox.

## Revalidación después de la corrección Drift

Se desplegó `https://motocheck-web-preview-lr35gybfc-rafael-s-projects-4c5bba13.vercel.app` con `DriftWebOptions` explícito y estado Vercel `READY`. La pestaña conserva el título `MotoCheck`, pero Chrome continúa sin exponer contenido ni controles después de esperar la carga. La causa Drift era real y se corrigió, pero el blanco persiste; debe aislarse una segunda causa, probablemente la inicialización global de Google OAuth sin Client ID o un error runtime de Flutter Web.
