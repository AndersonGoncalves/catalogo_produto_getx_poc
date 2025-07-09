import 'package:flutter_test/flutter_test.dart';
import 'package:catalogo_produto_poc/app/core/ui/functions.dart';

void main() {
  test(
    'onlyNumber deve extrair apenas números de uma string',
    () => expect(onlyNumber('R\$ 1.234,56'), '123456'),
  );

  test(
    'precoVenda deve calcular corretamente o preço de venda',
    () => expect(precoVenda(100, 20), 120),
  );

  test(
    'percentualMarkup deve calcular corretamente o markup',
    () => expect(percentualMarkup(100, 120), 20),
  );

  test(
    'percentualLucroMarkup deve calcular corretamente o percentual de lucro',
    () => expect(percentualLucroMarkup(100, 120), 16.67),
  );

  test(
    'lucro deve calcular corretamente o lucro',
    () => expect(lucro(100, 120), 20),
  );
}
