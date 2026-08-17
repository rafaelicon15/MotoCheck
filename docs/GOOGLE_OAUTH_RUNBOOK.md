# MotoCheck — Runbook OAuth Android e iOS

**Proyecto Google Cloud:** `motocheck-500004`

**Android application ID:** `com.motocheck.motocheck`

**iOS Bundle ID:** `com.motocheck.motocheck`

Este procedimiento se ejecuta en la pestaña autenticada visible del propietario. No compartir contraseñas, códigos MFA, keystores ni valores privados por chat.

## 1. Preparar huellas Android

En un equipo con JDK y el checkout de MotoCheck, ejecutar:

```bash
./scripts/print_oauth_fingerprints.sh
```

Guardar únicamente las huellas SHA-1/SHA-256 en el gestor seguro del proyecto. Para OAuth Android se necesita, como mínimo, la huella debug para desarrollo y la huella del certificado release/Play App Signing para producción.

## 2. Configurar consentimiento OAuth

En Google Cloud Console, seleccionar `motocheck-500004`, abrir **APIs y servicios → Pantalla de consentimiento OAuth** y completar el nombre `MotoCheck`, correo de soporte y correo de contacto del desarrollador. Si el estado es **Testing**, añadir las cuentas de prueba del equipo. Para producción, preparar la política de privacidad, dominio autorizado y revisión de scopes sensibles si Google la solicita.

Habilitar **Google Drive API** desde **APIs y servicios → Biblioteca**. El scope que usa la app es `https://www.googleapis.com/auth/drive.appdata`; el login y la autorización de Drive son pasos distintos.

## 3. Crear cliente Web base

Abrir **APIs y servicios → Credenciales → Crear credenciales → ID de cliente OAuth**. Elegir **Aplicación web**. Registrar como orígenes autorizados, según corresponda:

```text
http://localhost
http://localhost:7357
https://<dominio-web-de-produccion>
```

Copiar el client ID público Web al gestor seguro. Este valor será `GOOGLE_WEB_CLIENT_ID` y también el `serverClientId` que Android necesita cuando no se usa `google-services.json`.

## 4. Crear cliente Android debug

Desde **Crear credenciales → ID de cliente OAuth → Android**, usar:

```text
Nombre: MotoCheck Android Debug
Package name: com.motocheck.motocheck
SHA-1: <huella SHA-1 debug>
```

Crear otro cliente para release si el certificado difiere. Cuando Play App Signing esté activo, registrar también la huella del certificado de aplicación que muestra Play Console. No colocar el client ID Android dentro de Dart; Google Sign-In Android lo resuelve mediante package y certificado, mientras Dart recibe el `serverClientId` Web.

## 5. Crear cliente iOS

Desde **Crear credenciales → ID de cliente OAuth → iOS**, usar:

```text
Nombre: MotoCheck iOS
Bundle ID: com.motocheck.motocheck
```

Copiar el client ID iOS y derivar su **URL scheme reverso** según el valor generado por Google. El valor se usará como `GOOGLE_IOS_CLIENT_ID` en Dart y como `GIDClientID` en `Info.plist`. El esquema reverso debe agregarse dentro de `CFBundleURLTypes`; sin él, el login puede abrir Google pero no regresar correctamente a MotoCheck.

## 6. Ejecutar MotoCheck

Android/iOS:

```bash
flutter run \
  --dart-define=GOOGLE_WEB_CLIENT_ID=<WEB_CLIENT_ID> \
  --dart-define=GOOGLE_IOS_CLIENT_ID=<IOS_CLIENT_ID>
```

Web local:

```bash
flutter run -d chrome --web-hostname localhost --web-port 7357 \
  --dart-define=GOOGLE_WEB_CLIENT_ID=<WEB_CLIENT_ID>
```

## 7. Validación mínima

| Caso | Android debug | Android release | iOS |
|---|---:|---:|---:|
| Selector de cuenta abre | Pendiente | Pendiente | Pendiente |
| Cancelar login conserva el acceso local | Pendiente | Pendiente | Pendiente |
| Cuenta existente queda disponible en Configuración | Pendiente | Pendiente | Pendiente |
| Drive solicita `drive.appdata` | Pendiente | Pendiente | Pendiente |
| Backup crea archivo en `appDataFolder` | Pendiente | Pendiente | Pendiente |
| Restore recupera datos | Pendiente | Pendiente | Pendiente |
| Logout elimina sesión local | Pendiente | Pendiente | Pendiente |

## 8. Errores frecuentes

`DEVELOPER_ERROR` o `ApiException: 10` normalmente indica package/SHA incorrectos o cliente Android creado en otro proyecto. Un retorno iOS que no vuelve a la app normalmente indica Bundle ID o URL scheme reverso incorrecto. Un login correcto seguido de error de Drive indica autorización del scope, no necesariamente un fallo del login. Un error Web de origen no autorizado se corrige agregando el origen exacto, incluido protocolo, host y puerto, en el cliente Web.

## 9. Evidencia segura

Registrar plataforma, versión de Flutter, dispositivo, build type, client ID truncado u omitido, código de error y pasos. Nunca registrar tokens, cookies, authorization codes, contraseñas, archivos de firma ni valores completos de secretos.
