import 'package:flutter_test/flutter_test.dart';
import 'package:motocheck/core/utils/number_parsing.dart';

void main() {
  group('parseDecimal', () {
    test('acepta punto o coma decimal', () {
      expect(parseDecimal('12.5'), 12.5);
      expect(parseDecimal('12,5'), 12.5);
      expect(parseDecimal('0,750'), 0.75);
      expect(parseDecimal(' 23.99 '), 23.99);
    });

    test('acepta separadores de miles en ambos estilos', () {
      expect(parseDecimal('1,250'), 1250);
      expect(parseDecimal('1.250'), 1250);
      expect(parseDecimal('1.250,50'), 1250.5);
      expect(parseDecimal('1,250.50'), 1250.5);
      expect(parseDecimal('\$1,250'), 1250);
    });

    test('devuelve null si no hay número', () {
      expect(parseDecimal(''), isNull);
      expect(parseDecimal('abc'), isNull);
    });
  });

  group('parseWholeNumber', () {
    test('acepta kilometrajes con separadores', () {
      expect(parseWholeNumber('26507'), 26507);
      expect(parseWholeNumber('26.507'), 26507);
      expect(parseWholeNumber('26,507'), 26507);
      expect(parseWholeNumber(''), isNull);
    });
  });
}
