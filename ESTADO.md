# MotoCheck — Estado del Proyecto

> Última actualización: 2026-08-16

**Marca confirmada:** MotoCheck. Se mantienen los identificadores técnicos actuales: Android/iOS `com.motocheck.motocheck` y Google Cloud `motocheck-500004`.

---

## Descripción

App local-first de mantenimiento de motocicletas. Registra combustible, servicios, refacciones y alertas de vida útil sin requerir cuenta. El respaldo opcional en Google Drive se conecta desde Configuración.

---

## Stack técnico

| Capa | Tecnología |
|---|---|
| Framework | Flutter (Dart) |
| Estado | Riverpod 2.x (`StateNotifierProvider`, `AsyncValue`) |
| Base de datos | Drift + SQLite (`drift_flutter`) |
| Auth | Google Sign-In (`google_sign_in`) |
| Respaldo | Google Drive `appDataFolder` (sin Firebase) |
| Gráficas | `fl_chart` |
| Fechas/formatos | `intl` |
| Iconografía SVG | `flutter_svg` + activos locales Lucide, con Morphicons como referencia de transición |

---

## Schema DB — v11 (actual)

**Tablas:** `FuelRecords`, `MaintenanceRecords`, `PartRecords`, `MotoProfile`, `AppSettings`, `PartHistory`

### Historial de versiones
| Versión | Cambio |
|---|---|
| v1–v7 | Tablas base + campos de moto |
| v8 | Tabla `PartHistory` (historial de cambios de refacciones) |
| v9 | Columna `isFull` en `FuelRecords` (detección de rellenos parciales) |
| v10 | Columna `rimType` en `MotoProfile` (tipo de rin para filtrar tipos de llanta) |
| v11 | Columna `calendarEventId` en `MaintenanceRecords` para sincronizar servicios con calendario |

> **Nota dev:** Las migraciones v8–v11 son aditivas y preservan los datos locales. Al cambiar schema, ejecutar `dart run build_runner build --delete-conflicting-outputs`.

---

## Funcionalidades implementadas

### Respaldo / Google Drive
- [x] MotoCheck abre en modo local sin requerir cuenta Google
- [x] Conexión opcional a Google Drive desde Configuración
- [x] OAuth Web: cliente habilitado, preview reconstruido y flujo de Google verificado manualmente
- [ ] OAuth Android/iOS: faltan huellas de firma Android y configuración URL scheme/cliente iOS
- [x] Respaldo manual y automático cuando existe cuenta conectada
- [x] Restauración manual con confirmación explícita
- [x] Calendario: eventos nativos Android/iOS y descarga `.ics` en Web

### Iconografía y accesibilidad
- [x] Capa `MotoIcon`/`AnimatedMotoIcon` para SVG locales con etiquetas semánticas
- [x] Primera transición expandir/contraer en Mantenimiento, con respeto a movimiento reducido
- [x] Atribución ISC/MIT para activos Lucide incluidos
- [ ] Migrar por pares evaluados los iconos de navegación, edición, alta y estado Drive
- [ ] Adoptar morphing real solo si existe adaptador Flutter/Dart multiplataforma

### Dashboard
- [x] Tarjeta activa de moto (marca, modelo, año, km, badges)
- [x] Resumen rápido: último km/L y próximo servicio
- [x] Alertas de refacciones próximas a vencer
- [x] Selector de moto activa / agregar nueva / eliminar
- [x] Espaciado responsive: márgenes explícitos, alertas más legibles y resumen en columna en pantallas compactas

### Perfil de moto (formulario)
- [x] Marca, modelo, año, km actuales, placa
- [x] Cilindrada, capacidad del tanque
- [x] Tipo de motor: 4T / 2T
- [x] Sistema de combustible: carburada / inyección (solo 4T)
- [x] Tipo de transmisión: cadena / cardan / CVT
- [x] **Tipo de rin:** paleta / rayos estándar / rayos doble pestaña
- [x] Refrigeración: aire / líquido
- [x] Filtro de aceite: reemplazable / metálico permanente
- [x] Aceite: tipo + viscosidad (solo 4T)
- [x] Método de lubricación 2T: autolube / premezclado / sin aceite

### Combustible
- [x] Registro de cargas: fecha, litros, precio/L, odómetro, tipo de gasolina, octanaje
- [x] Gráfica de eficiencia (km/L en el tiempo)
- [x] Resumen: promedio km/L, autonomía, total registros
- [x] Comparativa de rendimiento por tipo de gasolina / octanaje
- [x] **Filtro dinámico** por tipo (Regular / Premium / +Octanaje)
- [x] Detección de rellenos parciales (`isFull` toggle)
- [x] Detección automática de anomalías (< 3 o > 60 km/L)
- [x] Badges visuales: gris (parcial), naranja ⚠️ (anomalía)
- [x] Registros anómalos/parciales excluidos de estadísticas

### Mantenimiento
- [x] Registro de servicios: tipo, descripción, costo, taller, próximo servicio
- [x] Categorías dinámicas según tipo de motor, combustible y transmisión
- [x] Ítems de mantenimiento seleccionables por servicio

