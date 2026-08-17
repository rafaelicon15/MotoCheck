# AUTH-005 — Evidencia de OAuth Android

**Fecha:** 2026-08-17

## Evidencia del dispositivo

La pantalla de Configuración muestra el error:

`PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10, null, null)`

El error aparece al pulsar `Conectar o recuperar Google` y no llega a completar el acceso a la cuenta.

## Evidencia estática

El módulo Android usa:

| Parámetro | Valor verificado |
|---|---|
| Namespace | `com.motocheck.motocheck` |
| Application ID | `com.motocheck.motocheck` |
| Variante probada | APK debug |
| Configuración `google-services.json` | No encontrada en el checkout; no se debe crear con secretos en Git |
| Client ID en Dart | Web y iOS se inyectan por `dart-define`; Android depende de configuración nativa del plugin |

## Evidencia de Google Cloud

La lista de Google Auth Platform del proyecto `motocheck-500004` muestra dos clientes OAuth: `MotoCheck Web` de tipo Aplicación web y `Cliente de Android 1` de tipo Android. La consola debe abrirse en modo edición únicamente cuando sea necesario confirmar o corregir el package ID y la huella de firma; durante esta captura no se modificó ningún registro.

## Interpretación

`ApiException: 10` es compatible con `DEVELOPER_ERROR`: el package ID, la huella SHA de la firma instalada o el cliente Android registrado no coinciden exactamente. Para el APK debug deben registrarse las huellas del certificado debug que firma ese APK. Para una build release futura se necesitará registrar la huella del keystore release y, al publicar en Play, la huella de Play App Signing. No se guardan aquí valores de huellas, tokens, secretos ni keystores.

El segundo screenshot corresponde al estado local sin moto registrada. Debe permanecer operativo sin Google; se verificará que el placeholder no sea un loading infinito y que el botón `+` permita agregar la primera moto.

## Actualización de configuración

Con autorización del propietario, se introdujo en el cliente OAuth Android existente la huella SHA-1 del certificado debug que firma el APK de prueba. El package ID permaneció `com.motocheck.motocheck`. El valor se encuentra pendiente de pulsar `Guardar` en la consola; todavía no se considera propagado ni validado en dispositivo.

La consola refleja la nueva huella en el campo del cliente Android, pero el botón `Guardar` no aparece en la lista de elementos interactivos visibles del navegador conectado y el desplazamiento automático no cambió de posición. El cambio aún requiere una acción manual o una ruta alternativa de la propia consola para completar el guardado; no se afirma que esté aplicado hasta observar confirmación de Google Cloud.

La automatización no pudo activar `Guardar`: el control no se expone en la lista de elementos interactivos y los clics por coordenadas son rechazados por el navegador al considerar obsoleto el snapshot. El campo conserva la huella correcta, pero la actualización no debe considerarse guardada hasta que aparezca una confirmación de la consola.

El foco del formulario se movió a los campos superiores durante la navegación por teclado; la huella sigue visible con el valor correcto. No hay confirmación de guardado todavía.

El campo SHA-1 continúa mostrando el certificado debug correcto y quedó seleccionado durante la navegación por teclado. La consola sigue en modo edición; aún no se observa confirmación de `Guardar`.

La navegación por teclado tampoco alcanza el botón `Guardar`. El cambio queda preparado en el formulario, pero requiere intervención manual del propietario para completarse. El diagnóstico de la excepción 10 se considera concluido como problema de huella, y se documentará como pendiente de guardado manual.

Nueva evidencia confirmada el 2026-08-17: `apksigner verify --print-certs` muestra en el APK descargable SHA-1 `40:77:C1:89:F3:8D:3A:E1:3F:03:B2:29:22:96:95:B6:9D:5C:50:CB`. Al recargar el cliente OAuth Android en Google Cloud, la consola volvió a mostrar la SHA-1 antigua `53:24:56:8C:C4:EB:90:77:DB:7B:9A:C0:17:92:3E:E4:B0:A9:E1:4D`, demostrando que el cambio anterior nunca se guardó. El package ID coincide: `com.motocheck.motocheck`.

La SHA-1 correcta quedó visible en el formulario tras recargar y volver a editar. El campo de huella está enfocado; el botón `Guardar` aparece en el contenido de la página, pero no en la lista de elementos interactivos automatizables.

El foco del navegador está recorriendo los controles posteriores al campo SHA-1. La corrección sigue sin confirmación de guardado; se continúa por teclado para activar el botón correcto.

Cierre de configuración: el 2026-08-17 Google Cloud mostró `Se guardó el cliente OAuth` después de aplicar la SHA-1 `40:77:C1:89:F3:8D:3A:E1:3F:03:B2:29:22:96:95:B6:9D:5C:50:CB`. La propagación queda sujeta al aviso de Google de 5 minutos a algunas horas.
