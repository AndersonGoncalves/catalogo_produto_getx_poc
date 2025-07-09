import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:catalogo_produto_poc/app/core/constants/rotas.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_dialog.dart';
import 'package:catalogo_produto_poc/app/modules/usuario/page/usuario_form_page.dart';
import 'package:catalogo_produto_poc/app/services/usuario/usuario_service_impl.dart';

class WidgetDrawer extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final Widget? userImage;

  const WidgetDrawer({
    this.userName,
    this.userEmail,
    this.userImage,
    super.key,
  });

  @override
  State<WidgetDrawer> createState() => _WidgetDrawerState();
}

class _WidgetDrawerState extends State<WidgetDrawer> {
  Widget _createItem(IconData icon, String label, Function() onTap) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 22, color: Colors.black54),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black54,
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _sair(BuildContext context) async {
    context.read<UsuarioServiceImpl>().logout().then((value) {
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed(Rotas.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).canvasColor,
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: widget.userImage,
            ),
            accountName: Text(
              'Olá, ${widget.userName == 'null' ? '' : widget.userName}',
              style: const TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              'Seja bem vindo(a)!',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          _createItem(Icons.home, 'Home', () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(Rotas.home);
          }),
          const Divider(),
          _createItem(Icons.local_offer, 'Produtos', () {
            Navigator.of(context).popAndPushNamed(Rotas.produtoList);
          }),
          const Divider(),
          _createItem(Icons.account_circle, 'Perfil', () {
            if (context.read<UsuarioServiceImpl>().user.isAnonymous) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                CupertinoPageRoute(
                  maintainState: true,
                  fullscreenDialog: false,
                  allowSnapshotting: true,
                  builder: (_) {
                    return const UsuarioFormPage(usuarioAnonimo: true);
                  },
                ),
              );
            } else {
              Navigator.of(context).popAndPushNamed(Rotas.perfil);
            }
          }),
          _createItem(Icons.error_outline, 'Sobre', () {
            Navigator.of(context).popAndPushNamed(Rotas.about);
          }),
          const Divider(),
          _createItem(Icons.exit_to_app, 'Sair', () {
            if (context.read<UsuarioServiceImpl>().user.isAnonymous) {
              WidgetDialog(context, 'Não', 'Sim').confirm(
                titulo: 'Atenção',
                pergunta:
                    'Deseja sair da Aplicaçao? Irá perder todos os seus dados.',
                onConfirm: () {
                  _sair(context);
                },
              );
            } else {
              _sair(context);
            }
          }),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
