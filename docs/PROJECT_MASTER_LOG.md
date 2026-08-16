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
| Respaldo | Google Drive `appDataFolder` | Implementado; OAuth Web y Drive API configurados en modo Prueba; validación runtime pendiente |
| Autenticación | `google_sign_in` directo; no Firebase Auth | Google es opcional para backup |
| Android | `com.motocheck.motocheck` | Firma release pendiente de keystore real |
| iOS | `com.motocheck.motocheck` | Callback OAuth, certificados y prueba en Mac pendientes |
| Web | Flutter Web | Build release validado; preview OAuth recompilado localmente; despliegue versionado pendiente |

## 4. Cambios incorporados en la rama de trabajo

| Commit | Cambio | Estado |
|---|---|---|
| `0e93315` | Elimina login obligatorio; la app abre en modo local y Drive se conecta desde Configuración. Encauza client IDs OAuth por plataforma. Añade preflight, requisitos y documentación inicial. | Publicado en PR #1 |
| `14f2a84` | Reemplaza la migración Drift destructiva por migraciones incrementales para v8, v9 y v10. Añade plantillas de OAuth y firma. | Publicado en PR #1 |
| `33387c7` | Añade plan de QA y workflow de GitHub Actions para preflight, formato, análisis, tests y build Web. | Publicado en PR #1 |
| `ec83725` | Estabiliza el test local-first, normaliza formato/lints, documenta precios de dominios y evidencia del preview Web. | Publicado en PR #1; CI verde |

### Decisiones de código vigentes

La pantalla `AuthGate` y el login como condición de entrada fueron retirados. El dashboard abre directamente mediante `MainShell`. La cancelación o fallo de Google debe conservar el acceso a todos los datos locales. El flujo OAuth usa `GOOGLE_WEB_CLIENT_ID` en Web, `GOOGLE_IOS_CLIENT_ID` en iOS y el ID Web como `serverClientId` en Android.

La base Drift tiene versión 10. La migración ya no borra tablas: para versiones anteriores a 8 crea `PartHistory`; antes de 9 agrega `FuelRecords.isFull`; antes de 10 agrega `MotoProfile.rimType`. Antes de beta deben ejecutarse pruebas de migración desde snapshots reales v7, v8 y v9.

## 5. Credenciales y configuración segura

| Servicio | Identificador o recurso | Estado | Ubicación segura | Nunca guardar en Git |
|---|---|---|---|---|
| Google Cloud | Proyecto `motocheck-500004` | Existe | Consola de Google Cloud | Tokens, claves privadas |
| OAuth Web | Client ID Web | Configurado en Google Cloud para `MotoCheck Web`; Client ID público usado solo en build seguro | Variable `GOOGLE_WEB_CLIENT_ID` | Secretos OAuth y tokens |
| OAuth iOS | Client ID iOS y esquema reverso | Pendiente | Configuración iOS fuera de Git | Certificados Apple |
| OAuth Android | Package, SHA-1/SHA-256 debug/release/Play | Pendiente | Google Cloud / Play Console | Keystore y contraseñas |
| Android firma | `android/key.properties` | Pendiente | Equipo/CI seguro | `key.properties`, `.jks`, `.keystore` |
| Apple | Certificados, perfiles y App Store Connect | Pendiente | Cuenta Apple / CI seguro | `.p12`, perfiles, API keys |
| Vercel | Equipo `Rafael 's projects` | Conectado | Consola Vercel | Tokens de integración |
| GitHub | Cuenta conectada | Reconectado; push y CI verificados el 2026-08-16 | Conector GitHub | Tokens en chat o repositorio |

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
| GitHub Actions | Aprobado | Runs `31917725566` y `31918758896` verdes; preflight, formato, análisis, tests y build Web aprobados. GitHub muestra advertencias no bloqueantes de acciones que fuerzan Node.js 24 por deprecación de Node.js 20 |

La matriz completa de recorridos, entornos, severidad y criterios de salida está en `docs/QA_TEST_PLAN.md`. Cada fallo debe crear un issue con entorno, versión, pasos, resultado esperado, resultado real, evidencia, severidad, responsable y commit de corrección.

## 7. Bugs, bloqueos y riesgos activos

