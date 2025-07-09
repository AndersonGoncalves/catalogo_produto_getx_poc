import 'package:flutter/material.dart';

class ProdutoDetailPage extends StatefulWidget {
  const ProdutoDetailPage({super.key});

  @override
  State<ProdutoDetailPage> createState() => _ProdutoDetailPageState();
}

class _ProdutoDetailPageState extends State<ProdutoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produto Detail')),
      body: Center(
        child: Text(
          'Detalhes do Produto',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
