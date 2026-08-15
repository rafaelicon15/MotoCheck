# Configuración de Google Sign-In y Google Drive

## Estado actual

El proyecto fija `google_sign_in: ^6.2.1` y el lockfile resuelve `6.3.0`; la documentación actual de pub.dev muestra la rama `7.2.0`, que usa `GoogleSignIn.instance`, `initialize`, eventos de autenticación y `authenticate`/botón Web. No se actualizará automáticamente a 7.x durante la configuración de credenciales. Primero se validará la API 6.x actual; después se planificará una migración aislada con pruebas, especialmente para Web y autorización de Drive.

MotoCheck utiliza `google_sign_in` y `googleapis` para iniciar sesión y respaldar archivos en Google Drive `appDataFolder`. No utiliza Firebase Authentication. El flujo actual no puede considerarse listo para producción hasta crear y validar un proyecto de Google Cloud, los clientes OAuth por plataforma, el scope de Drive y los callbacks nativos.

## Proyecto Google Cloud

1. Crear o seleccionar un proyecto de Google Cloud dedicado a MotoCheck.
2. Configurar la pantalla de consentimiento OAuth con nombre de aplicación, correo de soporte, dominio autorizado, enlaces de privacidad y términos si aplican.
3. Habilitar Google Drive API.
4. Crear clientes OAuth separados para Android, iOS y Web.
5. Restringir cada cliente a su plataforma y registrar únicamente los orígenes, paquetes, bundle IDs y huellas necesarias.
6. Registrar en `docs/SECURITY_AND_CREDENTIALS.md` el identificador, ambiente, responsable y fecha de revisión sin guardar secretos.

## Android

### Identificadores

- Package / application ID actual: `com.motocheck.motocheck`.
- Client ID Android de desarrollo: pendiente.
- Client ID Android de producción: pendiente.
- Client ID Web usado como `serverClientId` cuando no se utiliza `google-services.json`: pendiente.

### Huellas

Obtener la huella del keystore debug con el comando equivalente disponible en el equipo:

```bash
keytool -list -v -alias androiddebugkey \
  -keystore "$HOME/.android/debug.keystore" \
  -storepass android -keypass android
```

Crear un keystore de release fuera del repositorio y conservarlo en un gestor seguro. Puedes ejecutar `scripts/print_oauth_fingerprints.sh` para obtener las huellas SHA-1 y SHA-256 públicas de debug y release. Registrar la huella SHA-1 y SHA-256 del certificado de upload/release y, una vez configurado Play App Signing, añadir también la huella del certificado de aplicación que proporciona Play Console.

### Código

El código usa `GOOGLE_WEB_CLIENT_ID` como `serverClientId` para Android y como servidor en iOS cuando aplica; iOS recibe además su propio `GOOGLE_IOS_CLIENT_ID` como `clientId`. No reutilizar el ID Web como `clientId` iOS. La versión efectiva de `google_sign_in` permanece en la línea 6.x y no se actualiza automáticamente a 7.x.

Ejemplo de build de desarrollo, sustituyendo el valor solo en la máquina o CI protegido:

```bash
# Android/iOS: ejecutar en una máquina protegida; no pegar el valor en Git.
flutter run \
  --dart-define=GOOGLE_WEB_CLIENT_ID=<WEB_CLIENT_ID> \
  --dart-define=GOOGLE_IOS_CLIENT_ID=<IOS_CLIENT_ID>

# Web local, fijando el puerto que debe estar autorizado en Google Cloud.
flutter run -d chrome --web-hostname localhost --web-port 7357 \
  --dart-define=GOOGLE_WEB_CLIENT_ID=<WEB_CLIENT_ID>
```

No pegar el valor real en documentación, issues o commits.

## iOS

### Identificadores

