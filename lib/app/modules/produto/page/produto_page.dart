import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalogo_produto_poc/app/core/ui/messages.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/constants/rotas.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_loading_page.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_list.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_grid.dart';
import 'package:catalogo_produto_poc/app/modules/produto/cubit/produto_controller.dart';
import 'package:catalogo_produto_poc/app/modules/produto/cubit/produto_state.dart';

enum ProdutoPageMode { list, grid }

class ProdutoPage extends StatefulWidget {
  final bool _comAppBar;
  final ProdutoPageMode _produtoPageMode;
  const ProdutoPage({
    super.key,
    bool comAppBar = true,
    required ProdutoPageMode produtoPageMode,
  }) : _comAppBar = comAppBar,
       _produtoPageMode = produtoPageMode;

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProdutoController>().load();
  }

  List<Produto> _produtos(ProdutoState state) {
    final produtos = List<Produto>.from(state.produtos);
    produtos.sort(
      (a, b) => a.nome.toUpperCase().compareTo(b.nome.toUpperCase()),
    );
    return produtos;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProdutoController, ProdutoState>(
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          Messages.of(context).showError(state.error!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          appBar: widget._comAppBar
              ? AppBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  surfaceTintColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  toolbarHeight: 56,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  title: const Padding(
                    padding: EdgeInsets.only(bottom: 2),
                    child: Text(
                      'Produtos',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context).pushNamed(Rotas.produtoForm);
                      },
                    ),
                  ],
                )
              : null,
          body: SafeArea(
            child: state.isLoading
                ? WidgetLoadingPage(
                    label: 'Carregando...',
                    labelColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).canvasColor,
                  )
                : widget._produtoPageMode == ProdutoPageMode.list
                ? ProdutoList(
                    produtos: _produtos(state),
                    controller: context.read<ProdutoController>(),
                  )
                : ProdutoGrid(
                    produtos: _produtos(state),
                    controller: context.read<ProdutoController>(),
                  ),
          ),
          floatingActionButton: widget._produtoPageMode == ProdutoPageMode.list
              ? FloatingActionButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Rotas.produtoForm),
                  child: const Icon(Icons.add),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