### Refacciones
- [x] Lista de refacciones con intervalos de km y alertas
- [x] Categorías: aceite, filtro, cadena, piñón/corona, frenos, llantas, antipinchazo, refrigerante, general
- [x] Tipos de cadena: estándar, O-Ring, X-Ring, W-Ring (con intervalos de lubricación)
- [x] **Tipos de llanta filtrados por tipo de rin:**
  - Rayos estándar → solo cámara/tripa
  - Rayos doble pestaña → todos (tubeless, antipinchazo, cámara)
  - Paleta → todos
- [x] "Registrar cambio" actualiza km y graba en historial
- [x] **Historial de cambios** con fecha, km y costo (tabla `PartHistory`)
- [x] Cargar refacciones comunes según tipo de moto

### Configuración
- [x] Conectar/desconectar Google Drive
- [x] Respaldar ahora / Restaurar desde Drive
- [x] Selector de moneda (MXN, USD, COP, etc.)

---

## Estructura de archivos clave

```
lib/
├── app.dart                          # MainShell local-first + navegación
├── core/
│   ├── constants/app_constants.dart  # Todos los datos: tipos de motor, cadenas, rines, etc.
│   ├── theme/app_theme.dart          # Colores, cardDecoration(), ThemeData
│   └── widgets/moto_icon.dart        # SVG, semántica y transición de iconos
├── data/
│   └── database/app_database.dart    # Schema Drift v11, migraciones, exportToJson/importFromJson
├── features/
│   ├── dashboard/dashboard_screen.dart
│   ├── fuel/screens/fuel_screen.dart
│   ├── maintenance/screens/maintenance_screen.dart
│   ├── parts/screens/parts_screen.dart
│   └── settings/settings_screen.dart
└── services/
    ├── google_auth_service.dart      # AsyncValue<GoogleSignInAccount?>
    └── drive_backup_service.dart     # backup / restore / getLastBackupTime
```

---

## Build y despliegue

```bash
# Regenerar código Drift (cuando cambia el schema)
Remove-Item "lib\data\database\app_database.g.dart" -Force
dart run build_runner build

# Build APK debug (requiere Android SDK + JDK 17)
flutter build apk --debug

# Artefacto de prueba verificado el 2026-08-16
# MotoCheck-android-debug-9ccda56.apk · 160 MB · SHA-256 documentado en PROJECT_MASTER_LOG.md

# Instalar en un dispositivo conectado
adb install -r build/app/outputs/apk/debug/app-debug.apk
```

---

## Estado de auditoría — 2026-08-14

- [x] Proyecto local comparado con el repositorio remoto público.
- [x] Arquitectura, dependencias y plataformas inspeccionadas.
- [x] Requisitos OAuth documentados sin almacenar secretos.
- [x] Inventario seguro de credenciales creado.
- [x] Registro de ingeniería y riesgos creado.
- [x] Requisitos de publicación y estrategia de tamaño documentados.
- [x] Roadmap de lanzamiento hasta noviembre de 2026 creado.
- [x] Skill compuesta `motocheck-engineering` creada y validada.
- [x] Marca MotoCheck confirmada; no se renombrará en esta etapa.
- [ ] Revocar token de GitHub expuesto en material compartido.
- [x] Cliente OAuth Web validado; Android e iOS continúan pendientes de configuración nativa.
- [x] Toolchain Flutter 3.47/Dart 3.13, Android SDK, NDK, CMake y JDK 17 verificados en sandbox; macOS/Xcode siguen pendientes.
- [x] APK Android debug compilado, alineado y firmado para prueba física; falta validación en dispositivo.
- [x] `flutter analyze`, `flutter test` y build Web release ejecutados sobre el checkout actual.
- [x] Migraciones Drift v8–v11 son aditivas; faltan snapshots históricos v7/v8/v9.
- [ ] Configurar firma release, Play App Signing, Apple Developer y CI/CD.

## Bloqueadores actuales

- [ ] Revocar el token de GitHub expuesto en material compartido.
- [ ] Registrar y restringir huellas OAuth para Android; configurar cliente y URL scheme iOS.
- [ ] Validar build release Android firmado/AAB e iOS/TestFlight; iOS requiere macOS/Xcode.
- [ ] Crear keystore release y completar Play App Signing.
- [ ] Publicar política de privacidad y definir dominio/correo corporativo.

## Pendientes / Ideas futuras

- [ ] Configurar Google Cloud Console para Android, iOS y Web
- [ ] Validar conexión opcional de Google Drive y respaldo/restauración en todas las plataformas
- [ ] Build release firmado (AAB, IPA/TestFlight y Web)
- [ ] Notificaciones push para alertas de mantenimiento
- [ ] Widget de pantalla de inicio (km restantes refacción crítica)
- [ ] Soporte multi-idioma (ES / EN)
- [ ] Exportar historial a PDF o CSV
- [ ] Foto de la moto en el perfil
- [ ] Registro de seguros y documentos (tenencia, verificación)
- [ ] Implementar épicas posteriores solo según gates de `docs/FUNCTIONS_ROADMAP_2026-08-16.md`

---

## Notas de diseño

- Tema oscuro neutro (sin tinte azul/morado) inspirado en Fintrixity
- Fondo: `#0D0D12` | Surface: `#161619` | Card: `#1D1D26`
- Acento principal: naranja `#FF5722`
- Todos los cards tienen borde sutil `rgba(255,255,255, 0.10)`
- `AppTheme.cardDecoration()` para cards nuevos
- `AnimatedContainer` en selectores del formulario de moto
- `RepaintBoundary` en gráfica de combustible
