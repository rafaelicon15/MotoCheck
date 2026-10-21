import 'package:flutter/material.dart';

/// Botón de guardar con estado de carga: se desactiva y muestra un indicador
/// mientras la acción corre, para evitar registros duplicados por doble toque.
class AsyncElevatedButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const AsyncElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  State<AsyncElevatedButton> createState() => _AsyncElevatedButtonState();
}

class _AsyncElevatedButtonState extends State<AsyncElevatedButton> {
  bool _busy = false;

  Future<void> _run() async {
    setState(() => _busy = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: widget.onPressed == null || _busy ? null : _run,
      child: _busy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.4, semanticsLabel: 'Guardando'),
            )
          : widget.child,
    );
  }
}