| ID | Área | Impacto | Estado | Siguiente acción |
|---|---|---|---|---|
| AUTH-001 | Android OAuth | Login/Drive pueden fallar por SHA o client ID | Bloqueado | Crear OAuth Android con huellas debug/release/Play |
| AUTH-002 | iOS OAuth | Callback no regresará a la app sin URL scheme | Bloqueado | Configurar cliente iOS, plist, Mac/Xcode |
| AUTH-003 | Web OAuth | El origen ya fue corregido; la conexión todavía falla después de iniciar el flujo y requiere validar el scope Drive | Código corregido; pendiente de prueba runtime | Se añadió el origen exacto del deployment, se evita `serverClientId` en Web, se solicita explícitamente `drive.appdata` y se conserva el error técnico; publicar el nuevo build y repetir autorización |
| DATA-001 | Migraciones Drift | Riesgo de incompatibilidad de versiones históricas | Pendiente | Probar snapshots v7/v8/v9 |
| BUILD-001 | Toolchain sandbox | Flutter/Dart ya disponible; Android SDK y Xcode todavía no | Parcialmente resuelto | Usar CI/equipo macOS para releases Android/iOS |
| BUILD-002 | Android release | Requiere keystore y Play App Signing | Pendiente | Crear keystore y validación AAB |
| TEST-001 | Cobertura | La suite todavía es insuficiente para beta | Pendiente | Añadir tests de datos, migraciones, backup y errores |
| WEB-001 | Preview Vercel | El preview estático entrega HTTP 200 e `index.html` de Flutter | Resuelto para preview base | Verificar el nuevo preview con OAuth y ejecutar CORE-01 a CORE-09 |
| WEB-002 | Pantalla blanca Web | `driftDatabase` Web se construía sin `DriftWebOptions`, lanzando `ArgumentError` durante el arranque | Corregido y verificado en preview | Mantener `sqlite3.wasm` y `drift_worker.js` en el artefacto; repetir CORE-01 a CORE-09 |
| GH-001 | GitHub push | La sesión inválida impedía publicar commits | Resuelto | Push de `33387c7` y `ec83725` completado; CI verde |

## 8. Despliegue Web de prueba

| Campo | Valor |
|---|---|
| Proyecto Vercel | `motocheck-web-preview` |
| Project ID | `prj_kkygL5KqJbSwAftxF3XZRNRQn5E6` |
| Equipo Vercel | `team_AJVdoCsQRoQyqnkQ7ImVH7sx` |
| Repositorio enlazado | `rafaelicon15/MotoCheck` |
| Rama desplegada inicialmente | `main` (`2769102`) |
| URL inicial | `https://motocheck-web-preview-5ln7va39w-rafael-s-projects-4c5bba13.vercel.app` — HTTP 404 histórico |
| Preview histórico | `https://motocheck-web-preview-mxka2gh5s-rafael-s-projects-4c5bba13.vercel.app` |
| Preview anterior | `https://motocheck-web-preview-e0ohsmt2m-rafael-s-projects-4c5bba13.vercel.app` |
| Preview actual corregido | `https://motocheck-web-preview-lr35gybfc-rafael-s-projects-4c5bba13.vercel.app` |
| Deployment ID actual | `dpl_56JawPdiqiHfE2wiBQkJUE2Rt4Po` |
| Estado infraestructura | `READY`; HTTP 200 y entrega `index.html` de Flutter |
| Verificación de runtime | Chromium headless renderiza `flt-glass-pane`, dashboard, tarjeta “Sin moto activa” y barra de navegación |
| Método temporal | Compilación local release, con `canvaskit` local excluido porque Flutter lo carga desde CDN; paquete expandido en Vercel a `dist` |
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
| 2026-08-16 | Se reconecta GitHub y se publica la rama | `33387c7` y `ec83725` publicados; PR #1 conserva la rama de trabajo |
| 2026-08-16 | GitHub Actions termina la validación | Run `31917725566` verde: preflight, formato, análisis, tests, build Web y artefacto |
| 2026-08-16 | Se reproduce pantalla blanca en preview anterior | Chrome conectado expone título `MotoCheck` pero no controles; se crea `WEB_BLANK_SCREEN_EVIDENCE_2026-08-16.md` |
| 2026-08-16 | Se corrige conexión Drift Web | `AppDatabase` recibe `DriftWebOptions` con `sqlite3.wasm` y `drift_worker.js`; analyze, tests y build Web pasan |
| 2026-08-16 | Se despliega preview corregido | Vercel `READY`; Chromium headless renderiza dashboard y navegación en `dpl_56JawPdiqiHfE2wiBQkJUE2Rt4Po` |
| 2026-08-16 | CI valida la corrección Drift Web | Run `31918758896` verde en preflight, dependencias, formato, análisis, tests, build Web y artefacto; quedan advertencias de deprecación de acciones Node.js |
| 2026-08-16 | Se diagnostica conexión Google Drive | El build no contiene `GOOGLE_WEB_CLIENT_ID`; se evita inicializar OAuth sin configuración y se añade mensaje accionable en Configuración; evidencia en `WEB_OAUTH_DIAGNOSIS_2026-08-16.md` |
| 2026-08-16 | Se reproduce `origin_mismatch` en el nuevo preview | Google reconoce el Client ID, pero el hostname `motocheck-web-preview-cvd8qodzf...vercel.app` no estaba registrado; se añadió y guardó como origen JavaScript autorizado |
| 2026-08-16 | Se reproduce fallo posterior a `origin_mismatch` | La app llega a la tarjeta Drive pero muestra error genérico; se corrige el flujo Web para no pasar `serverClientId`, solicitar `drive.appdata` explícitamente y conservar el diagnóstico técnico |

