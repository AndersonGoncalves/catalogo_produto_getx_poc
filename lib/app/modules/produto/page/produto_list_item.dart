import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/constants/rotas.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_dialog.dart';
import 'package:catalogo_produto_poc/app/modules/produto/cubit/produto_controller.dart';

class ProdutoListItem extends StatefulWidget {
  final Produto _produto;
  final ProdutoController _controller;

  const ProdutoListItem({
    super.key,
    required Produto produto,
    required ProdutoController controller,
  }) : _produto = produto,
       _controller = controller;

  @override
  State<ProdutoListItem> createState() => _ProdutoListItemState();
}

class _ProdutoListItemState extends State<ProdutoListItem> {
  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return Dismissible(
      key: Key(widget._produto.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (_) async {
        bool? confirmed = await WidgetDialog(context, 'Não', 'Sim').confirm(
          titulo: 'Atenção',
          pergunta: 'Deseja excluir o produto?',
          onConfirm: () async {
            return await widget._controller.remove(widget._produto);
          },
        );
        return confirmed ?? false;
      },
      child: Card(
        color: Theme.of(context).canvasColor,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        child: ListTile(
          horizontalTitleGap: 6,
          contentPadding: EdgeInsets.only(right: 15, left: 7),
          onTap: () {
            Navigator.of(
              context,
            ).pushNamed(Rotas.produtoForm, arguments: widget._produto);
          },
          leading:
              widget._produto.fotos == null || widget._produto.fotos!.isEmpty
              ? CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.local_offer_outlined,
                    color: Colors.black45,
                    size: 24,
                  ),
                )
              : CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(widget._produto.fotos![0]),
                ),
          title: Text(
            widget._produto.nome,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget._produto.descricao!,
            maxLines: 2,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCurrency.format(widget._produto.precoDeVenda),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget._produto.quantidadeEmEstoque} Und',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
