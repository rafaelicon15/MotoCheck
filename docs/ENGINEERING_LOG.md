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
