import 'package:flutter/material.dart';

/// Los registros pertenecen a una moto: sin moto activa se pide crearla primero.
bool ensureActiveMoto(BuildContext context, Object? moto) {
  if (moto != null) return true;
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Primero agrega tu moto en la pestaña Inicio'),
  ));
  return false;
}
