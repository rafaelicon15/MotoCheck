import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Marca de MotoCheck (velocímetro con palomita) sobre una tarjeta redondeada.
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 88});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'MotoCheck',
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.12),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(size * 0.26),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35), width: 1.5),
        ),
        child: Image.asset('assets/branding/logo_mark.png', fit: BoxFit.contain),
      ),
    );
  }
}
