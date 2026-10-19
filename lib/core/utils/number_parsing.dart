/// Lectura de números escritos como los escribe un usuario en Latinoamérica:
/// coma o punto decimal y separadores de miles ("12,5", "1.250,50", "1,250.50").
double? parseDecimal(String input) {
  var text = input.trim().replaceAll(RegExp(r'[\s$]'), '');
  if (text.isEmpty) return null;

  final lastComma = text.lastIndexOf(',');
  final lastDot = text.lastIndexOf('.');
  if (lastComma >= 0 && lastDot >= 0) {
    // El separador que aparece al final es el decimal; el otro es de miles.
    final decimal = lastComma > lastDot ? ',' : '.';
    final thousands = decimal == ',' ? '.' : ',';
    text = text.replaceAll(thousands, '').replaceAll(decimal, '.');
  } else if (lastComma >= 0) {
    text = _isThousandsGrouping(text, ',')
        ? text.replaceAll(',', '')
        : text.replaceAll(',', '.');
  } else if (lastDot >= 0 && _isThousandsGrouping(text, '.')) {
    text = text.replaceAll('.', '');
  }
  return double.tryParse(text);
}

/// Kilometraje u otros enteros: acepta "26507", "26.507" y "26,507".
int? parseWholeNumber(String input) {
  final text = input.trim().replaceAll(RegExp(r'[\s.,]'), '');
  return text.isEmpty ? null : int.tryParse(text);
}

/// "1,250" o "1.250.000": grupos de exactamente 3 dígitos tras el separador.
/// Un solo grupo de 3 ("12,500") se toma como miles, el uso más común en montos.
bool _isThousandsGrouping(String text, String separator) {
  final parts = text.split(separator);
  if (parts.length < 2 ||
      parts.first.isEmpty ||
      parts.first.length > 3 ||
      parts.first == '0') {
    return false;
  }
  return parts.skip(1).every((p) => p.length == 3 && int.tryParse(p) != null);
}
