import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/ui/theme_extensions.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/page/carrinho_item.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/controller/carrinho_controller.dart';

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CarrinhoController controller = Get.find<CarrinhoController>();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Obx(() {
              if (controller.items.isEmpty) {
                return SizedBox.shrink();
              } else {
                return Text(
                  'Carrinho de Compras',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              }
            }),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Seu carrinho está vazio',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (ctx, index) =>
                    CarrinhoItem(carrinho: controller.items[index]),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        if (controller.items.isEmpty) {
          return SizedBox.shrink();
        }

        return Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total', style: TextStyle(fontSize: 20)),
                Spacer(),
                Chip(
                  label: Text(
                    'R\$ ${controller.valorTotal.toStringAsFixed(2)}',
                    style: TextStyle(color: context.primaryColor),
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                ),
                TextButton(
                  onPressed: controller.isLoading
                      ? null
                      : () {
                          // Implementar lógica de compra
                          controller.clear();
                          Get.snackbar(
                            'Sucesso',
                            'Compra realizada com sucesso!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                  style: TextButton.styleFrom(
                    foregroundColor: context.primaryColor,
                  ),
                  child: Text('COMPRAR'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
