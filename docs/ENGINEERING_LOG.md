# Registro de ingeniería de MotoCheck

Este documento es la bitácora central del proyecto. Cada cambio debe incluir fecha, alcance, motivo, archivos afectados, validaciones ejecutadas, riesgos y referencia al commit o issue correspondiente.

## Convención de estados

| Estado | Significado |
|---|---|
| Pendiente | Aún no se ha implementado o validado |
| En progreso | Se está trabajando activamente |
| Bloqueado | Requiere una credencial, decisión, dispositivo o acceso externo |
| Validado | Pasó la validación definida para su fase |
| Cerrado | Implementado, validado y documentado |

## Registro de cambios

| Fecha | Tipo | Descripción | Archivos / área | Validación | Estado | Referencia |
|---|---|---|---|---|---|---|
| 2026-08-13 | Auditoría | Se descomprimió el proyecto adjunto y se clonó el repositorio público `rafaelicon15/MotoCheck` para comparación. | Repositorio completo | Inventario y comparación de archivos | Validado | Auditoría inicial |
| 2026-08-13 | Auditoría | Se confirmó que la app usa `google_sign_in` y Google Drive `appDataFolder`, sin Firebase Auth. | `pubspec.yaml`, `lib/services/` | Lectura estática | Validado | Auditoría inicial |
| 2026-08-13 | Auditoría | Se identificó configuración OAuth incompleta para Android, iOS y Web. | `android/app`, `ios/Runner/Info.plist`, `web/index.html` | Revisión de plataforma | Bloqueado | Requiere client IDs |
| 2026-08-14 | Producto/Marca | Se confirma **MotoCheck** como marca de trabajo y no se renombrará la aplicación en esta etapa. Se congelan `com.motocheck.motocheck` para Android/iOS y el proyecto Google Cloud `motocheck-500004`. | `docs/NAME_EVALUATION.md`, `ESTADO.md`, configuración nativa | Decisión del propietario | Validado | Continuar identidad visual y dominio sin alterar IDs técnicos |
| 2026-08-13 | Documentación | Se creó una plantilla segura de inventario de credenciales y secretos. | `docs/SECURITY_AND_CREDENTIALS.md` | Revisión de seguridad | Validado | Auditoría inicial |
| 2026-08-13 | Documentación | Se creó este registro de ingeniería. | `docs/ENGINEERING_LOG.md` | Revisión documental | Validado | Auditoría inicial |
| 2026-08-13 | Configuración | Se configuró la firma Android release mediante `android/key.properties` y la build falla explícitamente si falta el keystore; no se permite publicar firmando con debug. | `android/app/build.gradle.kts`, `android/key.properties.example` | No ejecutable: Flutter/Gradle no disponibles en sandbox | Pendiente | Requiere keystore release |
| 2026-08-13 | Configuración | Se añadieron plantillas de client IDs para iOS y Web sin valores reales. | `ios/Runner/GoogleSignInConfig.example.xcconfig`, `web/google_sign_in_config.example.json` | Revisión estática | Pendiente | Requiere client IDs |
| 2026-08-13 | Configuración | Se identificó el proyecto Google Cloud `motocheck-500004`; la pestaña autenticada visible no es accesible desde la pestaña temporal automatizada. | `docs/SECURITY_AND_CREDENTIALS.md`, `docs/GOOGLE_CLOUD_CONSOLE_STEPS.md` | Captura del propietario; consola automatizada muestra login | Bloqueado | Configuración manual guiada |
| 2026-08-13 | Auth Web | Se añadió `google_sign_in_web` 0.12.4+4 y `google_sign_in_platform_interface` como dependencias directas; el botón oficial `renderButton` reutiliza `GoogleSignInPlatform.instance` y `onCurrentUserChanged` sincroniza AuthGate. | `pubspec.yaml`, `lib/services/google_sign_in_button*.dart`, `lib/services/google_auth_service.dart`, `lib/features/auth/auth_screen.dart` | No ejecutable: Flutter/Dart no disponibles en sandbox | Pendiente | Requiere `flutter pub get`, análisis y prueba Web |
| 2026-08-14 | Auth Android/iOS | Se separó `GOOGLE_IOS_CLIENT_ID` de `GOOGLE_WEB_CLIENT_ID`: iOS usará su client ID nativo y Android el client ID Web como `serverClientId`; no se guardan valores reales. | `lib/services/google_auth_service.dart` | Revisión estática; Flutter no disponible | Pendiente | Requiere client IDs y pruebas reales |
| 2026-08-14 | Auth Android/iOS | Se creó un runbook operativo para configurar consentimiento OAuth, Drive API, clientes Web/Android/iOS, huellas, callbacks y pruebas; además se añadió un script para imprimir huellas públicas sin exponer keystores. | `docs/GOOGLE_OAUTH_RUNBOOK.md`, `scripts/print_oauth_fingerprints.sh` | Revisión estática; consola autenticada no automatizable | Preparado | Ejecutar pasos en la pestaña visible y validar en dispositivos |
| 2026-08-15 | Arquitectura local-first | Se eliminó el login obligatorio y `AuthGate`: MotoCheck abre con datos locales y Google Drive queda como respaldo opcional desde Configuración. Se retiró la pantalla de login redundante y se actualizó la prueba de shell principal. | `lib/app.dart`, `lib/features/auth/auth_screen.dart` eliminado, `test/widget_test.dart` | No ejecutable: Flutter/Dart no disponibles | Pendiente | Ejecutar análisis y test; rollback: restaurar `AuthGate` y la pantalla eliminada |
| 2026-08-15 | OAuth multiplataforma | Se corrigió el enrutamiento de `clientId`: Web usa `GOOGLE_WEB_CLIENT_ID`, iOS usa `GOOGLE_IOS_CLIENT_ID`, Android conserva el ID Web como `serverClientId`. | `lib/services/google_auth_service.dart` | Revisión estática | Pendiente | Validar Android, iOS y Web con OAuth real |
| 2026-08-15 | Calidad/automatización | Se añadió `scripts/preflight.sh` y se integró al validador release. Verifica secretos rastreados, plantillas críticas, arranque local-first y enrutamiento de variables OAuth antes de Flutter. | `scripts/preflight.sh`, `scripts/validate_release.sh` | Preflight ejecutado correctamente en sandbox | Validado | Flutter/Dart siguen pendientes para formato, análisis, tests y builds |
| 2026-08-16 | Accesibilidad/UX | Se mejoró el contraste de la tarjeta activa de la moto: degradado naranja más oscuro, datos secundarios más legibles y badges con superficie grafito, texto blanco y borde visible. | `lib/features/dashboard/dashboard_screen.dart`, `preview-build/` | `dart format`, `flutter analyze` y `flutter test` pasan; build Web release generado | Validado | Commit de mejora visual; rollback revertiendo el commit |
| 2026-08-16 | UX/layout | Se fijó una altura común de 108 px para las tarjetas `Último km/L` y `Próximo servicio`, haciendo que `_StatCard` ocupe toda la altura disponible. | `lib/features/dashboard/dashboard_screen.dart`, `preview-build/` | `dart format`, `flutter analyze`, `flutter test`, build Web release y preflight pasan | Validado | Commit de layout; revisar visualmente en móvil y escritorio |
| 2026-08-16 | Diagnóstico OAuth Web | Se determinó que la aparente desconexión no proviene de `signOut()` automático: el plugin Web conserva identidad/tokens principalmente en memoria, `signInSilently()` puede devolver `null` y MotoCheck convierte ese resultado en cuenta desconectada. | `lib/services/google_auth_service.dart`, `google_sign_in_web 0.12.4+4`, `docs/PROJECT_MASTER_LOG.md` | Revisión estática del código de app y dependencia | Diagnóstico confirmado; corrección pendiente | Separar cuenta conocida, autorización Drive y token renovable; no persistir tokens |
| 2026-08-16 | OAuth/Drive resiliente | Se añadió `ensureDriveAccount()`: recupera silenciosamente la cuenta, renueva `drive.appdata` durante una acción explícita y se usa antes de respaldar/restaurar. La UI comunica recuperación y reconexión sin persistir tokens. | `lib/services/google_auth_service.dart`, `lib/features/settings/settings_screen.dart`, `preview-build/` | `dart format`, `flutter analyze`, `flutter test`, build Web release y preflight pasan | Validado localmente; pendiente prueba runtime del preview | El navegador puede exigir interacción si elimina cookies o bloquea GIS |
| 2026-08-15 | QA/CI | Se creó una matriz de pruebas para beta cerrada y un workflow de GitHub Actions que ejecuta preflight, formato, análisis, tests y build Web en ramas de trabajo y PRs. | `docs/QA_TEST_PLAN.md`, `.github/workflows/flutter-quality.yml` | Pendiente de primera ejecución remota | Pendiente | Revisar el primer run y convertir cada fallo en issue reproducible |
| 2026-08-13 | Validación estática | `pubspec.yaml` y plantilla JSON Web pasan validación; `plutil` no está disponible y `git diff --check` queda contaminado por CRLF heredado del proyecto adjunto. | Configuración OAuth | YAML/JSON OK; Dart/Plist no ejecutados | Pendiente | Validar en equipo Flutter |
| 2026-08-13 | Validación multiplataforma | El checkout contiene `android/`, `ios/`, `web/` y `test/`, pero el entorno actual no tiene `flutter`, `dart`, `adb`, `gradle` ni `xcodebuild`. | Todo el proyecto | Builds y tests no ejecutables aquí | Bloqueado por entorno | Ejecutar en equipo Flutter/macOS |
| 2026-08-13 | QA/Release | Se creó `scripts/validate_release.sh` para ejecutar doctor, pub get, analyze, tests, build Web y AAB con análisis de tamaño, guardando reportes en `build/reports/`. | `scripts/validate_release.sh` | Revisión estática del script | Preparado | Ejecutar en equipo Flutter; iOS requiere macOS/Xcode |

