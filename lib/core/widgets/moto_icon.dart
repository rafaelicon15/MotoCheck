import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Nombres semánticos de los SVG aprobados para la capa visual de MotoCheck.
enum MotoIconName { chevronDown, chevronUp }

/// Renderiza un icono SVG versionado por MotoCheck.
///
/// Los activos de la primera iteración proceden de Lucide y se seleccionan por
/// nombre semántico, evitando rutas SVG dispersas en los widgets de producto.
class MotoIcon extends StatelessWidget {
  const MotoIcon(
    this.icon, {
    super.key,
    this.color,
    this.size = 24,
    this.semanticLabel,
  });

  final MotoIconName icon;
  final Color? color;
  final double size;
  final String? semanticLabel;

  static const _assetByIcon = <MotoIconName, String>{
    MotoIconName.chevronDown: 'assets/icons/lucide/chevron-down.svg',
    MotoIconName.chevronUp: 'assets/icons/lucide/chevron-up.svg',
  };

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(
      _assetByIcon[icon]!,
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
      excludeFromSemantics: true,
    );

    if (semanticLabel == null) {
      return ExcludeSemantics(child: svg);
    }

    return Semantics(image: true, label: semanticLabel, child: svg);
  }
}

/// Intercambia iconos de estado con una transición breve y accesible.
///
/// Es el fallback común Android/iOS/Web mientras Morphicons no disponga de un
/// adaptador Flutter/Dart que preserve la paridad de plataformas.
class AnimatedMotoIcon extends StatelessWidget {
  const AnimatedMotoIcon({
    required this.icon,
    super.key,
    this.color,
    this.size = 24,
    this.semanticLabel,
  });

  final MotoIconName icon;
  final Color? color;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return AnimatedSwitcher(
      duration: disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        if (disableAnimations) {
          return child;
        }
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.82, end: 1).animate(animation),
            child: child,
          ),
        );
      },
      child: MotoIcon(
        icon,
        key: ValueKey(icon),
        color: color,
        size: size,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
