import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catalogo_produto_poc/app/modules/usuario/cubit/usuario_controller.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/cubit/carrinho_controller.dart';
import 'package:catalogo_produto_poc/app/services/usuario/usuario_service_impl.dart';
import 'package:catalogo_produto_poc/app/services/carrinho/carrinho_service_impl.dart';
import 'package:catalogo_produto_poc/app/repositories/usuario/usuario_repository_impl.dart';
import 'package:catalogo_produto_poc/app/repositories/carrinho/carrinho_repository_impl.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository_impl.dart';
import 'package:catalogo_produto_poc/app/services/produto/produto_service_impl.dart';
import 'package:catalogo_produto_poc/app/modules/produto/controller/produto_controller.dart';

/// Binding principal da aplicação que configura as dependências globais
/// Usado para injetar serviços e controllers que precisam estar disponíveis
/// em toda a aplicação
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Usuário - Camada de dados
    // Fenix: Permite que o repositório seja recriado se for necessário
    Get.lazyPut<UsuarioRepositoryImpl>(
      () => UsuarioRepositoryImpl(firebaseAuth: FirebaseAuth.instance),
      fenix: true,
    );

    // Usuario - Camada de serviços
    // Fenix: Permite que o serviço seja recriado se for necessário
    Get.lazyPut<UsuarioServiceImpl>(
      () => UsuarioServiceImpl(
        usuarioRepository: Get.find<UsuarioRepositoryImpl>(),
      ),
      fenix: true,
    );

    // Usuario - Camada de controller
    // Permanent: Mantém a instância do controller durante toda a vida útil da aplicação
    Get.put<UsuarioController>(
      UsuarioController(usuarioService: Get.find<UsuarioServiceImpl>()),
      permanent: true,
    );

    // Carrinho - Camada de dados
    // Fenix: Permite que o repositório seja recriado se for necessário
    Get.lazyPut<CarrinhoRepositoryImpl>(
      () => CarrinhoRepositoryImpl(),
      fenix: true,
    );

    // Carrinho - Camada de serviços
    // Fenix: Permite que o serviço seja recriado se for necessário
    Get.lazyPut<CarrinhoServiceImpl>(
      () => CarrinhoServiceImpl(
        carrinhoRepository: Get.find<CarrinhoRepositoryImpl>(),
      ),
      fenix: true,
    );

    // Carrinho - Camada de controller
    // Permanent: Mantém a instância do controller durante toda a vida útil da aplicação
    Get.put<CarrinhoController>(
      CarrinhoController(carrinhoService: Get.find<CarrinhoServiceImpl>()),
      permanent: true,
    );

    // Produto - Camada de dados
    // Fenix: Permite que o repositório seja recriado se for necessário
    Get.lazyPut<ProdutoRepositoryImpl>(() {
      final usuarioService = Get.find<UsuarioServiceImpl>();
      return ProdutoRepositoryImpl(
        token: usuarioService.user.refreshToken.toString(),
        produtos: [],
      );
    }, fenix: true);

    // Produto - Camada de serviços
    // Fenix: Permite que o serviço seja recriado se for necessário
    Get.lazyPut<ProdutoServiceImpl>(
      () => ProdutoServiceImpl(
        produtoRepository: Get.find<ProdutoRepositoryImpl>(),
      ),
      fenix: true,
    );

    // Produto - Camada de controller
    // Permanent: Mantém a instância do controller durante toda a vida útil da aplicação
    Get.put<ProdutoController>(
      ProdutoController(produtoService: Get.find<ProdutoServiceImpl>()),
      permanent: true,
    );
  }
}