## Incidente de seguridad SEC-001

El registro compartido contiene un token de GitHub en texto plano. El valor no se copiará, utilizará ni almacenará en el proyecto. Debe considerarse comprometido y revocarse inmediatamente desde GitHub; posteriormente se debe revisar el historial del repositorio, los logs de CI y cualquier copia del archivo. Crear un token nuevo solo si es imprescindible, con acceso mínimo, expiración corta y nunca compartirlo en el chat. El incidente queda abierto hasta confirmar la revocación.

## Bugs y riesgos activos

| ID | Área | Problema | Impacto | Reproducción / evidencia | Prioridad | Responsable | Estado |
|---|---|---|---|---|---|---|---|
| AUTH-001 | Google Android | No está validada la combinación de package name, `serverClientId` y huellas SHA para debug/release/Play App Signing. | El inicio de sesión puede devolver configuración inválida o cancelación aparente. | Configuración nativa sin registro OAuth comprobable; documentación del paquete | Crítica | Proyecto | Bloqueado |
| AUTH-002 | Google iOS | Faltan `GIDClientID`/`GIDServerClientID` y `CFBundleURLTypes` en `Info.plist`. | El callback puede no regresar a la aplicación. | `ios/Runner/Info.plist` | Crítica | Proyecto | Bloqueado |
| AUTH-003 | Google Web | Falta meta `google-signin-client_id` y configuración de orígenes autorizados; el flujo web requiere revisar el botón oficial del SDK. | El login web puede no inicializar o fallar al autorizar. | `web/index.html` y API web del paquete | Crítica | Proyecto | Bloqueado |
| BUILD-001 | Toolchain | El entorno de auditoría no contiene Flutter ni Dart. | No se pueden ejecutar análisis, tests ni builds aquí. | Comando `flutter --version` no encontrado | Alta | Entorno | Bloqueado |
| BUILD-002 | Android release | La variante release todavía usa firma debug. | No se puede publicar de forma segura. | `android/app/build.gradle.kts` | Crítica | Proyecto | Pendiente |
| TEST-001 | Calidad | La cobertura actual no permite afirmar estabilidad multiplataforma; el proyecto solo incluye un test básico. | Riesgo de regresiones en base de datos, auth y navegación. | `test/` | Alta | Proyecto | Pendiente |
| SIZE-001 | Distribución | No existe una medición reproducible por arquitectura del APK/AAB ni reporte de assets. | No se puede optimizar con datos ni verificar el paquete de publicación. | Falta pipeline de tamaño | Media | Proyecto | Pendiente |

