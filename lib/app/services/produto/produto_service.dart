import 'package:catalogo_produto_poc/app/core/models/produto.dart';

abstract interface class ProdutoService {
  List<Produto> get produtos;
  void add(Produto produto);
  Future<void> get();
  Future<void> post(Produto model);
  Future<void> patch(Produto model);
  Future<void> delete(Produto model);
  Future<void> save(Map<String, dynamic> map);
}