## 10. Dominio y presencia digital

La evaluación de precios vigente está en `docs/DOMAIN_PRICE_SNAPSHOT_2026-08-16.md`. La recomendación de trabajo es **no comprar por la promoción inicial**. Para una app de mantenimiento con alcance latinoamericano, `motocheck.lat` ofrece la mejor señal regional y una longitud razonable si se acepta una renovación de US$40.98/año, más cargos aplicables. `motocheck.store` y `motocheck.shop` comunican comercio antes de que exista el marketplace, por lo que no deben ser el dominio principal de v1. `motocheck.website` es genérico y no aporta diferenciación. `motocheck.motorcycles` tiene buena afinidad sectorial y renovación menor, pero la longitud reduce memorabilidad.

No se ha comprado ningún dominio. Antes de una compra: verificar precio final en carrito, cargo ICANN aplicable, renovación anual, privacidad, DNSSEC, renovación automática y propietario de la cuenta registradora.

## 11. Próximo ciclo ordenado

| Orden | Acción | Criterio de cierre |
|---|---|---|
| 1 | Ejecutar CORE-02 a CORE-09 manualmente en Chrome visible | Casos aprobados o issues registrados con evidencia |
| 2 | Configurar OAuth Web en Google Cloud | Login opcional y Drive probado con cuenta de prueba |
| 3 | Probar snapshots Drift v7, v8 y v9 | Migración preserva datos en evidencia automatizada |
| 4 | Automatizar build y despliegue estático desde CI | Preview reproducible desde commit remoto |
| 5 | Preparar Android AAB y prueba iOS | Sin bloqueadores por plataforma antes de beta |
| 6 | Corregir bloqueadores y repetir | Sin bugs bloqueadores/críticos para beta Web |

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
| `docs/WEB_BLANK_SCREEN_EVIDENCE_2026-08-16.md` | Reproducción, diagnóstico y verificación de la pantalla blanca Web |
| `docs/WEB_OAUTH_DIAGNOSIS_2026-08-16.md` | Evidencia y corrección del flujo OAuth Web/Drive |

A partir de esta actualización, el presente documento es la fuente de verdad legible. Los documentos especializados se mantienen como anexos técnicos y no deben contradecirlo.


## 12. Registro detallado de configuración OAuth Web — 2026-08-16

### 12.1 Cuenta operativa y permisos

La configuración se realizó con `motocheck.mail@gmail.com` como cuenta operativa de la aplicación. Como esa cuenta no veía inicialmente el proyecto, el propietario existente le concedió el rol **Editor** sobre `motocheck-500004`. El propietario original no fue eliminado y las acciones se mantuvieron dentro del proyecto MotoCheck.

### 12.2 Google Auth Platform

La pantalla de consentimiento quedó en estado **Prueba** y tipo de usuario **Usuarios externos**. La aplicación conserva el nombre `MotoCheck`; el correo de asistencia al usuario se cambió a `motocheck.mail@gmail.com`. El mismo correo se añadió a los contactos del desarrollador sin eliminar `rafaelicon15@gmail.com`, para preservar las notificaciones previamente configuradas.

