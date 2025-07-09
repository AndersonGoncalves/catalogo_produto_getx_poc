import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Catálogo de Produtos',
      theme: ThemeConfig.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: Rotas.home,
      routes: {
        Rotas.home: (_) => const RoteadorPage(),
        Rotas.about: (_) => const WidgetAboutPage(),
        Rotas.perfil: (_) => const WidgetPerfilPage(),
        Rotas.carrinho: (_) => const CarrinhoPage(),
        Rotas.produtoList: (_) =>
            const ProdutoPage(produtoPageMode: ProdutoPageMode.list),
        Rotas.produtoGrid: (_) =>
            const ProdutoPage(produtoPageMode: ProdutoPageMode.grid),
        Rotas.produtoForm: (_) => const ProdutoFormPage(),
        Rotas.produtoDetail: (_) => const ProdutoDetailPage(),
      },
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
