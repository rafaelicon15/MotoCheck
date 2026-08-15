# MotoCheck — Algoritmo de ingeniería en cinco pasos

## Propósito

Este documento convierte el enfoque solicitado por el propietario en una regla de trabajo para MotoCheck. Su objetivo es evitar que el equipo acumule funciones, optimizaciones o automatizaciones sobre flujos que todavía no son necesarios, claros o confiables.

## Regla transversal: todo requisito tiene dueño

Todo requisito funcional, técnico, de tienda o de seguridad debe registrar un **solicitante o responsable**, una razón verificable, el problema que resuelve, la evidencia esperada y una fecha de revisión. No se aceptarán frases como “siempre se ha hecho así”, “todas las apps lo tienen” o “sería bueno agregarlo” como justificación suficiente.

Un requisito sin dueño se considera hipótesis y no bloquea el lanzamiento. El propietario del producto decide sobre alcance de negocio; el responsable técnico valida viabilidad, riesgo y costo; y quien pruebe la historia confirma la evidencia de salida.

## Paso 1 — Cuestionar

Antes de implementar, cada requisito debe responder: quién lo pidió, qué problema concreto elimina, para qué usuario, qué evidencia demostraría éxito y qué pasa si no se implementa antes del lanzamiento. Si la respuesta no es clara, el requisito vuelve al backlog de hipótesis.

## Paso 2 — Eliminar

Se elimina toda pantalla, dependencia, automatización, regla, configuración o requisito que no contribuya de forma demostrable al lanzamiento seguro de la versión inicial. La meta no es conservar cada idea; es mantener un núcleo que funcione. Si en ciclos posteriores nunca se necesita reincorporar alrededor del 10% de lo eliminado, la eliminación ha sido demasiado conservadora.

## Paso 3 — Simplificar

Solo después de eliminar se simplifica el diseño restante. MotoCheck debe preferir un único flujo claro de autenticación, un único contrato de respaldo y una sola fuente de verdad por dato. No se optimiza un flujo duplicado ni se añaden abstracciones por anticipación.

## Paso 4 — Acelerar

Cuando el flujo simplificado pasa los criterios de salida, se reduce el tiempo de ciclo mediante comandos reproducibles, pruebas focalizadas y reportes. La velocidad no se mide por cantidad de archivos modificados, sino por tiempo entre cambio, validación y retroalimentación confiable.

## Paso 5 — Automatizar

La automatización se añade únicamente a pasos estables y repetitivos. La primera automatización prioritaria será la validación de formato, dependencias, análisis, tests y builds de Android/Web; iOS se integrará en un runner macOS cuando exista acceso a Xcode. No se automatizan credenciales, decisiones de tienda ni cambios destructivos sin revisión humana.

## Puertas de decisión

| Puerta | Pregunta obligatoria | Evidencia mínima | Resultado |
|---|---|---|---|
| Requisito | ¿Tiene dueño y dolor concreto? | Registro de requisitos | Continuar o devolver a hipótesis |
| Eliminación | ¿Se puede retirar sin afectar la versión inicial? | Impacto en flujo y datos | Retirar, diferir o conservar |
| Simplificación | ¿Existe una sola ruta comprensible? | Diagrama o prueba de recorrido | Reducir capas/estados duplicados |
| Aceleración | ¿El flujo estable tiene un ciclo lento? | Tiempo de ejecución y causas | Mejorar comando, caché o suite focalizada |
| Automatización | ¿El paso es estable y repetitivo? | Comando manual reproducible | Añadir script/CI con rollback |

## Límites de lanzamiento v1

La v1 no incorporará marketplace, pagos, clima de rutas, mapas, comunidad, tracking en segundo plano ni automatizaciones de marketing. Esas líneas requieren validación propia y no pueden competir con autenticación, datos locales, backup/restore, pruebas, builds y publicación.

## Entregables por ciclo

Cada ciclo de ingeniería debe cerrar con requisitos afectados, archivos modificados, pruebas ejecutadas, limitaciones, riesgos, rollback y referencia de commit. La fuente de verdad es `docs/ENGINEERING_LOG.md`; el estado resumido se mantiene en `ESTADO.md`.
