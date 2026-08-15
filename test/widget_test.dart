import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motocheck/app.dart';

void main() {
  testWidgets('opens the local-first main shell without Google login',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: MainShell()),
      ),
    );

    await tester.pump();

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Servicio'), findsOneWidget);
    expect(find.text('Combustible'), findsOneWidget);
    expect(find.text('Refacciones'), findsOneWidget);
    expect(find.text('Config.'), findsOneWidget);
  });
}
