import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/ui/messages.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/constants/rotas.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_loading_page.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_list.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_grid.dart';
import 'package:catalogo_produto_poc/app/modules/produto/controller/produto_controller.dart';

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
  late final ProdutoController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProdutoController>();

    // Worker para escutar erros e exibir mensagens
    ever(controller.errorObs, (String error) {
      if (error.isNotEmpty && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Messages.showError(error);
            controller.clearError();
          }
        });
      }
    });
  }

  List<Produto> _produtos(List<Produto> produtos) {
    final produtosList = List<Produto>.from(produtos);
    produtosList.sort(
      (a, b) => a.nome.toUpperCase().compareTo(b.nome.toUpperCase()),
    );
    return produtosList;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                  onPressed: Get.back,
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
                      Get.toNamed(Rotas.produtoForm);
                    },
                  ),
                ],
              )
            : null,
        body: SafeArea(
          child: controller.isLoading
              ? WidgetLoadingPage(
                  label: 'Carregando...',
                  labelColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).canvasColor,
                )
              : widget._produtoPageMode == ProdutoPageMode.list
              ? ProdutoList(produtos: _produtos(controller.produtos))
              : ProdutoGrid(produtos: _produtos(controller.produtos)),
        ),
        floatingActionButton: widget._produtoPageMode == ProdutoPageMode.list
            ? FloatingActionButton(
                onPressed: () => Get.toNamed(Rotas.produtoForm),
                child: const Icon(Icons.add),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }

  @override
  void dispose() {
    // Os workers do GetX são automaticamente limpos quando o controller é removido
    super.dispose();
  }
}
