import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalogo_produto_poc/app/core/ui/messages.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/ui/theme_extensions.dart';
import 'package:catalogo_produto_poc/app/core/constants/rotas.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/cubit/carrinho_controller.dart';

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
    final formatCurrency = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    final carrinho = context.read<CarrinhoController>();

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
              Messages.of(context).infoWithAction(
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
            Navigator.of(
              context,
            ).pushNamed(Rotas.produtoDetail, arguments: widget._produto);
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
