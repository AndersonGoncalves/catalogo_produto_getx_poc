String onlyNumber(String value) {
  return value.replaceAll(RegExp(r'[^0-9]'), '');
}

double precoVenda(double custo, double percentualLucro) {
  return (custo * (percentualLucro / 100)) + custo;
}

double percentualMarkup(double custo, double precoVenda) {
  if (custo == 0) {
    return 0;
  } else {
    return ((precoVenda - custo) / custo) * 100;
  }
}

double percentualLucroMarkup(double custo, double precoVenda) {
  if (precoVenda == 0) {
    return 0;
  } else {
    double resultado = ((precoVenda - custo) / precoVenda) * 100;
    return double.parse(resultado.toStringAsFixed(2));
  }
}

double lucro(double custo, double precoVenda) {
  return precoVenda - custo;
}