## Plantilla para registrar un cambio futuro

### [FECHA] — [ID / título]

**Objetivo.** Describir qué problema o necesidad se resuelve.

**Decisión.** Explicar la solución elegida y las alternativas descartadas.

**Archivos afectados.** Enumerar rutas concretas y migraciones.

**Validación.** Registrar comandos, dispositivos, navegadores, versiones y resultados.

**Riesgos y reversión.** Describir efectos secundarios, migraciones y cómo volver atrás.

**Referencia.** Añadir commit, pull request, issue o captura de evidencia sin incluir secretos.

## 2026-08-16 — Auditoría integral, GIS Web, contraste y calendario

**Objetivo.** Responder a la regresión reportada por el propietario: la sesión Google continúa cerrándose, la tarjeta de datos de la moto no tenía un contraste suficientemente claro y se requiere programar servicios en el calendario del usuario.

**Hallazgos.** El flujo Web anterior dependía de `signIn()` y del estado principalmente en memoria del plugin. La persistencia visual de una cuenta no equivale a disponer de un token válido para Drive; Web puede requerir una nueva interacción cuando se eliminan cookies, se revoca la autorización o el navegador no puede completar GIS silenciosamente. La tarjeta naranja seguía concentrando demasiados datos pequeños y emojis en una sola superficie. El registro público de competidores confirma que el valor de las apps exitosas proviene de una promesa focalizada: mantenimiento simple, clima contextualizado por ruta, seguridad del rider o navegación especializada.

