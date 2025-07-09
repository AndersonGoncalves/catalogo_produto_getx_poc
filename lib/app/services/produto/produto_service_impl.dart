import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/services/produto/produto_service.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository.dart';

class ProdutoServiceImpl implements ProdutoService {
  final ProdutoRepository _produtoRepository;

  ProdutoServiceImpl({required ProdutoRepository produtoRepository})
    : _produtoRepository = produtoRepository;

  @override
  List<Produto> get produtos => _produtoRepository.produtos;

  @override
  void add(Produto produto) => _produtoRepository.add(produto);

  @override
  Future<void> get() => _produtoRepository.get();

  @override
  Future<void> post(Produto model) => _produtoRepository.post(model);

  @override
  Future<void> patch(Produto model) => _produtoRepository.patch(model);

  @override
  Future<void> delete(Produto model) => _produtoRepository.delete(model);

  @override
  Future<void> save(Map<String, dynamic> map) => _produtoRepository.save(map);
}
