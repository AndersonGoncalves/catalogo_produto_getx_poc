import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catalogo_produto_poc/app/modules/home/home_page.dart';
import 'package:catalogo_produto_poc/app/modules/usuario/page/usuario_form_page.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_loading_page.dart';
import 'package:catalogo_produto_poc/app/services/usuario/usuario_service_impl.dart';

class RoteadorPage extends StatelessWidget {
  const RoteadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: context.read<UsuarioServiceImpl>().authState,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return WidgetLoadingPage(
            label: 'Carregando...',
            labelColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.white,
          );
        } else {
          return snapshot.hasData ? const HomePage() : const UsuarioFormPage();
        }
      },
    );
  }
}