**Decisiones.** Se reemplazó el botón Web de MotoCheck por el botón oficial de Google Identity Services mediante `google_sign_in_web` `renderButton`; Android/iOS conservan su flujo nativo. La tarjeta de moto pasó a una superficie grafito con acento naranja lateral, texto secundario centralizado y badges semánticos más grandes sin emojis. Para calendario se eligió `device_calendar` `4.3.3` en Android/iOS, solicitando permiso solamente cuando el usuario confirma “Agregar al calendario”. Web ahora genera un archivo `.ics` descargable con alarma de 24 horas, sin pedir permisos del sistema; queda pendiente validar la importación en Google Calendar, Apple Calendar y Outlook.

**Datos y migración.** Se añadió `MaintenanceRecords.calendarEventId` y se elevó Drift a schema v11 con migración aditiva. El identificador evita duplicar el evento al editar un servicio.

**Archivos afectados.** `lib/services/google_auth_button.dart`, `lib/services/google_auth_button_web.dart`, `lib/services/google_auth_button_stub.dart`, `lib/services/calendar_service.dart`, `lib/services/calendar_service_native.dart`, `lib/services/calendar_service_stub.dart`, `lib/services/calendar_result.dart`, `lib/features/settings/settings_screen.dart`, `lib/features/dashboard/dashboard_screen.dart`, `lib/features/maintenance/screens/maintenance_screen.dart`, `lib/data/database/app_database.dart`, `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`, `pubspec.yaml`, `pubspec.lock`, `docs/COMPETITOR_AND_PRODUCT_AUDIT_2026-08-16.md` y archivos generados de Drift.

**Validación.** `flutter pub get`, `dart format lib`, `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze` sin issues y `flutter test` con todas las pruebas exitosas. Falta prueba física en Android/iOS para permisos, creación/actualización de eventos y zona horaria; Web requiere prueba manual de descarga e importación del `.ics`.

**Riesgos y reversión.** `device_calendar` requiere permisos Android `READ_CALENDAR`/`WRITE_CALENDAR`, claves iOS `NSCalendarsUsageDescription`/`NSCalendarsFullAccessUsageDescription`, pruebas de zona horaria y atención a R8/ProGuard en release. El rollback de calendario consiste en revertir el commit de servicio y la migración v11; no se debe borrar la columna en una instalación existente. El rollback visual consiste en revertir el commit de tarjeta, sin afectar datos.

**Referencia.** Commit GIS/contraste/informe: `57d28dd`; dependencia GIS Web: `00ad426`; calendario: `b17ffaf`; CI verde en `31926435388` y `31926433445`; preview `motocheck-web-preview-5sb5rbmoh-rafael-s-projects-4c5bba13.vercel.app`. No se almacenan tokens, claves privadas ni credenciales.


## 2026-08-16 — WEB-003: actualización del preview y referencia Morphicons

**Objetivo.** Resolver la discrepancia reportada entre el rediseño publicado y una interfaz anterior todavía visible en Chrome, sin borrar el almacenamiento local-first del rider. Definir además una adopción de Morphicons que no cree una experiencia distinta entre Web, Android e iOS.

**Diagnóstico reproducible.** El 2026-08-16 se comparó el SHA-256 de `preview-build/main.dart.js`, el deployment inmutable `motocheck-web-preview-5sb5rbmoh-rafael-s-projects-4c5bba13.vercel.app` y el alias estable de la rama: los tres producen `5489963f82f21b8adf466a8bd5272ee72ef6504d68f95aef5cc49eb90ad5614e`. Vercel ya respondía con `public, max-age=0, must-revalidate`; por ello no existe evidencia de que el servidor entregue un JavaScript antiguo. El artefacto generado contiene un Service Worker de Flutter que intenta activarse, desregistrarse y navegar clientes, pero una pestaña ya controlada puede seguir presentando recursos en caché hasta actualizar el registro del worker.

