import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Ícono de rin dibujado a medida: los emojis no distinguen un rin de rayos
/// estándar de uno de doble pestaña, que es justo lo que importa para saber
/// qué llantas acepta.
///
/// - `alloy`: paleta / aleación, cinco brazos gruesos.
/// - `spoke`: rayos cruzados y el aro perforado por los niples (solo cámara).
/// - `spoke_double_wall`: rayos y un aro de banda doble, sólida y sin agujeros,
///   la pared interior que sella los niples (acepta tubeless).
class RimIcon extends StatelessWidget {
  final String rimType;
  final Color color;
  final double size;

  const RimIcon({super.key, required this.rimType, required this.color, this.size = 34});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _RimPainter(rimType, color)),
    );
  }
}

class _RimPainter extends CustomPainter {
  final String rimType;
  final Color color;
  _RimPainter(this.rimType, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    Paint stroke(double width, [Color? col]) => Paint()
      ..color = col ?? color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    // Llanta y aro.
    canvas.drawCircle(c, r * 0.90, stroke(r * 0.16));
    final rimR = r * 0.70;
    canvas.drawCircle(c, rimR, stroke(r * 0.06));

    final hubR = r * 0.16;
    if (rimType == 'alloy') {
      // Cinco brazos gruesos que se ensanchan hacia el aro.
      final fill = Paint()..color = color;
      for (var i = 0; i < 5; i++) {
        final a = -math.pi / 2 + i * 2 * math.pi / 5;
        Offset at(double radius, double da) =>
            c + Offset(math.cos(a + da), math.sin(a + da)) * radius;
        final path = Path()
          ..moveTo(at(hubR, -0.32).dx, at(hubR, -0.32).dy)
          ..lineTo(at(rimR * 0.94, -0.13).dx, at(rimR * 0.94, -0.13).dy)
          ..lineTo(at(rimR * 0.94, 0.13).dx, at(rimR * 0.94, 0.13).dy)
          ..lineTo(at(hubR, 0.32).dx, at(hubR, 0.32).dy)
          ..close();
        canvas.drawPath(path, fill);
      }
      canvas.drawCircle(c, hubR, Paint()..color = color);
      return;
    }

    // Rayos: pocos y cruzados, para que se lean a tamaño de ícono.
    final spokes = stroke(r * 0.045);
    const count = 8;
    final spokeEnd = rimType == 'spoke_double_wall' ? rimR * 0.66 : rimR * 0.92;
    for (var i = 0; i < count; i++) {
      final a = i * 2 * math.pi / count;
      final from = c + Offset(math.cos(a), math.sin(a)) * hubR;
      final b = a + (i.isEven ? 0.5 : -0.5);
      final to = c + Offset(math.cos(b), math.sin(b)) * spokeEnd;
      canvas.drawLine(from, to, spokes);
    }
    canvas.drawCircle(c, hubR, stroke(r * 0.08));

    if (rimType == 'spoke_double_wall') {
      // Doble pestaña: banda doble y sólida, sin agujeros (sella tubeless).
      canvas.drawCircle(
        c,
        rimR * 0.85,
        Paint()
          ..color = color.withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = rimR * 0.30,
      );
      canvas.drawCircle(c, rimR * 0.70, stroke(r * 0.07));
    } else {
      // Rayos estándar: los niples perforan el aro (por eso solo usa cámara).
      canvas.saveLayer(Offset.zero & size, Paint());
      canvas.drawCircle(c, rimR, stroke(r * 0.15));
      final hole = Paint()..blendMode = BlendMode.clear;
      for (var i = 0; i < count; i++) {
        final b = i * 2 * math.pi / count + (i.isEven ? 0.5 : -0.5);
        canvas.drawCircle(c + Offset(math.cos(b), math.sin(b)) * rimR, r * 0.05, hole);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_RimPainter old) => old.rimType != rimType || old.color != color;
}
