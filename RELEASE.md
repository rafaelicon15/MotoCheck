# MotoCheck — Release Android

## 1. Crear la llave de firma (una sola vez)

La llave de release identifica a la app para siempre en Google Play. **Si se pierde, no se puede actualizar la app.** Guárdala junto con sus contraseñas en un gestor de contraseñas y en un respaldo fuera de la PC.

```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v `
  -keystore "$env:USERPROFILE\motocheck-upload.jks" `
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Crea `android/key.properties` (está en `.gitignore`, nunca se sube a GitHub):

```properties
storePassword=<tu contraseña del keystore>
keyPassword=<tu contraseña de la llave>
keyAlias=upload
storeFile=C:\\Users\\rafae\\motocheck-upload.jks
```

Sin `key.properties`, `flutter build --release` sigue funcionando pero firma con la llave debug (solo para pruebas).

## 2. Registrar la huella en Google Cloud (Google Sign-In)

```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v `
  -keystore "$env:USERPROFILE\motocheck-upload.jks" -alias upload
```

En Google Cloud Console → APIs y servicios → Credenciales, crea un cliente OAuth **Android** con paquete `com.motocheck.motocheck` y el SHA-1 anterior. Al publicar en Play, agrega también el SHA-1 de **Play App Signing** (Play Console → Configuración → Integridad de la app).

La pantalla de consentimiento OAuth necesita la URL del aviso de privacidad de la landing (`/privacidad`).

## 3. Compilar

Antes de cada entrega, sube `version` en `pubspec.yaml` (el número tras `+` debe crecer siempre).

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build appbundle --release          # Google Play (.aab)
flutter build apk --release --split-per-abi  # APK directo desde la landing
```

Salidas:
- `build/app/outputs/bundle/release/app-release.aab`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (el que sirve a casi todos los teléfonos actuales)

## 4. Google Play Console

1. Crear la app (cuenta de desarrollador: pago único de 25 USD).
2. Ficha de la tienda: usar la skill `aso` del proyecto para título, descripción corta/larga y capturas.
3. Aviso de privacidad: URL `/privacidad` de la landing.
4. Seguridad de los datos: la app no envía datos a servidores propios; el respaldo opcional usa Google Drive (`drive.appdata`) con el correo/nombre solo para mostrar la cuenta.
5. Prueba cerrada (cuentas personales nuevas: 12 testers durante 14 días) → producción.

## 5. Distribución por la landing mientras llega Play

Seguir `landing/docs/DISTRIBUTION_RUNBOOK.md`: actualizar versión, fecha, tamaño y SHA-256 en `Home.tsx`, y `VITE_APK_URL` con la URL del APK alojado.

> Un APK firmado con la llave debug **no se puede actualizar** con uno firmado con la llave de release: quien tenga la versión de prueba debe desinstalarla (y respaldar en Drive antes si quiere conservar sus datos).
