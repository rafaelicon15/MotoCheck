# MotoCheck — Documento maestro vivo

> **Estado del documento:** activo. Este es el índice y registro central del proyecto. Cada cambio, configuración, bug, prueba, despliegue, decisión, riesgo, dependencia y referencia debe actualizarse aquí en el mismo ciclo en que ocurra. No se almacenan secretos, tokens, contraseñas, certificados, keystores ni datos personales.

| Campo | Valor |
|---|---|
| Producto | MotoCheck |
| Propietario de producto | Rafael Licón |
| Repositorio | `rafaelicon15/MotoCheck` |
| Rama de trabajo actual | `feat/local-first-oauth-simplification` |
| Pull request activo | [#1](https://github.com/rafaelicon15/MotoCheck/pull/1) |
| Meta de lanzamiento | Noviembre de 2026 |
| Plataformas | Android, iOS y Web |
| Estado de fase | Estabilización, pruebas Web y preparación de beta |
| Última actualización | 2026-08-16 GMT-4 |

## 1. Propósito y alcance

MotoCheck ayuda al rider a registrar la motocicleta, combustible, mantenimientos y refacciones para conocer el estado del vehículo y anticipar servicios. La aplicación es **local-first**: debe ser útil sin cuenta, sin conexión y sin depender de un servicio externo. Google Drive es un respaldo voluntario del historial, no una barrera de entrada.

El lema de trabajo es **“Conoce tu moto. Cuídala mejor.”** La marca MotoCheck se mantiene. El dominio, el logotipo definitivo y la identidad visual no deben bloquear la estabilización técnica.

### Alcance de v1

| Conservar en v1 | Decisión |
|---|---|
| Perfil y gestión de motocicletas | Incluido |
| Combustible y métricas de consumo | Incluido |
| Mantenimiento, refacciones y alertas | Incluido |
| Datos locales Drift/SQLite | Incluido |
| Respaldo/restauración opcional Google Drive | Incluido; bloqueado por OAuth real |
| Android, iOS y Web | Incluido; validación por plataforma pendiente |

| Diferir fuera de v1 | Razón |
|---|---|
| Marketplace, motos, pagos y envíos | Requiere backend, pagos, impuestos, moderación y soporte |
| Clima, rutas y mapas | Requiere datos, privacidad, ubicación y validación de producto |
| Comunidad, tracking y grupos | Requiere moderación, ubicación, batería y seguridad |
| Notificaciones push, fotos y exportación | No bloquean el caso principal de mantenimiento |

## 2. Principio de ingeniería

MotoCheck utiliza un ciclo de cinco pasos: cuestionar requisitos con dueño, eliminar complejidad, simplificar el diseño restante, acelerar solo recorridos estables y automatizar pasos repetitivos. Todo requisito necesita propietario, dolor concreto, evidencia de salida y decisión de alcance. El detalle operativo está en `docs/ENGINEERING_ALGORITHM.md` y el registro de requisitos en `docs/REQUIREMENTS_REGISTER.md`.

## 3. Arquitectura actual

| Capa | Decisión actual | Estado |
|---|---|---|
| App | Flutter con Dart null-safe y Riverpod | Activo |
| Datos | Drift/SQLite local | Activo; migraciones v8–v10 preservan datos |
| Respaldo | Google Drive `appDataFolder` | Implementado; OAuth pendiente de prueba real |
| Autenticación | `google_sign_in` directo; no Firebase Auth | Google es opcional para backup |
| Android | `com.motocheck.motocheck` | Firma release pendiente de keystore real |
| iOS | `com.motocheck.motocheck` | Callback OAuth, certificados y prueba en Mac pendientes |
| Web | Flutter Web | Build y prueba funcional en curso |

## 4. Cambios incorporados en la rama de trabajo

| Commit | Cambio | Estado |
|---|---|---|
| `0e93315` | Elimina login obligatorio; la app abre en modo local y Drive se conecta desde Configuración. Encauza client IDs OAuth por plataforma. Añade preflight, requisitos y documentación inicial. | Publicado en PR #1 |
| `14f2a84` | Reemplaza la migración Drift destructiva por migraciones incrementales para v8, v9 y v10. Añade plantillas de OAuth y firma. | Publicado en PR #1 |
| `33387c7` | Añade plan de QA y workflow de GitHub Actions para preflight, formato, análisis, tests y build Web. | Local; pendiente de publicar por sesión GitHub inválida |
| Pendiente de commit | Inyecta pantallas ligeras al `MainShell` y un executor opcional a Drift para pruebas deterministas. Corrige estilo de condiciones. | Validado localmente; pendiente de commit/push |
| Pendiente de commit | Añade `DOMAIN_PRICE_SNAPSHOT_2026-08-16.md`. | Validado; pendiente de commit/push |

### Decisiones de código vigentes

La pantalla `AuthGate` y el login como condición de entrada fueron retirados. El dashboard abre directamente mediante `MainShell`. La cancelación o fallo de Google debe conservar el acceso a todos los datos locales. El flujo OAuth usa `GOOGLE_WEB_CLIENT_ID` en Web, `GOOGLE_IOS_CLIENT_ID` en iOS y el ID Web como `serverClientId` en Android.

La base Drift tiene versión 10. La migración ya no borra tablas: para versiones anteriores a 8 crea `PartHistory`; antes de 9 agrega `FuelRecords.isFull`; antes de 10 agrega `MotoProfile.rimType`. Antes de beta deben ejecutarse pruebas de migración desde snapshots reales v7, v8 y v9.

## 5. Credenciales y configuración segura

| Servicio | Identificador o recurso | Estado | Ubicación segura | Nunca guardar en Git |
|---|---|---|---|---|
| Google Cloud | Proyecto `motocheck-500004` | Existe | Consola de Google Cloud | Tokens, claves privadas |
| OAuth Web | Client ID Web | Pendiente | Variable `GOOGLE_WEB_CLIENT_ID` | Secretos o tokens |
| OAuth iOS | Client ID iOS y esquema reverso | Pendiente | Configuración iOS fuera de Git | Certificados Apple |
| OAuth Android | Package, SHA-1/SHA-256 debug/release/Play | Pendiente | Google Cloud / Play Console | Keystore y contraseñas |
| Android firma | `android/key.properties` | Pendiente | Equipo/CI seguro | `key.properties`, `.jks`, `.keystore` |
| Apple | Certificados, perfiles y App Store Connect | Pendiente | Cuenta Apple / CI seguro | `.p12`, perfiles, API keys |
| Vercel | Equipo `Rafael 's projects` | Conectado | Consola Vercel | Tokens de integración |
| GitHub | Cuenta conectada | Sesión inválida desde 2026-08-15 | Reautenticación de conector | Tokens en chat o repositorio |

## 6. Pruebas y calidad

La primera puerta automática es `scripts/preflight.sh`. Revisa archivos sensibles rastreados, plantillas obligatorias, arranque local-first, variables OAuth y migraciones destructivas. La validación completa se ejecuta con `scripts/validate_release.sh`, que llama preflight, dependencias, formato, análisis, tests, build Web y AAB con análisis de tamaño.

| Nivel | Estado | Evidencia / acción requerida |
|---|---|---|
| Preflight | Aprobado | Repetido tras los cambios actuales |
| Formato Dart | Aprobado | Flutter 3.47 / Dart 3.13 en sandbox |
| `flutter analyze` | Aprobado | Sin incidencias el 2026-08-16 |
| `flutter test` | Aprobado | 1 prueba: arranque local-first sin Google |
| Build Web | Aprobado | `flutter build web --release` generó `build/web` correctamente |
| Build Android AAB | Pendiente | Requiere Android SDK y firma release |
| Build iOS | Pendiente | Requiere Mac, Xcode, certificados y dispositivo |
| OAuth/Drive | Pendiente | Requiere credenciales y dispositivos/navegadores reales |

La matriz completa de recorridos, entornos, severidad y criterios de salida está en `docs/QA_TEST_PLAN.md`. Cada fallo debe crear un issue con entorno, versión, pasos, resultado esperado, resultado real, evidencia, severidad, responsable y commit de corrección.

## 7. Bugs, bloqueos y riesgos activos

| ID | Área | Impacto | Estado | Siguiente acción |
|---|---|---|---|---|
| AUTH-001 | Android OAuth | Login/Drive pueden fallar por SHA o client ID | Bloqueado | Crear OAuth Android con huellas debug/release/Play |
| AUTH-002 | iOS OAuth | Callback no regresará a la app sin URL scheme | Bloqueado | Configurar cliente iOS, plist, Mac/Xcode |
| AUTH-003 | Web OAuth | Login puede fallar sin client ID/orígenes autorizados | Bloqueado | Configurar client ID Web y localhost/HTTPS |
| DATA-001 | Migraciones Drift | Riesgo de incompatibilidad de versiones históricas | Pendiente | Probar snapshots v7/v8/v9 |
| BUILD-001 | Toolchain sandbox | Flutter/Dart ya disponible; Android SDK y Xcode todavía no | Parcialmente resuelto | Usar CI/equipo macOS para releases Android/iOS |
| BUILD-002 | Android release | Requiere keystore y Play App Signing | Pendiente | Crear keystore y validación AAB |
| TEST-001 | Cobertura | La suite todavía es insuficiente para beta | Pendiente | Añadir tests de datos, migraciones, backup y errores |
| WEB-001 | Preview Vercel | El preview estático actual entrega HTTP 200 e `index.html` de Flutter | Resuelto para preview | Ejecutar CORE-01 a CORE-09 y automatizar despliegue desde CI |
| GH-001 | GitHub push | El conector GitHub quedó inválido tras el commit `33387c7` | Bloqueado | Reautenticar conector y publicar commit |

## 8. Despliegue Web de prueba

| Campo | Valor |
|---|---|
| Proyecto Vercel | `motocheck-web-preview` |
| Project ID | `prj_kkygL5KqJbSwAftxF3XZRNRQn5E6` |
| Equipo Vercel | `team_AJVdoCsQRoQyqnkQ7ImVH7sx` |
| Repositorio enlazado | `rafaelicon15/MotoCheck` |
| Rama desplegada inicialmente | `main` (`2769102`) |
| URL inicial | `https://motocheck-web-preview-5ln7va39w-rafael-s-projects-4c5bba13.vercel.app` — HTTP 404 histórico |
| Preview anterior | `https://motocheck-web-preview-mxka2gh5s-rafael-s-projects-4c5bba13.vercel.app` |
| Preview actual | `https://motocheck-web-preview-e0ohsmt2m-rafael-s-projects-4c5bba13.vercel.app` |
| Deployment ID actual | `dpl_GMnq2nbS7Tis3sdRMSbS3TAK6cDz` |
| Estado infraestructura | `READY`; HTTP 200 y entrega `index.html` de Flutter |
| Método temporal | Compilación local release, empaquetada por límite de 3 MB por archivo y expandida en Vercel a `dist` |
| Producción | No desplegada; no usar dominio propio todavía |

La ruta sostenible para Vercel es compilar Flutter Web en CI y desplegar únicamente la salida estática `build/web`. El método comprimido actual es válido para preview, pero debe reemplazarse por un flujo reproducible una vez publicada la CI de GitHub.

## 9. Registro cronológico

| Fecha | Evento | Resultado |
|---|---|---|
| 2026-08-01 | Auditoría inicial de código | Se identificaron OAuth incompleto, firma release y toolchain como riesgos |
| 2026-08-13 | Se crean plantillas de credenciales, runbooks, auditoría y roadmap | Documentación inicial disponible |
| 2026-08-14 | MotoCheck se confirma como nombre de trabajo | IDs técnicos se mantienen |
| 2026-08-15 | Se aplica algoritmo de ingeniería | Requisitos v1 delimitados y funciones futuras diferidas |
| 2026-08-15 | Se publica PR #1 con cambios local-first y migración no destructiva | `main` permanece sin cambios |
| 2026-08-15 | Se crea proyecto Vercel y preview inicial | Infraestructura disponible; entrega 404 por build Flutter ausente |
| 2026-08-15 | Se crea plan QA y workflow CI | Commit local `33387c7`, pendiente de reautenticación GitHub |
| 2026-08-16 | Se instala Flutter 3.47/Dart 3.13 y se ejecuta validación | Preflight, análisis, test y build Web aprobados |
| 2026-08-16 | Se corrige la prueba de shell local-first | Test aislado de SQLite/streams mediante pantallas inyectables y executor Drift opcional |
| 2026-08-16 | Se despliega el artefacto estático Web en Vercel | Preview HTTP 200 disponible; falta QA funcional |
| 2026-08-16 | Se evalúan dominios disponibles | Recomendación preliminar: `.lat` como principal si se mantiene foco LATAM; compra pendiente de decisión |
| 2026-08-16 | Se publica y verifica preview Web final | HTTP 200; raíz, JS, worker, SQLite WASM y manifest entregan recursos válidos |
| 2026-08-16 | Se ejecuta widget test contra Chromium | Aprobado: 1 prueba Web valida arranque de shell local-first |

## 10. Dominio y presencia digital

La evaluación de precios vigente está en `docs/DOMAIN_PRICE_SNAPSHOT_2026-08-16.md`. La recomendación de trabajo es **no comprar por la promoción inicial**. Para una app de mantenimiento con alcance latinoamericano, `motocheck.lat` ofrece la mejor señal regional y una longitud razonable si se acepta una renovación de US$40.98/año, más cargos aplicables. `motocheck.store` y `motocheck.shop` comunican comercio antes de que exista el marketplace, por lo que no deben ser el dominio principal de v1. `motocheck.website` es genérico y no aporta diferenciación. `motocheck.motorcycles` tiene buena afinidad sectorial y renovación menor, pero la longitud reduce memorabilidad.

No se ha comprado ningún dominio. Antes de una compra: verificar precio final en carrito, cargo ICANN aplicable, renovación anual, privacidad, DNSSEC, renovación automática y propietario de la cuenta registradora.

## 11. Próximo ciclo ordenado

| Orden | Acción | Criterio de cierre |
|---|---|---|
| 1 | Reautenticar GitHub y publicar `33387c7` y el siguiente commit local | GitHub Actions inicia en la PR |
| 2 | Ejecutar CORE-02 a CORE-09 manualmente en Chrome visible | Casos aprobados o issues registrados con evidencia |
| 3 | Configurar OAuth Web en Google Cloud | Login opcional y Drive probado con cuenta de prueba |
| 4 | Probar snapshots Drift v7, v8 y v9 | Migración preserva datos en evidencia automatizada |
| 5 | Automatizar build y despliegue estático desde CI | Preview reproducible desde commit remoto |
| 6 | Preparar Android AAB y prueba iOS | Sin bloqueadores por plataforma antes de beta |
| 7 | Corregir bloqueadores y repetir | Sin bugs bloqueadores/críticos para beta Web |

## 12. Referencias internas

| Documento | Rol |
|---|---|
| `docs/ENGINEERING_ALGORITHM.md` | Algoritmo de trabajo de cinco pasos |
| `docs/REQUIREMENTS_REGISTER.md` | Requisitos, dueños y decisiones de alcance |
| `docs/QA_TEST_PLAN.md` | Matriz de pruebas y salida a beta |
| `docs/GOOGLE_OAUTH_RUNBOOK.md` | Configuración Android/iOS OAuth |
| `docs/GOOGLE_OAUTH_SETUP.md` | Configuración técnica OAuth por plataforma |
| `docs/SECURITY_AND_CREDENTIALS.md` | Inventario seguro de credenciales sin valores |
| `docs/RELEASE_REQUIREMENTS.md` | Publicación, firma, tamaño y tiendas |
| `docs/ENGINEERING_LOG.md` | Bitácora histórica detallada |
| `docs/DOMAIN_PRICE_SNAPSHOT_2026-08-16.md` | Snapshot de precios, renovaciones y disponibilidad de dominios |
| `docs/WEB_PREVIEW_VERIFICATION_2026-08-16.md` | Evidencia HTTP, recursos críticos y límites de observabilidad del preview |

A partir de esta actualización, el presente documento es la fuente de verdad legible. Los documentos especializados se mantienen como anexos técnicos y no deben contradecirlo.
