import 'package:catalogo_produto_poc/app/core/models/carrinho.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/services/carrinho/carrinho_service.dart';
import 'package:catalogo_produto_poc/app/repositories/carrinho/carrinho_repository.dart';

class CarrinhoServiceImpl extends CarrinhoService {
  final CarrinhoRepository _carrinhoRepository;

  CarrinhoServiceImpl({required CarrinhoRepository carrinhoRepository})
    : _carrinhoRepository = carrinhoRepository;

  @override
  Map<String, Carrinho> get items => _carrinhoRepository.items;

  @override
  int get quantidadeItem => _carrinhoRepository.quantidadeItem;

  @override
  double get valorTotal => _carrinhoRepository.valorTotal;

  @override
  void add(Produto produto) => _carrinhoRepository.add(produto);

  @override
  void remove(String produtoId) => _carrinhoRepository.remove(produtoId);

  @override
  void removeSingleItem(String produtoId) =>
      _carrinhoRepository.removeSingleItem(produtoId);

  @override
  void clear() => _carrinhoRepository.clear();
}
