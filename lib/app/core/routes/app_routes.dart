import 'package:get/get.dart';
import 'package:catalogo_produto_poc/app/core/constants/rotas.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_about_page.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_perfil_page.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/page/carrinho_page.dart';
import 'package:catalogo_produto_poc/app/modules/home/roteador_page.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_detail_page.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_form_page.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_page.dart';

class AppPages {
  static final routes = [
    GetPage(name: Rotas.home, page: () => const RoteadorPage()),
    GetPage(name: Rotas.about, page: () => const WidgetAboutPage()),
    GetPage(name: Rotas.perfil, page: () => const WidgetPerfilPage()),
    GetPage(name: Rotas.carrinho, page: () => const CarrinhoPage()),
    GetPage(
      name: Rotas.produtoList,
      page: () => const ProdutoPage(produtoPageMode: ProdutoPageMode.list),
    ),
    GetPage(
      name: Rotas.produtoGrid,
      page: () => const ProdutoPage(produtoPageMode: ProdutoPageMode.grid),
    ),
    GetPage(name: Rotas.produtoForm, page: () => const ProdutoFormPage()),
    GetPage(name: Rotas.produtoDetail, page: () => const ProdutoDetailPage()),
  ];
}
