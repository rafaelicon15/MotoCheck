# Diagnóstico OAuth Web — MotoCheck

## Síntoma reproducido

En el preview Web, desde Configuración, al pulsar **Conectar con Google** aparece `No se pudo conectar con Google`. La aplicación local-first continúa funcionando y los datos locales no se bloquean.

## Evidencia

| Comprobación | Resultado |
|---|---|
| Preview probado | `https://motocheck-web-preview-lr35gybfc-rafael-s-projects-4c5bba13.vercel.app` |
| `GOOGLE_WEB_CLIENT_ID` en el entorno de compilación del sandbox | Ausente; solo se registró presencia/ausencia, nunca el valor |
| Client ID OAuth compilado en `main.dart.js` | No hay un literal de client ID Google válido |
| `web/index.html` | No contiene meta `google-signin-client_id` |
| Estado esperado | El plugin Web no puede inicializar Google Identity Services sin Client ID |
| Categoría | Configuración OAuth Web, no fallo de Drift ni de datos locales |

## Causa técnica

El build de Flutter se generó sin `--dart-define=GOOGLE_WEB_CLIENT_ID=<CLIENT_ID>`. El servicio usaba un `GoogleSignIn` global; al intentar conectar, el plugin Web no tenía `clientId` y el widget solo mostraba el mensaje genérico.

## Corrección aplicada

`google_auth_service.dart` ahora crea `GoogleSignIn` de forma diferida, devuelve un estado desconectado seguro cuando OAuth no está configurado y expone un mensaje accionable. `settings_screen.dart` ya no muestra un botón que necesariamente fallará cuando falte el Client ID. `drive_backup_service.dart` no inicializa Google durante el auto-backup si OAuth no está configurado.

## Lo que todavía requiere configuración externa

Para conectar realmente Google Drive se necesita crear/configurar un cliente OAuth Web en el proyecto Google Cloud `motocheck-500004`, habilitar Google Drive API, registrar como origen autorizado la URL HTTPS del preview y compilar con:

```bash
flutter build web --release \
  --dart-define=GOOGLE_WEB_CLIENT_ID=<CLIENT_ID_WEB>
```

El valor real debe permanecer en el entorno seguro de CI/Vercel o en la máquina de desarrollo. No debe guardarse en Git ni pegarse en el chat. La URL de preview cambia por deployment; para una prueba estable conviene autorizar el dominio de preview permanente o un dominio propio antes de realizar la prueba OAuth final.

## Clasificación

`AUTH-003`: bloqueado por configuración OAuth Web pendiente. La corrección de código evita el fallo genérico, pero no puede inventar ni sustituir el Client ID de Google Cloud.
