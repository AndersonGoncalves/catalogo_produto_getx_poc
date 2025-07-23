import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catalogo_produto_poc/app/modules/usuario/controller/usuario_controller.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/controller/carrinho_controller.dart';
import 'package:catalogo_produto_poc/app/services/usuario/usuario_service_impl.dart';
import 'package:catalogo_produto_poc/app/services/carrinho/carrinho_service_impl.dart';
import 'package:catalogo_produto_poc/app/repositories/usuario/usuario_repository_impl.dart';
import 'package:catalogo_produto_poc/app/repositories/carrinho/carrinho_repository_impl.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository_impl.dart';
import 'package:catalogo_produto_poc/app/services/produto/produto_service_impl.dart';
import 'package:catalogo_produto_poc/app/modules/produto/controller/produto_controller.dart';

/// Binding principal da aplicação que configura as dependências globais
/// Usado para injetar serviços e controllers que precisam estar disponíveis em toda a aplicação
/// Fenix: Permite que o repositório seja recriado se for necessário
/// Permanent: Mantém a instância do controller durante toda a vida útil da aplicação
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsuarioRepositoryImpl>(
      () => UsuarioRepositoryImpl(firebaseAuth: FirebaseAuth.instance),
      fenix: true,
    );

    Get.lazyPut<UsuarioServiceImpl>(
      () => UsuarioServiceImpl(
        usuarioRepository: Get.find<UsuarioRepositoryImpl>(),
      ),
      fenix: true,
    );

    Get.put<UsuarioController>(
      UsuarioController(usuarioService: Get.find<UsuarioServiceImpl>()),
      permanent: true,
    );

    Get.lazyPut<CarrinhoRepositoryImpl>(
      () => CarrinhoRepositoryImpl(),
      fenix: true,
    );

    Get.lazyPut<CarrinhoServiceImpl>(
      () => CarrinhoServiceImpl(
        carrinhoRepository: Get.find<CarrinhoRepositoryImpl>(),
      ),
      fenix: true,
    );

    Get.put<CarrinhoController>(
      CarrinhoController(carrinhoService: Get.find<CarrinhoServiceImpl>()),
      permanent: true,
    );

    Get.lazyPut<ProdutoRepositoryImpl>(() {
      final usuarioService = Get.find<UsuarioServiceImpl>();
      return ProdutoRepositoryImpl(
        token: usuarioService.user?.refreshToken ?? '',
        produtos: [],
      );
    }, fenix: true);

    Get.lazyPut<ProdutoServiceImpl>(
      () => ProdutoServiceImpl(
        produtoRepository: Get.find<ProdutoRepositoryImpl>(),
      ),
      fenix: true,
    );

    Get.put<ProdutoController>(
      ProdutoController(produtoService: Get.find<ProdutoServiceImpl>()),
      permanent: true,
    );
  }
}