Se añadió `motocheck.mail@gmail.com` como usuario de prueba. Mientras la aplicación permanezca en estado Prueba, solo las cuentas registradas como usuarios de prueba podrán completar el consentimiento; esto es una condición de Google Cloud y no una restricción implementada por MotoCheck.

### 12.3 Google Drive API y cliente Web

`drive.googleapis.com` aparece como **API habilitada** en el proyecto. Se creó el cliente OAuth **MotoCheck Web**, de tipo **Aplicación web**. Se registraron como orígenes autorizados el preview HTTPS usado para las pruebas y `http://localhost:7357` para el desarrollo local. No se configuró una URI de redireccionamiento de servidor porque el flujo actual usa `google_sign_in_web` desde el navegador y no mantiene un callback de servidor propio.

El Client ID Web se utilizó únicamente como valor público de compilación mediante `--dart-define=GOOGLE_WEB_CLIENT_ID`. El secreto que Google mostró durante la creación no se copió, no se guardó y no se incorporó al código, al build como secreto, a Git ni al chat. La evidencia detallada se conserva en `docs/OAUTH_CLOUD_CONSOLE_EVIDENCE_2026-08-16.md`.

### 12.4 Código y compilación

El servicio `GoogleAuthService` ahora evita inicializar Google Sign-In Web cuando falta el Client ID y devuelve un diagnóstico explícito. Configuración mantiene Drive como respaldo opcional; el auto-backup no consulta el usuario actual cuando OAuth no está configurado. Se compiló `flutter build web --release` con el Client ID público recién creado y la compilación terminó correctamente con tree-shaking de iconos y sin secretos detectados.

La verificación local de seguridad sobre el artefacto `preview-build` reportó cero coincidencias con marcadores de secretos OAuth. El artefacto contiene 24 archivos y ocupa aproximadamente 6,4 MB; CanvasKit local se excluyó porque el bootstrap de Flutter lo carga desde CDN, manteniendo `sqlite3.wasm` y `drift_worker.js`.

### 12.5 Vercel y limitaciones del despliegue

El intento de despliegue directo mediante un archivo comprimido fue rechazado por el límite de 3 MB por archivo del canal: primero el archivo comprimido superó ese límite y, después, `main.dart.js` fue rechazado por medir aproximadamente 3,8 MB. Este resultado se conserva como evidencia operativa y no como fallo de la aplicación.

Para resolverlo de forma reproducible se creó `vercel.json` con `buildCommand` no destructivo y `outputDirectory: preview-build`. El artefacto Web generado con OAuth se copió a `preview-build` para que Vercel lo sirva desde el repositorio enlazado, evitando el canal directo limitado. El despliegue versionado todavía debe confirmarse después de publicar estos cambios en la rama de trabajo.

### 12.6 Estado y próximos pasos de OAuth

El siguiente ciclo debe publicar `vercel.json` y `preview-build`, obtener la URL de preview resultante, añadir esa URL exacta como origen autorizado adicional si cambia el hostname y probar en Chrome la secuencia **Configuración → Conectar con Google → consentimiento → listar archivos de appDataFolder → restaurar copia**. La prueba debe realizarse con `motocheck.mail@gmail.com`, que ya está registrada como usuario de prueba.

## 13. Registro adicional — fallo posterior a `origin_mismatch` y corrección de scopes

La captura del usuario posterior a la corrección del origen mostró que la app ya alcanzaba su tarjeta de Google Drive, pero devolvía el mensaje genérico **“No se pudo conectar con Google”**. La revisión del paquete `google_sign_in_web 0.12.4+4` confirmó dos responsabilidades separadas: identificación de la cuenta y autorización del scope adicional `drive.appdata`. El código anterior ejecutaba `signIn()` y ocultaba cualquier excepción bajo un mensaje genérico; tampoco solicitaba explícitamente el scope cuando el login Web devolvía una cuenta.

La corrección aplicada en el siguiente commit hace lo siguiente:

