import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catalogo_produto_poc/app/core/models/carrinho.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/cubit/carrinho_controller.dart';

class CarrinhoItem extends StatelessWidget {
  final Carrinho carrinho;

  const CarrinhoItem({super.key, required this.carrinho});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(carrinho.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Atenção'),
            content: const Text('Deseja remover o item do carrinho?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Sim'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        context.read<CarrinhoController>().remove(carrinho.produtoId!);
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.black12,
              child: Icon(
                Icons.local_offer_outlined,
                color: Colors.black45,
                size: 24,
              ),
            ),
            title: Text(carrinho.nome),
            subtitle: Text(
              'Total: R\$ ${carrinho.preco * carrinho.quantidade}',
            ),
            trailing: Text(
              ' ${carrinho.quantidade.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
