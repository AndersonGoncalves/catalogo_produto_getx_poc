import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/services/produto/produto_service_impl.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository_impl.dart';

class ProdutoRepositoryFake extends Mock implements ProdutoRepositoryImpl {}

void main() {
  late ProdutoRepositoryImpl produtoRepository;

  setUp(() {
    produtoRepository = ProdutoRepositoryFake();
  });

  test('produtoRepository deve conter 2 produtos na lista', () async {
    ProdutoServiceImpl service = ProdutoServiceImpl(
      produtoRepository: produtoRepository,
    );
    when(() => produtoRepository.produtos).thenReturn([
      Produto(id: '1', dataCadastro: DateTime.now(), nome: 'Malbec'),
      Produto(id: '2', dataCadastro: DateTime.now(), nome: 'Arbo'),
    ]);
    expect(service.produtos.length, 2);
  });

  test('produtoRepository deve conter 1 produto na lista', () async {
    ProdutoServiceImpl service = ProdutoServiceImpl(
      produtoRepository: produtoRepository,
    );

    when(() => produtoRepository.get()).thenAnswer((_) async {
      return produtoRepository.add(
        Produto(id: '1', dataCadastro: DateTime.now(), nome: 'Malbec'),
      );
    });
    service.get();
    expect(service.produtos.length, 1);
  });
}