**Decisión de despliegue.** `vercel.json` pasa a marcar `index.html`, `flutter_bootstrap.js`, `flutter_service_worker.js` y `version.json` como `Cache-Control: no-store, max-age=0`. Los binarios, fuentes, WASM y `main.dart.js` no se forzan a `no-store`, preservando rendimiento y la estrategia de caché normal del navegador. La recuperación manual segura consiste en desregistrar únicamente el Service Worker del sitio y recargar fuerte; no se debe usar “Clear site data”, porque eliminaría IndexedDB y puede borrar los registros locales del usuario.

**Decisión de iconografía.** La investigación oficial confirma que Morphicons tiene licencia MIT y ofrece motor SVG para DOM, React, Vue, Svelte, React Native, Astro y canvas, pero no un driver Flutter/Dart. Se adopta como referencia de movimiento y pares de estado, no como dependencia JavaScript global. La capa propuesta es `MotoIcon` con SVG de trazo versionados y `flutter_svg`, con `AnimatedSwitcher` como fallback accesible común. Un morph real queda bloqueado hasta que exista un adaptador Flutter que mantenga paridad de plataforma. El detalle está en `docs/MORPHICONS_ADOPTION_2026-08-16.md`.

**Archivos afectados.** `vercel.json`, `docs/MORPHICONS_ADOPTION_2026-08-16.md`, `docs/PROJECT_MASTER_LOG.md`, `docs/ENGINEERING_LOG.md`.

**Validación.** Cabeceras previas y hash remoto comparados con `curl` y `sha256sum`; el preview Web se capturó de forma independiente y muestra la superficie grafito, acento naranja lateral y estado vacío. La visualización de una moto activa continúa pendiente porque depende de la base local del navegador del usuario.

**Riesgos y reversión.** Las cabeceras `no-store` aumentan validaciones de archivos de arranque, no el peso del bundle. Se revierten eliminando el bloque `headers` de `vercel.json` si producen un comportamiento inesperado. No se eliminan datos ni se cambian migraciones. La decisión de Morphicons se revierte sin impacto funcional porque todavía no modifica widgets de producción.

**Referencia.** Commit pendiente de publicación desde la rama `feat/local-first-oauth-simplification`.


### Seguimiento WEB-003 — verificación del deployment `594cd35`

El deployment Git de Vercel `dpl_4AtvqLmfWoia9sPSWqf3sMV7ooJg` quedó en estado **READY** para el commit `594cd35`, con URL inmutable `https://motocheck-web-preview-6dselsbse-rafael-s-projects-4c5bba13.vercel.app` y alias de rama `https://motocheck-web-preview-git-fea-1440ff-rafael-s-projects-4c5bba13.vercel.app`. Ambas URL aplican `Cache-Control: no-store, max-age=0` a `flutter_bootstrap.js`, `flutter_service_worker.js` y `version.json`; `main.dart.js` mantiene `public, max-age=0, must-revalidate`.

La comprobación inicial reveló que Vercel resuelve la página de inicio como `/`, no como `/index.html`; por ello se añadió también una regla exacta de `no-store` para `/`. La navegación con Chrome conectado confirma título `MotoCheck` y carga de la URL, pero la captura de pantalla del canvas no se transfirió desde ese navegador. Este límite de observabilidad no se interpreta como fallo visual; la evidencia visual independiente del estado vacío y la confirmación con datos reales del propietario siguen siendo necesarias.


## 2026-08-16 — ICON-001: base SVG para Morphicons-compatible UI

**Objetivo.** Iniciar la migración de iconos sin bloquear Android/iOS/Web ni introducir una dependencia JavaScript solo para Web.

**Implementación.** Se añadió `flutter_svg` `2.3.0`, los SVG de trazo `chevron-down` y `chevron-up` de Lucide, el aviso de licencia ISC/MIT de origen y la carpeta de activos declarada en `pubspec.yaml`. `lib/core/widgets/moto_icon.dart` centraliza nombres semánticos, rutas, tintado, tamaño y accesibilidad. `AnimatedMotoIcon` usa `AnimatedSwitcher` con fade/scale de 180 ms y cambia a duración cero cuando `MediaQuery.disableAnimations` está activo.

**Integración inicial.** El selector expandible de categorías en Mantenimiento reemplaza `Icons.expand_more`/`Icons.expand_less` por el nuevo par SVG, manteniendo la interacción, color y texto semántico “Expandir opciones”/“Contraer opciones”. Es una migración acotada de un control con transición de estado, no una sustitución masiva de iconos Material.

