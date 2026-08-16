import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

// Monedas soportadas: código → {nombre, símbolo}
const Map<String, Map<String, String>> kCurrencies = {
  'MXN': {'name': 'Peso mexicano', 'symbol': '\$', 'flag': '🇲🇽'},
  'USD': {'name': 'Dólar estadounidense', 'symbol': 'USD\$', 'flag': '🇺🇸'},
  'EUR': {'name': 'Euro', 'symbol': '€', 'flag': '🇪🇺'},
  'COP': {'name': 'Peso colombiano', 'symbol': 'COP\$', 'flag': '🇨🇴'},
  'VES': {'name': 'Bolívar venezolano', 'symbol': 'Bs', 'flag': '🇻🇪'},
  'ARS': {'name': 'Peso argentino', 'symbol': 'AR\$', 'flag': '🇦🇷'},
  'CLP': {'name': 'Peso chileno', 'symbol': 'CLP\$', 'flag': '🇨🇱'},
  'BRL': {'name': 'Real brasileño', 'symbol': 'R\$', 'flag': '🇧🇷'},
  'PEN': {'name': 'Sol peruano', 'symbol': 'S/', 'flag': '🇵🇪'},
  'GTQ': {'name': 'Quetzal guatemalteco', 'symbol': 'Q', 'flag': '🇬🇹'},
  'HNL': {'name': 'Lempira hondureño', 'symbol': 'L', 'flag': '🇭🇳'},
  'NIO': {'name': 'Córdoba nicaragüense', 'symbol': 'C\$', 'flag': '🇳🇮'},
  'CRC': {'name': 'Colón costarricense', 'symbol': '₡', 'flag': '🇨🇷'},
  'PAB': {'name': 'Balboa panameño', 'symbol': 'B/.', 'flag': '🇵🇦'},
  'DOP': {'name': 'Peso dominicano', 'symbol': 'RD\$', 'flag': '🇩🇴'},
  'BOB': {'name': 'Boliviano', 'symbol': 'Bs', 'flag': '🇧🇴'},
  'PYG': {'name': 'Guaraní paraguayo', 'symbol': '₲', 'flag': '🇵🇾'},
  'UYU': {'name': 'Peso uruguayo', 'symbol': 'UYU\$', 'flag': '🇺🇾'},
  'SVC': {'name': 'Colón salvadoreño', 'symbol': '₡', 'flag': '🇸🇻'},
};

const String kDefaultCurrency = 'USD';
const String kCurrencyKey = 'currency';

final currencyCodeProvider = StreamProvider<String>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchSetting(kCurrencyKey).map((v) => v ?? kDefaultCurrency);
});

// Helper para obtener el símbolo de la moneda activa
String currencySymbol(String code) => kCurrencies[code]?['symbol'] ?? '\$';

String formatAmount(double amount, String currencyCode) {
  final symbol = currencySymbol(currencyCode);
  return '$symbol ${amount.toStringAsFixed(2)}';
}
