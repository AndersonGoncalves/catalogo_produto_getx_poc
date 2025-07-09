import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_dialog.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_text_form_field.dart';

class ProdutoFotoPage extends StatefulWidget {
  final List<String> fotoList;
  final int quantidadeMaximaFotos;
  final String? fotoSelecionada;
  final Function() atualizarList;

  const ProdutoFotoPage({
    required this.fotoList,
    required this.quantidadeMaximaFotos,
    this.fotoSelecionada = '',
    required this.atualizarList,
    super.key,
  });

  @override
  State<ProdutoFotoPage> createState() => _ProdutoFotoPageState();
}

class _ProdutoFotoPageState extends State<ProdutoFotoPage> {
  final _fotoUrlController = TextEditingController();
  Image? _fotoGrande;

  @override
  void initState() {
    super.initState();
    _fotoUrlController.text = widget.fotoSelecionada!.toString();
    _fotoGrande = widget.fotoSelecionada!.toString() == ''
        ? null
        : Image.network(widget.fotoSelecionada!);
  }

  @override
  Widget build(BuildContext context) {
    bool urlValida(String url) {
      return (Uri.tryParse(url)?.hasAbsolutePath ?? false);
    }

    Widget fotoPequena(int index) {
      const double tamanhoMaximo = 70;
      double tamanho = tamanhoMaximo;
      if (widget.quantidadeMaximaFotos > 1) {
        tamanho =
            (MediaQuery.of(context).size.width -
                (18 * widget.quantidadeMaximaFotos)) /
            widget.quantidadeMaximaFotos;
        if (tamanho > tamanhoMaximo) {
          tamanho = tamanhoMaximo;
        }
      }

      return InkWell(
        onTap: () {
          setState(() {
            _fotoGrande = Image.network(widget.fotoList[index].toString());
            _fotoUrlController.text = widget.fotoList[index].toString();
          });
        },
        child: widget.fotoList.length > index
            ? Stack(
                children: [
                  Container(
                    height: tamanho,
                    width: tamanho,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Image.network(widget.fotoList[index].toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 1),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _fotoGrande = null;
                          if (index >= 0) {
                            widget.fotoList.removeAt(index);
                          }
                          _fotoUrlController.text = '';
                        });
                        widget.atualizarList();
                      },
                      child: Icon(
                        Icons.close,
                        size: 15,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      );
    }

    void submit() {
      if ((_fotoUrlController.text.isNotEmpty) &&
              (!urlValida(_fotoUrlController.text)) ||
          (_fotoUrlController.text.isEmpty)) {
        WidgetDialog(
          context,
          'Não',
          'Sim',
        ).ok(titulo: 'Atenção', frase: 'Url inválida');
        return;
      }
      if (!widget.fotoList.contains(_fotoUrlController.text)) {
        if (widget.fotoList.length == widget.quantidadeMaximaFotos) {
          WidgetDialog(context, 'Não', 'Sim').ok(
            titulo: 'Atenção',
            frase:
                'Quantidade máxima permitida ${widget.quantidadeMaximaFotos}.',
          );
          return;
        }
      }
      setState(() {
        int index = widget.fotoList.indexOf(_fotoUrlController.text);
        if (index < 0) {
          widget.fotoList.add(_fotoUrlController.text);
          index = widget.fotoList.indexOf(_fotoUrlController.text);
        }

        _fotoUrlController.text = '';
        _fotoGrande = Image.network(widget.fotoList[index].toString());
      });
      widget.atualizarList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 56,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.close, size: 20),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            widget.quantidadeMaximaFotos == 1 ? 'Foto' : 'Fotos',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 21,
                      right: 21,
                      top: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: WidgetTextFormField(
                                  labelText: 'Url da Foto',
                                  suffixIcon: const Icon(Icons.check),
                                  suffixIconOnPressed: () => submit(),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: _fotoUrlController,
                                  onFieldSubmitted: (_) => submit(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        widget.fotoList.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    fotoPequena(0),
                                    const SizedBox(width: 12),
                                    fotoPequena(1),
                                    const SizedBox(width: 12),
                                    fotoPequena(2),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        Container(
                          width: double.infinity,
                          height: 380,
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: _fotoGrande,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
