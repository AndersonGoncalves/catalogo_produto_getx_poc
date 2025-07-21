import 'dart:math';
import 'package:catalogo_produto_poc/app/core/models/carrinho.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/repositories/carrinho/carrinho_repository.dart';

class CarrinhoRepositoryImpl implements CarrinhoRepository {
  Map<String, Carrinho> _items = {};

  @override
  Map<String, Carrinho> get items {
    return {..._items};
  }

  @override
  int get quantidadeItem {
    return _items.length;
  }

  @override
  double get valorTotal {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.preco * cartItem.quantidade;
    });
    return total;
  }

  @override
  void add(Produto produto) {
    if (_items.containsKey(produto.id)) {
      _items.update(
        produto.id,
        (existingItem) => Carrinho(
          id: existingItem.id,
          produtoId: existingItem.produtoId,
          nome: existingItem.nome,
          quantidade: existingItem.quantidade + 1,
          preco: existingItem.preco,
        ),
      );
    } else {
      _items.putIfAbsent(
        produto.id,
        () => Carrinho(
          id: Random().nextDouble().toString(),
          produtoId: produto.id,
          nome: produto.nome,
          quantidade: 1,
          preco: produto.precoDeVenda,
        ),
      );
    }
  }

  @override
  void remove(String produtoId) {
    _items.remove(produtoId);
  }

  @override
  void removeSingleItem(String produtoId) {
    if (!_items.containsKey(produtoId)) {
      return;
    }

    if (_items[produtoId]?.quantidade == 1) {
      _items.remove(produtoId);
    } else {
      _items.update(
        produtoId,
        (existingItem) => Carrinho(
          id: existingItem.id,
          produtoId: existingItem.produtoId,
          nome: existingItem.nome,
          quantidade: existingItem.quantidade - 1,
          preco: existingItem.preco,
        ),
      );
    }
  }

  @override
  void clear() {
    _items = {};
  }
}
