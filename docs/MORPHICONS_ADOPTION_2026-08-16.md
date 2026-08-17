# MotoCheck — Adopción de Morphicons

**Fecha:** 2026-08-16

**Estado:** Primera base SVG implementada; morphing real Flutter pendiente de adaptador multiplataforma.

**Propietario del requisito:** Rafael Licón.

**Objetivo:** usar Morphicons como referencia oficial para las transiciones de iconos de MotoCheck, con movimiento accesible, bajo peso y consistencia visual en Android, iOS y Web.

## Hecho técnico verificado

Morphicons no es un catálogo de iconos para Flutter. Es un motor MIT de morphing para iconos SVG de trazo, con drivers documentados para DOM, React, Vue, Svelte, React Native, Astro y canvas. No ofrece un driver Flutter/Dart oficial. Los iconos de demostración pertenecen a sus respectivos conjuntos, por lo que Morphicons no transfiere licencias de Lucide, Tabler o Heroicons.

> **Decisión:** no se instalará un paquete JavaScript dentro de Flutter Web como sustituto global de `Icons`. Eso rompería la paridad Android/iOS/Web y añadiría vistas HTML sobre el canvas de Flutter. Primero se crea un adaptador de iconos de MotoCheck; después se habilita morphing en interacciones limitadas y verificables.

## Arquitectura de adopción

| Capa | Android/iOS | Web | Regla |
|---|---|---|---|
| Iconografía base | SVG de trazo seleccionados y versionados en `assets/icons/` | Los mismos SVG | Una fuente visual única |
| Renderizado | `flutter_svg` mediante un widget `MotoIcon` | `flutter_svg` mediante el mismo widget | Sin duplicar nomenclatura ni color semántico |
| Transición estándar | `AnimatedSwitcher` con escala/fade y respeto de movimiento reducido | Igual | Fallback accesible y multiplataforma |
| Morphing Morphicons | Pendiente de adaptador Dart o Flutter CustomPainter | Posible adaptador SVG/DOM aislado si mantiene paridad | No adoptar una implementación Web-only como estándar |
| Accesibilidad | `Semantics` y etiquetas de controles | `Semantics` y etiqueta equivalente | Nunca sustituir texto de acción por un icono sin etiqueta |

## Alcance inicial aprobado

La primera migración se limita a iconos que cambian de estado y tienen significado estable: menú/cerrar, mostrar/ocultar contraseña, expandir/contraer, reproducir/pausar y conectar/desconectar Drive. Los iconos de navegación, mantenimiento, combustible y refacciones se migrarán después de seleccionar los SVG, validar su licencia y medir el peso del artefacto.

**Hito implementado:** el par expandir/contraer ya usa `chevron-down`/`chevron-up` de Lucide mediante `MotoIcon` y `AnimatedMotoIcon` dentro del selector de categorías de Mantenimiento. La transición tiene 180 ms de fade/scale y se desactiva cuando `MediaQuery.disableAnimations` está activo. Los activos pesan 474 bytes sin comprimir y su atribución ISC/MIT se conserva junto al código.

## Reglas de rendimiento y licencia

1. Cada SVG debe ser de trazo, tener `viewBox` documentado y conservar licencia/autor en el inventario de activos.
2. Los SVG no se descargarán en runtime: se empaquetarán como activos o se incluirán solo en el bundle necesario.
3. El movimiento respetará `MediaQuery.disableAnimations` y se podrá desactivar por accesibilidad.
4. El presupuesto inicial de iconos es inferior a 50 KB comprimidos para el primer lote.
5. Ningún icono se copiará desde la demostración de Morphicons sin confirmar la licencia del set de origen.

## Bloqueos y siguiente decisión

Lucide se eligió como set de origen inicial por su diseño de trazo, licencia documentada y compatibilidad conceptual con Morphicons. El siguiente lote requiere un inventario de pares de estado de alto valor —menú/cerrar, mostrar/ocultar, reproducir/pausar y Drive— antes de sustituir iconos de producción. El morphing por trayectoria permanece diferido hasta contar con un adaptador Dart/Flutter validado.

## Referencias

[1]: https://www.morphicons.com/ "Morphicons — documentación oficial"
[2]: https://www.morphicons.com/roadmap "Morphicons — roadmap y drivers disponibles"
[3]: https://github.com/guillermolg00/morphicons "Morphicons — repositorio oficial"
