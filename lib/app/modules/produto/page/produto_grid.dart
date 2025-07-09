import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_pesquisa.dart';
import 'package:catalogo_produto_poc/app/modules/produto/cubit/produto_controller.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_grid_item.dart';

class ProdutoGrid extends StatefulWidget {
  final List<Produto> _produtos;
  final ProdutoController _controller;

  const ProdutoGrid({
    super.key,
    required List<Produto> produtos,
    required ProdutoController controller,
  }) : _produtos = produtos,
       _controller = controller;

  @override
  State<ProdutoGrid> createState() => _ProdutoGridState();
}

class _ProdutoGridState extends State<ProdutoGrid> {
  List<Produto> produtos = [];

  Future<void> _refresh(BuildContext context) {
    return widget._controller.load();
  }

  void _onSearch(String value) {
    List<Produto> search = [];
    if (value.isEmpty) {
      search = widget._produtos;
    } else {
      search = widget._produtos
          .where(
            (element) =>
                element.nome.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    }
    setState(() {
      produtos = search;
    });
  }

  @override
  void initState() {
    produtos = widget._produtos;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProdutoGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    produtos = widget._produtos;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: Column(
        children: <Widget>[
          widget._produtos.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 10,
                    right: 10,
                    bottom: 2,
                  ),
                  child: WidgetPesquisa(
                    fillColor: Colors.white,
                    onSearch: (value) => _onSearch(value),
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: widget._produtos.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GridView.builder(
                      itemCount: produtos.length,
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20,
                          ),
                      itemBuilder: (ctx, index) => ProdutoGridItem(
                        key: GlobalObjectKey(produtos[index]),
                        produto: produtos[index],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
