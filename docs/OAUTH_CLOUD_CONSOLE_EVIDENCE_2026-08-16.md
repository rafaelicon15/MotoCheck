# Evidencia de Google Cloud OAuth — 2026-08-16

Se revisó en modo lectura la página de credenciales del proyecto Google Cloud `motocheck-500004` usando la sesión autenticada del propietario.

| Recurso | Estado observado |
|---|---|
| Proyecto | MotoCheck (`motocheck-500004`) |
| Cliente OAuth Android | Existe: `Cliente de Android 1`, creado el 20 jun 2026 |
| Cliente OAuth Web | No aparece en la tabla de clientes OAuth 2.0 |
| Claves API | No hay claves visibles |
| Cuentas de servicio | No hay cuentas visibles |
| Acción realizada | Ninguna modificación; no se creó ni eliminó credencial |

Conclusión: el preview Web no puede conectar Google Drive porque no existe todavía un cliente OAuth Web en Google Cloud y el build tampoco contiene `GOOGLE_WEB_CLIENT_ID`. La siguiente acción requiere crear un cliente OAuth Web, habilitar/verificar Drive API, agregar los orígenes autorizados y recompilar el preview con el ID mediante un canal seguro.

La consola permaneció autenticada con `rafaelicon15@gmail.com` y mostró el menú **Crear credenciales → ID de cliente de OAuth**. La acción de creación todavía no se había ejecutado en esta evidencia; el único cliente existente seguía siendo Android.

El cambio de cuenta se confirmó: la consola muestra `Rafael Licón — motocheck.mail@gmail.com`. Al abrir Credenciales con `authuser=1`, Google Cloud solicita seleccionar país y aceptar las Condiciones del Servicio antes de seleccionar un proyecto. No se aceptaron condiciones ni se modificaron recursos en este paso.

Con `motocheck.mail@gmail.com` activa, el selector de proyectos no encontró `motocheck-500004` y mostró **No hay recursos para mostrar**. Por tanto, esta cuenta todavía no tiene acceso visible al proyecto MotoCheck. No se creó cliente OAuth Web ni se modificó el proyecto en este paso.

Desde la cuenta propietaria `rafaelicon15@gmail.com` se abrió **Otorgar acceso** en IAM para el proyecto MotoCheck. Se introdujo `motocheck.mail@gmail.com` como entidad nueva, pero todavía no se guardó la asignación ni se seleccionó rol.

En el formulario IAM se buscó el rol básico **Editor** y Google Cloud mostró un resultado que permite ver, crear, actualizar y borrar la mayoría de recursos. La asignación aún no se ha guardado; los clics directos sobre el resultado fueron rechazados por el DOM dinámico, por lo que se continuará mediante navegación por teclado o una vista actualizada.

El selector IAM aceptó el rol básico **Editor** para `motocheck.mail@gmail.com`. La asignación está preparada en el formulario, pero todavía no se ha pulsado **Guardar**.

La asignación se guardó correctamente. IAM ahora muestra `motocheck.mail@gmail.com` con rol **Editor** y conserva `rafaelicon15@gmail.com` como **Propietario**. Google Cloud indica que la política puede tardar unos minutos en activarse.

Con `motocheck.mail@gmail.com` y el rol Editor, Google Cloud ya permite acceder al proyecto `motocheck-500004`. Se abrió el formulario **Crear ID de cliente de OAuth**; todavía no se ha seleccionado tipo ni creado la credencial.

El formulario del cliente OAuth Web quedó preparado con:

- Nombre: `MotoCheck Web`.
- Origen JavaScript autorizado del preview actual: `https://motocheck-web-preview-dy3ukb57k-rafael-s-projects-4c5bba13.vercel.app`.
- Origen JavaScript autorizado local: `http://localhost:7357`.
- URIs de redireccionamiento: ninguno, porque el flujo actual de `google_sign_in_web` usa la interacción Web del navegador y no requiere un callback de servidor propio.

El cliente todavía no se ha creado.

Google Cloud confirmó **Se creó el cliente de OAuth** para `MotoCheck Web`. El cliente está habilitado y la consola mostró el Client ID y un secreto de cliente de una sola visualización. Por seguridad, no se copió, no se guardó ni se registró el secreto. El Client ID público se utilizará únicamente de forma segura para el build Web; no se incluirá el secreto en la app ni en Git.

El cliente `MotoCheck Web` ya aparece en la lista de clientes OAuth 2.0 como **Aplicación web** y **Habilitada**, junto al cliente Android existente. El Client ID se conservará únicamente en el entorno seguro de build; el secreto no se guardó.

