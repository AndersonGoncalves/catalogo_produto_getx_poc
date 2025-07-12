import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:catalogo_produto_poc/app/app_binding.dart';
import 'package:catalogo_produto_poc/app/core/constants/rotas.dart';
import 'package:catalogo_produto_poc/app/core/ui/theme_config.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_error_page.dart';
import 'package:catalogo_produto_poc/app/core/routes/app_routes.dart';

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
      initialBinding: AppBinding(),
      title: 'Catálogo de Produtos',
      theme: ThemeConfig.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: Rotas.home,
      getPages: AppPages.routes,
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
