# MotoCheck — Plan de pruebas para beta cerrada

## Objetivo

El objetivo de esta etapa es detectar defectos antes de entregar MotoCheck a riders externos. La prueba no consiste en “navegar la app y ver si abre”; cada caso debe confirmar un resultado, registrar la plataforma, conservar evidencia y crear un bug reproducible cuando falle.

MotoCheck se prueba como producto **local-first**. El acceso a la aplicación no depende de Google. Google Drive es una integración opcional de respaldo que se valida por separado, con cuentas de prueba y datos desechables.

## Criterio de entrada

Una ejecución de pruebas comienza desde la rama `feat/local-first-oauth-simplification` o desde una rama posterior que la incluya. Antes de la prueba manual deben ejecutarse `scripts/preflight.sh`, `flutter pub get`, `dart format --output=none --set-exit-if-changed lib test`, `flutter analyze` y `flutter test`. Un fallo automático es un bug o bloqueo, no una advertencia a ignorar.

## Entornos mínimos

| Entorno | Dispositivo o navegador objetivo | Responsable inicial | Estado |
|---|---|---|---|
| Android debug | Teléfono Android físico con Google Play Services | Propietario | Pendiente |
| Android release | AAB interno o internal testing de Google Play | Propietario | Pendiente |
| iOS | iPhone físico mediante Mac/Xcode | Propietario con Mac | Pendiente |
| Web escritorio | Chrome actualizado en Windows/macOS/Linux | Propietario | Pendiente |
| Web móvil | Chrome Android y Safari iOS | Propietario | Pendiente |

Los datos de prueba deben contener al menos dos motos, tres registros de combustible, tres mantenimientos y tres refacciones. Nunca deben usarse cuentas de Drive con información personal real durante pruebas destructivas de restore o migraciones.

## Pruebas automáticas

| ID | Prueba | Resultado esperado | Prioridad |
|---|---|---|---|
| AUTO-01 | Preflight | No hay secretos rastreados, faltantes de plantillas, `AuthGate` ni migraciones destructivas | Bloqueador |
| AUTO-02 | Formato Dart | `dart format` no propone cambios | Alta |
| AUTO-03 | Análisis estático | `flutter analyze` termina sin errores | Bloqueador |
| AUTO-04 | Pruebas unitarias/widget | `flutter test` termina sin fallos | Bloqueador |
| AUTO-05 | Build Web release | `flutter build web --release` termina correctamente | Alta |
| AUTO-06 | Build Android debug | `flutter build appbundle --debug` termina correctamente | Alta |
| AUTO-07 | Tamaño Android release | AAB release medido antes de beta; aumento material requiere explicación | Alta |

## Recorridos funcionales críticos

| ID | Recorrido | Pasos resumidos | Resultado esperado | Plataformas |
|---|---|---|---|---|
| CORE-01 | Arranque local | Instalar/abrir sin cuenta Google | Dashboard abre sin login obligatorio | Android, iOS, Web |
| CORE-02 | Alta de moto | Crear moto con datos mínimos válidos | Moto activa visible en dashboard | Android, iOS, Web |
| CORE-03 | Cambio de moto | Crear segunda moto y activarla | Registros y métricas se filtran por moto | Android, iOS, Web |
| CORE-04 | Combustible | Crear, editar y eliminar carga full-to-full | Km/L, costo y odómetro se actualizan correctamente | Android, iOS, Web |
| CORE-05 | Mantenimiento | Crear, editar y eliminar un servicio | Historial, alerta y kilometraje se actualizan | Android, iOS, Web |
| CORE-06 | Refacción | Crear, registrar cambio y revisar vida útil | Intervalo y alerta reflejan el último cambio | Android, iOS, Web |
| CORE-07 | Eliminación | Eliminar moto activa con registros asociados | Datos asociados se eliminan y otra moto se activa si existe | Android, iOS, Web |
| CORE-08 | Persistencia | Cerrar/reabrir app y reiniciar navegador | Datos locales permanecen correctos | Android, iOS, Web |
| CORE-09 | Sin conectividad | Crear/editar registros con red desconectada | Funciones locales siguen operando | Android, iOS, Web |

## Google Drive y OAuth

| ID | Caso | Resultado esperado | Plataformas |
|---|---|---|---|
| OAUTH-01 | Conectar Google desde Configuración | Selector de cuentas se abre y el usuario puede cancelar sin salir de la app | Android, iOS, Web |
| OAUTH-02 | Cuenta conectada | Estado de cuenta visible en Configuración | Android, iOS, Web |
| OAUTH-03 | Scope Drive | La autorización para `drive.appdata` se obtiene por interacción explícita | Android, iOS, Web |
| OAUTH-04 | Backup | Se crea/actualiza un único archivo en `appDataFolder` | Android, iOS, Web |
| OAUTH-05 | Restore | Confirmación previa; datos de prueba se reemplazan solo tras aceptar | Android, iOS, Web |
| OAUTH-06 | Error remoto | Red, token o permiso fallido generan mensaje claro y no bloquean datos locales | Android, iOS, Web |
| OAUTH-07 | Logout | Se desconecta Drive sin borrar datos locales | Android, iOS, Web |

## Migraciones y regresiones

La migración v10 es un riesgo de datos y no puede validarse solo creando una base nueva. Antes de beta, se deben generar copias de prueba de esquemas v7, v8 y v9, ejecutar la apertura con v10 y comprobar que las motos, registros, configuración y la nueva columna correspondiente sobreviven. Cada snapshot debe quedar excluido de Git si contiene datos personales.

## Accesibilidad y rendimiento

En cada plataforma se valida contraste de texto, objetivos táctiles, orientación, escala de fuente, navegación por teclado en Web y comportamiento con lector de pantalla. Se mide el tiempo de arranque, se revisa que no existan congelamientos al cambiar de pantalla y se registra el tamaño de los builds release. No se optimiza hasta que un valor medido muestre un problema.

## Registro de bugs

Un bug debe registrarse en GitHub Issues con título, entorno, versión, pasos exactos, resultado esperado, resultado real, evidencia y severidad. Los bloqueadores impiden la beta; los críticos impiden la publicación; los altos se corrigen antes de abrir la beta a usuarios externos; los medios y bajos se priorizan en el siguiente ciclo.

| Severidad | Definición | Ejemplo |
|---|---|---|
| Bloqueador | Impide probar o distribuir la aplicación | App no compila o no abre |
| Crítico | Pérdida/corrupción de datos o fallo de seguridad | Upgrade borra historial |
| Alto | Rompe un flujo principal sin alternativa | No se puede guardar mantenimiento |
| Medio | Hay alternativa, pero degrada un flujo importante | Cálculo incorrecto en caso específico |
| Bajo | Problema visual o de texto sin impacto funcional | Etiqueta truncada |

## Criterio de salida a beta cerrada

La beta cerrada solo inicia cuando no existan bugs bloqueadores o críticos, las pruebas automáticas estén verdes, CORE-01 a CORE-09 estén aprobadas por plataforma disponible, OAuth/Drive esté aprobado en Android y Web, la migración tenga evidencia y se conozcan los límites pendientes de iOS. El primer grupo de beta debe usar datos de prueba y un canal explícito para reportar fallos.
