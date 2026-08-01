# Auditoria tecnica de MotoCheck

Fecha: 2026-08-01

## Alcance revisado

- Estructura Flutter y dependencias.
- Flujo de autenticacion con Google.
- Respaldo/restauracion en Google Drive.
- Persistencia local con Drift/SQLite.
- Pantallas principales: dashboard, combustible, mantenimiento, refacciones y configuracion.
- Test basico de widget.
- Configuracion visible de Android/iOS.

## Correcciones aplicadas

- Se corrigio el test inicial de Flutter que todavia apuntaba al contador de ejemplo y a `MyApp`.
- Se corrigio el texto de login "sempre" por "siempre".
- Se inicializo localizacion `es` para `intl` y Material/Cupertino.
- Se agrego `flutter_localizations` como dependencia SDK.
- Se reemplazo `firstOrNull` en Google Drive por logica explicita para evitar depender de extensiones no importadas.
- Se tiparon objetos que estaban como `dynamic` en configuracion.
- Se agrego liberacion de `TextEditingController` en formularios y dialogos.
- Se corrigio el controlador de cilindrada para que no se cree dentro de `build()`.
- Se corrigio el calculo de km/L para usar los litros del llenado actual en ciclos full-to-full.
- El resumen de ultimo km/L del dashboard ahora observa cambios en vivo con `StreamBuilder`.
- El odometro de la moto activa se actualiza automaticamente al registrar combustible, mantenimiento o cambio de refaccion con mayor kilometraje.
- Al eliminar una moto se eliminan tambien sus registros asociados y se activa otra moto disponible.
- La restauracion desde Drive ahora reemplaza tambien la configuracion local.
- Cargar refacciones comunes ahora evita duplicados por nombre.
- El cambio de cadena ahora puede actualizar piñon, corona y gomas porta corona, alineado con el texto del dialogo.
- Se evito division por cero en el progreso de refacciones.
- Se normalizo el nombre visible de la app como `MotoCheck` en Android e iOS.
- Se agregaron categorias de mantenimiento para clutch/crochera, barras delanteras, rodamientos y sistema electrico/encendido.
- Se agregaron refacciones base para discos/separadores/estrella de clutch, barras, rodamientos, magneto/estator, CDI/ECU y regulador/rectificador.
- Registrar un mantenimiento ahora actualiza automaticamente las refacciones relacionadas cuando existen para esa moto.
- El alta, baja o cambio de registros intenta respaldar automaticamente en Google Drive si hay cuenta conectada.
- Nueva refaccion permite clasificar rodamientos y otras partes por ubicacion, y barras por tipo convencional/invertida.
- Se agregaron piezas y servicios de distribucion/tren de valvulas: arbol de levas, cadena de tiempo, tensor, guias/patines, balancines, pastillas/shims, valvulas, retenes y empaque de tapa de valvulas.
- Los servicios de distribucion/tren de valvulas actualizan automaticamente las refacciones asociadas cuando se registra mantenimiento.
- Se agregaron piezas de motor interno para 2T/4T: piston, anillos/segmentos, cilindro/camisa, biela, ciguenal, retenes de ciguenal, bomba de aceite y bomba de agua/refrigerante.
- El formulario de mantenimiento precarga el kilometraje actual para que los cambios de aceite y servicios actualicen las alertas de refacciones.
- Se agrego edicion de cargas de combustible, mantenimientos, refacciones, historial de cambios y motos existentes.
- Se agregaron assets web de Drift/SQLite para habilitar la base local en navegador.
- Google Sign-In web queda preparado para recibir el client ID con `--dart-define=GOOGLE_WEB_CLIENT_ID=...`.

## Riesgos pendientes

- No se pudo ejecutar `flutter analyze`, `flutter test` ni `flutter build` en este entorno porque no estan instalados `flutter` ni `dart`.
- `pubspec.lock` debe actualizarse con `flutter pub get` por la nueva dependencia SDK `flutter_localizations`.
- Google Sign-In en Android requiere configurar OAuth con package `com.motocheck.motocheck` y SHA-1/SHA-256 del keystore.
- Google Sign-In en iOS requerira agregar el URL scheme del client ID si se va a publicar para iPhone.
- El build release aun usa firma debug; antes de distribuir hay que configurar firma real.

## Comandos de validacion recomendados

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build apk --debug
```
