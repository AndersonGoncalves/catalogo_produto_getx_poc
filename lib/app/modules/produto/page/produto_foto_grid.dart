import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_foto_page.dart';

class ProdutoFotoGrid extends StatefulWidget {
  final String label;
  final int quantidadeMaximaFotos;
  final List<String> fotoList;

  const ProdutoFotoGrid({
    this.label = 'Fotos',
    this.quantidadeMaximaFotos = 3,
    required this.fotoList,
    super.key,
  });

  @override
  State<ProdutoFotoGrid> createState() => _ProdutoFotoGridState();
}

class _ProdutoFotoGridState extends State<ProdutoFotoGrid> {
  bool _expanded = false;

  void _addFoto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return ProdutoFotoPage(
          fotoList: widget.fotoList,
          quantidadeMaximaFotos: widget.quantidadeMaximaFotos,
          fotoSelecionada:
              (widget.fotoList.length == widget.quantidadeMaximaFotos) &&
                  (widget.fotoList.isNotEmpty)
              ? widget.fotoList[0].toString()
              : '',
          atualizarList: () {
            setState(() {
              if (widget.fotoList.isNotEmpty) {
                _expanded = true;
              }
            });
          },
        );
      },
    );
  }

  void _updateFoto(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return ProdutoFotoPage(
          fotoList: widget.fotoList,
          quantidadeMaximaFotos: widget.quantidadeMaximaFotos,
          fotoSelecionada: widget.fotoList.isNotEmpty
              ? widget.fotoList[index].toString()
              : '',
          atualizarList: () {
            setState(() {
              if (widget.fotoList.isNotEmpty) {
                _expanded = true;
              }
            });
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoFoto() {
      double tamanho = 100;
      if (widget.quantidadeMaximaFotos > 1) {
        tamanho =
            (MediaQuery.of(context).size.width -
                (16 * widget.quantidadeMaximaFotos)) /
            widget.quantidadeMaximaFotos;
      }
      return tamanho;
    }

    Widget foto(int index) {
      return widget.fotoList.length > index
          ? InkWell(
              onTap: () {
                _updateFoto(context, index);
              },
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: tamanhoFoto(),
                        width: tamanhoFoto(),
                        margin: const EdgeInsets.only(top: 10, left: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Colors.black12, width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Image.network(widget.fotoList[index].toString()),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : InkWell(
              onTap: () {
                _addFoto(context);
              },
              child: Column(
                children: <Widget>[
                  Container(
                    height: tamanhoFoto(),
                    width: tamanhoFoto(),
                    margin: const EdgeInsets.only(top: 10, left: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey[100],
                    ),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[300],
                      child: const FittedBox(
                        child: Icon(Icons.image, color: Colors.black38),
                      ),
                    ),
                  ),
                ],
              ),
            );
    }

    List<Widget> fotos() {
      return [
        foto(0),
        if (widget.quantidadeMaximaFotos > 1) foto(1),
        if (widget.quantidadeMaximaFotos > 1) foto(2),
      ].toList();
    }

    double itemsHeigth = tamanhoFoto() + 30;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      height: _expanded
          ? itemsHeigth +
                (Theme.of(context).platform == TargetPlatform.windows
                    ? 65 - 34
                    : 85 - 54)
          : Theme.of(context).platform == TargetPlatform.windows
          ? 65 - 30
          : 85 - 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          const Icon(Icons.image, color: Colors.black45),
                          Text(
                            '  ${widget.label}',
                            style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        child: Icon(
                          _expanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.black38,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              height: _expanded ? itemsHeigth : 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, bottom: 10),
                    child: Row(children: fotos()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