| Cambio | Resultado esperado |
|---|---|
| No pasa `serverClientId` a Web | Evita una configuración no soportada por `google_sign_in_web`; Android conserva ese parámetro |
| Comprueba `canAccessScopes(['https://www.googleapis.com/auth/drive.appdata'])` | Distingue login de autorización de Drive |
| Ejecuta `requestScopes` durante la acción explícita del usuario | Permite conceder el acceso adicional antes de usar Drive API |
| Conserva `lastError` técnico sin tokens | La interfaz permite diagnosticar cancelación, scope denegado o excepción de plataforma |

## 14. Índice de evidencia relacionada

| ID de evidencia | Archivo | Contenido |
|---|---|---|
| EVID-OAUTH-001 | `docs/OAUTH_CLOUD_CONSOLE_EVIDENCE_2026-08-16.md` | Cambios y verificaciones realizados en Google Cloud Console |
| EVID-OAUTH-002 | `docs/WEB_OAUTH_DIAGNOSIS_2026-08-16.md` | Diagnóstico del Client ID ausente y guardas de OAuth |
| EVID-WEB-001 | `docs/WEB_BLANK_SCREEN_EVIDENCE_2026-08-16.md` | Reproducción y corrección de la pantalla blanca Web |
| EVID-WEB-002 | `docs/WEB_PREVIEW_VERIFICATION_2026-08-16.md` | Verificación de recursos y runtime del preview |
| EVID-DOM-001 | `docs/DOMAIN_PRICE_SNAPSHOT_2026-08-16.md` | Comparación de dominios y renovaciones |
| EVID-QA-001 | `docs/QA_TEST_PLAN.md` | Matriz CORE-01 a CORE-09 y pruebas de beta |


## Registro 2026-08-16 — contraste de datos de la moto

Las capturas del preview Web mostraron que la tarjeta de la moto activa utilizaba un degradado naranja muy luminoso y badges con colores independientes sobre una superficie igualmente naranja. Los nombres de marca/modelo se distinguían, pero los datos secundarios —año, kilometraje y especificaciones como `26507 km`, `4T`, `Radiador`, `Filtro metálico` y tipo de aceite— presentaban contraste insuficiente y una jerarquía visual débil.

Se aplicó una corrección localizada en `lib/features/dashboard/dashboard_screen.dart`: el degradado de la tarjeta ahora usa `#D84315 → #8E280F`, el año/kilometraje se muestra en blanco con opacidad 95 % y peso semibold, y `_MotoBadge` utiliza una superficie grafito semitransparente `#CC111117`, texto blanco de 11 px y borde blanco al 32 %. La lógica de selección, persistencia, Drift y respaldo no fue modificada.

La validación local pasó con `dart format lib/features/dashboard/dashboard_screen.dart`, `flutter analyze` sin incidencias y `flutter test` con todas las pruebas aprobadas. Se generó nuevamente `preview-build/` con build Web release y el Client ID OAuth público ya configurado. La verificación visual final debe hacerse en el preview desplegado, con especial atención a la lectura de chips en pantallas pequeñas y a la consistencia con el modo oscuro.

| Área | Estado | Riesgo restante |
|---|---|---|
| Contraste de tarjeta de moto | Validado en código y build local | Falta verificación visual en el deployment nuevo |
| Datos principales | Mejorados | Confirmar que no haya truncamiento en nombres largos |
| Badges técnicos | Mejorados | Revisar densidad si una moto tiene muchas especificaciones |
| OAuth/Drive | Funcional en Web tras habilitar People API | El respaldo real debe probarse con `Respaldar ahora` y `Restaurar` |

Referencia: cambio preparado después de la validación OAuth Web; commit pendiente de publicación junto con el artefacto Web actualizado.


## Registro 2026-08-16 — altura uniforme en Resumen rápido

La revisión visual del usuario mostró que las tarjetas **Último km/L** y **Próximo servicio** podían presentar alturas diferentes cuando sus widgets internos devolvían valores con distinta métrica visual. Para mantener una cuadrícula estable y evitar que el resumen se perciba desalineado, ambas tarjetas ahora se renderizan dentro de un `SizedBox(height: 108)` y `_StatCard` ocupa toda la altura disponible mediante `height: double.infinity`.

El cambio no altera los datos ni las reglas de negocio. Se mantienen intactos los streams de combustible y mantenimiento, incluidos los estados `—`, `Sin próx.`, `En N días` y los futuros estados de carga/error. La altura común se eligió para conservar el padding existente de 16 px, el encabezado, el icono y el valor principal sin introducir desplazamiento vertical innecesario.

