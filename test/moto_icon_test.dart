import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motocheck/core/widgets/moto_icon.dart';

void main() {
  Widget host({required bool disableAnimations}) {
    return MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: AnimatedMotoIcon(
          icon: MotoIconName.chevronDown,
          semanticLabel: 'Expandir opciones',
        ),
      ),
    );
  }

  testWidgets('expone una etiqueta semántica para el control de expansión', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(host(disableAnimations: false));

    expect(find.bySemanticsLabel('Expandir opciones'), findsOneWidget);
    expect(find.byType(AnimatedSwitcher), findsOneWidget);
  });

  testWidgets('desactiva la transición cuando el sistema reduce movimiento', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(host(disableAnimations: true));

    final switcher = tester.widget<AnimatedSwitcher>(
      find.byType(AnimatedSwitcher),
    );
    expect(switcher.duration, Duration.zero);
  });
}