La pantalla Público de Google Auth Platform está en estado **Prueba** y tipo **Usuarios externos**. Muestra 1 usuario de prueba: `rafaelicon15@gmail.com`. Falta añadir `motocheck.mail@gmail.com` para poder probar el flujo con la cuenta de la app.

La sección de usuarios de prueba quedó visible. Un clic inicial abrió únicamente la ayuda informativa de “Usuarios de prueba y otros”; no se añadió ni modificó ningún usuario todavía.

En la ventana Agregar usuarios, `motocheck.mail@gmail.com` quedó convertido correctamente en una entrada de usuario de prueba. La lista aún no se ha guardado.

En Información de la marca, el correo de asistencia al usuario ya está seleccionado como `motocheck.mail@gmail.com`. La ficha aún no se ha guardado; el correo de contacto del desarrollador sigue mostrando `rafaelicon15@gmail.com` y requiere revisión.

La ficha de marca quedó preparada para guardar con `motocheck.mail@gmail.com` como correo de asistencia y también como contacto del desarrollador. Google conserva además el contacto original `rafaelicon15@gmail.com`; no se eliminará para no perder notificaciones existentes.

## 2026-08-16 — AUTH-003: corrección de `origin_mismatch`

El primer intento de autorización desde el deployment `https://motocheck-web-preview-cvd8qodzf-rafael-s-projects-4c5bba13.vercel.app` devolvió en Google el error **400: `origin_mismatch`**. La captura del usuario confirmó que el Client ID sí fue reconocido y que el rechazo ocurrió porque el origen exacto del deployment no estaba autorizado.

En Google Auth Platform → Clientes → `MotoCheck Web`, se comprobó que los orígenes existentes eran:

| URI | Estado |
|---|---|
| `https://motocheck-web-preview-dy3ukb57k-rafael-s-projects-4c5bba13.vercel.app` | Existente |
| `http://localhost:7357` | Existente |
| `https://motocheck-web-preview-cvd8qodzf-rafael-s-projects-4c5bba13.vercel.app` | Añadido y guardado el 2026-08-16 |

La consola confirmó **“Se guardó el cliente OAuth”**. Google advierte que la propagación puede tardar desde unos minutos hasta algunas horas; se repetirá la autorización desde el preview después de la actualización.

No se modificó el Client ID, no se rotó el secreto y no se copió ningún secreto de cliente.

## 2026-08-16 — origen estable para previews de rama

El commit `b423121` generó el deployment `dpl_GyCxRTitgQM5nA4MxQHZ3YRz9FCN`, con alias `https://motocheck-web-preview-fk4smax0s-rafael-s-projects-4c5bba13.vercel.app`. Para evitar registrar un hostname distinto en cada commit, se añadió y guardó también el alias estable de la rama:

`https://motocheck-web-preview-git-fea-1440ff-rafael-s-projects-4c5bba13.vercel.app`

Ese alias responde HTTP 200 y queda como origen recomendado para la prueba OAuth del preview. El origen del deployment `cvd8qodzf` se conserva temporalmente porque ya fue utilizado y documentado.

## 2026-08-16 — corrección del deployment `fk4smax0s`

Una segunda captura del usuario confirmó **Error 400: `origin_mismatch`** desde `https://motocheck-web-preview-fk4smax0s-rafael-s-projects-4c5bba13.vercel.app`. La inspección de Google Cloud demostró que ese hostname temporal no estaba incluido todavía: la configuración tenía los orígenes `dy3ukb57k`, `localhost:7357`, `cvd8qodzf` y el alias estable de rama, pero no `fk4smax0s`.

Se añadió como URI 5 y la consola guardó el cliente OAuth. Este era un desajuste de hostname, no un problema de Drive API, scopes ni de necesidad de dominio propio. Se esperará la propagación anunciada por Google antes de repetir el consentimiento.

## 2026-08-16 — People API habilitada

Tras propagarse el origen, el flujo OAuth avanzó y devolvió un error nuevo y específico: **403 `PERMISSION_DENIED` / `SERVICE_DISABLED`** para `people.googleapis.com`. El mensaje de Google indicó que `google_sign_in_web` solicitó `https://content-people.googleapis.com/v1/people/me?...` para completar el perfil de la cuenta y que People API no se había usado antes o estaba deshabilitada.

Se abrió Google People API en el proyecto `motocheck-500004` y se pulsó **Habilitar**. La página de detalles confirma ahora `people.googleapis.com` con estado **Habilitada** y muestra el botón **Inhabilitar API**, que solo aparece cuando el servicio está activo. Drive API no se modificó porque ya estaba habilitada.

La siguiente prueba debe esperar la propagación de la API, usar el hostname `fk4smax0s` ya autorizado y comprobar primero la identificación de cuenta, luego el permiso `drive.appdata`, y finalmente la operación de respaldo.
