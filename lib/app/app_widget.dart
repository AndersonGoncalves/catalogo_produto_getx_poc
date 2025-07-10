import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:catalogo_produto_poc/app/core/constants/rotas.dart';
import 'package:catalogo_produto_poc/app/core/ui/theme_config.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_error_page.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_about_page.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_perfil_page.dart';
import 'package:catalogo_produto_poc/app/modules/home/roteador_page.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/page/carrinho_page.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_form_page.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_page.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_detail_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GetMaterialApp(
      title: 'Catálogo de Produtos',
      theme: ThemeConfig.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: Rotas.home,
      // home: const RoteadorPage(),
      getPages: [
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
        GetPage(
          name: Rotas.produtoDetail,
          page: () => const ProdutoDetailPage(),
        ),
      ],
      onUnknownRoute: (RouteSettings settings) {
        return CupertinoPageRoute(
          builder: (_) {
            return const WidgetErrorPage();
          },
        );
      },
    );
  }
}
