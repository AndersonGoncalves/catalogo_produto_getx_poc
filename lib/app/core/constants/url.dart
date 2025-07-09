class Url {
  static const String _firebaseUrl =
      'https://catalogo-produto-cdbaf-default-rtdb.firebaseio.com/';

  Url.firebase();

  String get produto => '$_firebaseUrl/produto';
}