| Validación | Resultado |
|---|---|
| Formato Dart | Aprobado; no hubo cambios adicionales tras `dart format` |
| Análisis estático | Aprobado; `flutter analyze` sin incidencias |
| Pruebas | Aprobadas; `flutter test` completo |
| Build Web | Aprobado; artefacto release regenerado con OAuth público existente |
| Preflight | Aprobado; no se detectaron secretos ni regresiones de arranque local-first |

La verificación visual pendiente consiste en comprobar el nuevo deployment en escritorio y pantalla angosta, confirmar que ambos cuadros conservan exactamente la misma altura y revisar que el texto dinámico no se desborde.


## Registro 2026-08-16 — diagnóstico de desconexión de Google en Web

La auditoría de `lib/services/google_auth_service.dart` y de `google_sign_in_web 0.12.4+4` muestra que MotoCheck no ejecuta `signOut()` automáticamente. La cuenta puede aparentar desconectarse por estas razones:

| Causa | Evidencia técnica | Efecto visible |
|---|---|---|
| Recarga, cierre o suspensión de la pestaña | `GoogleSignInNotifier` inicia con `AsyncValue.data(null)` y depende de `signInSilently()`; el plugin Web conserva `_lastCredentialResponse`, `_lastTokenResponse` y `_requestedUserData` en memoria | Configuración vuelve a mostrar “Conectar con Google” aunque la autorización previa de Drive pueda seguir vigente |
| Silent sign-in sin credencial recuperable | `signInSilently()` completa con `null` en momentos GIS no mostrados, omitidos o descartados; `_trySilentSignIn()` convierte ese resultado en `AsyncValue.data(null)` | La app interpreta ausencia temporal de identidad como desconexión |
| Expiración de credencial/token | El plugin considera al usuario autenticado mientras el último credential tenga expiración futura o exista `_requestedUserData`; `canAccessScopes` también devuelve `false` si el access token expiró | Una operación de respaldo puede fallar o exigir reautorización |
| Sesión del navegador/cookies de Google | Google Identity Services depende de la sesión del navegador y de sus políticas de privacidad; borrar cookies, usar incógnito o bloquear almacenamiento impide el silent sign-in | La cuenta no se recupera automáticamente |

La causa de diseño principal es que la app usa el estado en memoria del plugin como si fuera una sesión persistente. El ProviderScope único evita que cambiar de pestaña sea la causa; el problema aparece principalmente al recargar/reabrir Web, cuando GIS no devuelve identidad silenciosamente o cuando caduca el token.

La corrección recomendada es separar tres estados: `cuenta conocida`, `autorización Drive válida` y `token renovable`. MotoCheck debe conservar solo metadatos no sensibles de la última cuenta para mostrar estado informativo, reintentar `signInSilently()` al recuperar foco/visibilidad, renovar scopes antes de backup y mostrar “Requiere reconexión” en vez de borrar inmediatamente la cuenta por un `null` transitorio. Nunca se deben guardar access tokens, refresh tokens ni credenciales en Drift o LocalStorage.

La implementación inicial de esta corrección quedó aplicada en `b17937f` + cambios posteriores de sesión. `GoogleAccountNotifier.ensureDriveAccount()` intenta recuperar la cuenta con `signInSilently(suppressErrors: false)`, conserva el estado recuperado y, cuando la acción del usuario lo permite, solicita nuevamente `drive.appdata` antes de operar. Los botones **Respaldar ahora** y **Restaurar** ya no dependen únicamente de `currentUser` en memoria: ejecutan esta recuperación y muestran el diagnóstico si Google exige interacción. `GoogleSignInAccount.authHeaders` mantiene la renovación oficial de credenciales sin persistir tokens en la app.

La interfaz ahora comunica que la aplicación intenta recuperar la sesión automáticamente y cambia el botón a **Conectar o recuperar Google**. El estado de éxito usa el color de confirmación; los errores permanecen visibles para diagnóstico. Esta solución no promete una sesión permanente contra las políticas del navegador, pero evita pedir reconexión cuando Google todavía puede recuperar la autorización y garantiza que cada operación manual intente renovar la autenticación antes de fallar.
