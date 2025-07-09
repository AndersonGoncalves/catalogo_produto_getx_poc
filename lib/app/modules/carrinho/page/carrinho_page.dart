import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catalogo_produto_poc/app/core/ui/theme_extensions.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/page/carrinho_item.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/cubit/carrinho_controller.dart';

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CarrinhoController carrinhoServiceImpl =
        Provider.of<CarrinhoController>(context);
    final items = carrinhoServiceImpl.items.values.toList();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Itens do Carrinho:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => CarrinhoItem(carrinho: items[i]),
            ),
          ),

          Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Chip(
                    backgroundColor: context.secondaryColor,
                    label: Text(
                      'R\$${carrinhoServiceImpl.valorTotal.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),

                  CartButton(cart: carrinhoServiceImpl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({super.key, required this.cart});

  final CarrinhoController cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.quantidadeItem == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    //TODO: Chamar a page do pedido
                    widget.cart.clear();
                    setState(() => _isLoading = false);
                  },
            child: Text(
              'COMPRAR',
              style: TextStyle(color: context.primaryColor),
            ),
          );
  }
}
