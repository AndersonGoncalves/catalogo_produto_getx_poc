import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/ui/messages.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/ui/theme_extensions.dart';
import 'package:catalogo_produto_poc/app/core/constants/rotas.dart';
import 'package:catalogo_produto_poc/app/core/ui/format_currency.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/controller/carrinho_controller.dart';

class ProdutoGridItem extends StatefulWidget {
  final Produto _produto;

  const ProdutoGridItem({super.key, required Produto produto})
    : _produto = produto;

  @override
  State<ProdutoGridItem> createState() => _ProdutoGridItemState();
}

class _ProdutoGridItemState extends State<ProdutoGridItem> {
  @override
  Widget build(BuildContext context) {
    final formatCurrency = FormatCurrency();
    final carrinho = Get.find<CarrinhoController>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.white,
          title: Text(
            widget._produto.nome,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          subtitle: Text(
            formatCurrency.format(widget._produto.precoDeVenda),
            style: TextStyle(
              color: context.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: InkWell(
            child: Icon(Icons.shopping_cart, color: context.secondaryColor),
            onTap: () {
              Messages.infoWithAction(
                'Produto adicionado no carrinho!',
                'DESFAZER',
                () {
                  carrinho.removeSingleItem(widget._produto.id);
                },
              );
              carrinho.add(widget._produto);
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Get.toNamed(Rotas.produtoDetail, arguments: widget._produto);
          },
          child: Hero(
            tag: widget._produto.id,
            child: FadeInImage(
              placeholder: const AssetImage(
                'assets/images/produto-placeholder.png',
              ),
              image:
                  widget._produto.fotos == null ||
                      widget._produto.fotos!.isEmpty
                  ? AssetImage('assets/icon/icon-adaptive.png')
                  : NetworkImage(widget._produto.fotos![0]),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
