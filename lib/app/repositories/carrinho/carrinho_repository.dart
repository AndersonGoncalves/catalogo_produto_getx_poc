import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/models/carrinho.dart';

abstract class CarrinhoRepository {
  Map<String, Carrinho> get items;
  int get quantidadeItem;
  double get valorTotal;
  void add(Produto produto);
  void remove(String produtoId);
  void removeSingleItem(String produtoId);
  void clear();
}