- Bundle ID actual visible: `com.motocheck.motocheck`.
- Client ID iOS: pendiente; se inyecta en Dart como `GOOGLE_IOS_CLIENT_ID` y en iOS como `GIDClientID`.
- Server client ID Web, si se requiere: pendiente.
- URL scheme reverso: se deriva del client ID iOS y queda pendiente.

La configuración debe incluir en `ios/Runner/Info.plist` los valores `GIDClientID` y, cuando aplique, `GIDServerClientID`, además de `CFBundleURLTypes` con el esquema reverso de Google. La versión 5.9.0 de `google_sign_in_ios` permite pasar client IDs desde Dart, pero el URL scheme de retorno sigue siendo obligatorio. Verificar que el esquema coincida exactamente con el client ID y que el Bundle ID de Xcode sea el registrado en Apple Developer y Google Cloud.

No versionar `GoogleService-Info.plist` aunque el proveedor lo ofrezca como descarga; para este proyecto se usa Google Sign-In directo y los archivos de proveedor deben mantenerse fuera de Git.

## Web

Crear un cliente OAuth de tipo Web y registrar como orígenes autorizados:

- Desarrollo: `http://localhost:<puerto-real>` y cualquier origen adicional que use Flutter durante las pruebas.
- Producción: `https://<dominio-final>` y, si existe, el subdominio Web.

El proyecto actual no incluye todavía el meta tag de Google Identity Services en `web/index.html`. Para la versión efectiva `google_sign_in_web 0.12.4+4`, el flujo Web debe usar el botón oficial `renderButton` para obtener un `idToken` confiable; un botón Flutter genérico con `signIn()` no es equivalente. Como el scope `drive.appdata` no es solo OpenID, Web también debe comprobar `canAccessScopes` y solicitar `requestScopes` desde una interacción del usuario. El token Web puede expirar aproximadamente después de una hora, por lo que Drive debe poder pedir autorización nuevamente. Para desarrollo se recomienda fijar un puerto, por ejemplo `flutter run -d chrome --web-hostname localhost --web-port 7357`, y registrar `http://localhost` y `http://localhost:7357` como orígenes autorizados.

## Drive y autorización

El login y el permiso de Drive son responsabilidades distintas. Después de identificar la cuenta, comprobar si `drive.appdata` está autorizado antes de ejecutar `files.list`, `files.create` o `files.update`. Si el token expira o el scope no está concedido, solicitar autorización desde una acción explícita del usuario y mostrar un error accionable. No interpretar una excepción de Drive como un fallo de credenciales de Google sin clasificarla.

## Matriz de pruebas

| Caso | Android debug | Android release | iOS | Web localhost | Web producción |
|---|---:|---:|---:|---:|---:|
| Selector de cuenta abre | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| Cancelación conserva el acceso local | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| Cuenta existente queda disponible en Configuración | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| Scope Drive autorizado | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| Backup crea archivo en appDataFolder | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| Restore reemplaza datos esperados | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| Token expirado solicita autorización | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| Error técnico queda registrado | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |

## Diagnóstico y evidencia

Para cada fallo registrar plataforma, versión Flutter/Dart, versión del paquete, dispositivo, build type, package/bundle/origen, código de excepción, mensaje completo y pasos. No ocultar el error técnico durante diagnóstico bajo un mensaje genérico como “No se pudo conectar con Google”. No incluir tokens, cookies, authorization codes ni datos personales en la evidencia.

## Fuentes

- [Paquete oficial `google_sign_in`](https://pub.dev/packages/google_sign_in)
- [Integración Android de `google_sign_in_android`](https://pub.dev/packages/google_sign_in_android)
- [Integración iOS de `google_sign_in_ios`](https://pub.dev/packages/google_sign_in_ios)
- [Integración Web de `google_sign_in_web`](https://pub.dev/packages/google_sign_in_web)
- [Google Identity Services](https://developers.google.com/identity/gsi/web/guides/overview)
- [Google Drive API](https://developers.google.com/drive/api/guides/about-sdk)