**Licencia y relación con Morphicons.** Lucide publica los iconos bajo ISC e identifica estos chevrons como derivados de Feather con aviso MIT adicional. Morphicons mantiene la referencia de movimiento, pero no se incorpora código JavaScript porque no existe driver Flutter/Dart oficial. El fallback actual mantiene paridad de plataforma y respeta reducción de movimiento.

**Archivos afectados.** `pubspec.yaml`, `pubspec.lock`, `assets/icons/lucide/`, `lib/core/widgets/moto_icon.dart`, `lib/features/maintenance/screens/maintenance_screen.dart`, `test/moto_icon_test.dart`, `preview-build/`.

**Validación.** `dart format`, `flutter analyze` sin incidencias y `flutter test` con 3 pruebas aprobadas. `flutter build web --release --no-wasm-dry-run` completó correctamente con los dos SVG incluidos en el manifiesto de activos. CanvasKit local se retiró del preview porque el bootstrap usa el CDN de Flutter; el preview queda en aproximadamente 6.6 MB. La primera ejecución sin `--no-wasm-dry-run` produjo una salida no cero por una advertencia conocida de `record-use`, aunque generó `build/web`; no se usó ese resultado para publicar.

**Riesgos y reversión.** El paquete añade dependencias de render SVG y los nuevos activos son pequeños (474 bytes en total). Revertir el commit elimina la abstracción y devuelve el control a Material Icons, sin afectar datos, Drift, OAuth ni permisos.

**Referencia.** Commit pendiente de publicación.


### Seguimiento ICON-001 — entrega verificada

Vercel publicó `dpl_CFoXJicMWrMbpgAeSiweagfY7x6h` para `29ecf33` en estado **READY**. URL inmutable: `https://motocheck-web-preview-nrf2czv2n-rafael-s-projects-4c5bba13.vercel.app`. El SHA-256 de `main.dart.js` remoto y de `preview-build/main.dart.js` coincide: `0edacd315cc1d16c660e2bdc8b4c4ceb55a7003d50947bf8993ecf672b38be0c`. La ruta raíz y el bootstrap responden `Cache-Control: no-store, max-age=0`; el SVG de Lucide responde HTTP 200 con tipo `image/svg+xml`. La siguiente confirmación pendiente es visual y debe realizarse sobre datos locales existentes sin ejecutar limpieza de almacenamiento del sitio.


## 2026-08-16 — AUTH-004: `invalid_client` por Client ID Web desalineado

**Evidencia reportada.** La pantalla de Google mostrada por el propietario confirma `Error 401: invalid_client` y el mensaje “The OAuth client was not found”. Este error ocurre antes de solicitar o conceder el scope de Drive, por lo que no corresponde a una denegación de permisos, sesión o caché de MotoCheck.

**Verificación.** La consola Google Cloud del proyecto `motocheck-500004` muestra el cliente habilitado **MotoCheck Web**, de tipo Aplicación web, y sus orígenes incluyen el alias estable de la rama `motocheck-web-preview-git-fea-1440ff-rafael-s-projects-4c5bba13.vercel.app`. La huella SHA-256 del Client ID compilado en `preview-build/main.dart.js` no coincide con la huella del cliente Web habilitado en la consola. La causa inmediata queda clasificada como **build Web compilado con un Client ID diferente/obsoleto**.

**Acción planificada.** Reconstruir el artefacto Web con el identificador público del cliente **MotoCheck Web** actualmente habilitado, sin almacenar secretos OAuth ni modificar los orígenes autorizados. Posteriormente se verificará el hash publicado y se repetirá el login en el alias estable autorizado.


### Seguimiento AUTH-004 — publicación y validación pendiente

Vercel publicó `dpl_Ew7vV4Y6Hi33NuFVy6D4bN9fhs75` para el commit `4399f5f` en estado **READY**, con URL inmutable `https://motocheck-web-preview-lie4n8yck-rafael-s-projects-4c5bba13.vercel.app`. Tanto esa URL como el alias autorizado de rama devuelven el mismo SHA-256 de bundle (`bda79ee507c8b2ba93de796ca0b5fde656e6debef2ddf8535170fdd5760f0911`) y la huella del Client ID coincide con el cliente Web habilitado. El alias se abrió en Chrome conectado, pero el canvas de Flutter no expuso controles ni captura de pantalla al canal de inspección; por ello la comprobación final de consentimiento debe realizarse manualmente desde Configuración → Conectar o recuperar Google. No se deben borrar datos del sitio.
