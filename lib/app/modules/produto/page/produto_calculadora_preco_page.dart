import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/ui/functions.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_text_form_field.dart';

class ProdutoCalculadoraPrecoPage extends StatefulWidget {
  final double precoCusto;
  final double precoVenda;
  final Function(String, String) atualizar;

  const ProdutoCalculadoraPrecoPage({
    required this.precoCusto,
    required this.precoVenda,
    required this.atualizar,
    super.key,
  });

  @override
  State<ProdutoCalculadoraPrecoPage> createState() =>
      ProdutotCalculadoraPrecoPageState();
}

class ProdutotCalculadoraPrecoPageState
    extends State<ProdutoCalculadoraPrecoPage> {
  final _precoCustoController = TextEditingController();
  final _markupController = TextEditingController();

  double precoVendaTemp = 0;
  var _precoCustoText = '';
  var _markupText = '';

  void _changePrecoCusto() {
    setState(() {
      _precoCustoText =
          (double.tryParse(onlyNumber(_precoCustoController.text))! / 100)
              .toStringAsFixed(2);
    });
    precoVendaTemp = precoVenda(
      double.tryParse(_precoCustoText)!,
      double.tryParse(_markupText)!,
    );
  }

  void _changeMarkup() {
    setState(() {
      _markupText = (double.tryParse(onlyNumber(_markupController.text))! / 100)
          .toStringAsFixed(2);
    });
    precoVendaTemp = precoVenda(
      double.tryParse(_precoCustoText)!,
      double.tryParse(_markupText)!,
    );
  }

  void _confirm() {
    widget.atualizar(
      _precoCustoText,
      precoVenda(
        double.tryParse(_precoCustoText)!,
        double.tryParse(_markupText)!,
      ).toStringAsFixed(2),
    );
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    _precoCustoController.text = widget.precoCusto.toStringAsFixed(2);
    _markupController.text = percentualMarkup(
      widget.precoCusto,
      widget.precoVenda,
    ).toStringAsFixed(2);

    _precoCustoController.addListener(_changePrecoCusto);
    _markupController.addListener(_changeMarkup);

    _precoCustoText =
        (double.tryParse(onlyNumber(_precoCustoController.text))! / 100)
            .toStringAsFixed(2);
    _markupText = (double.tryParse(onlyNumber(_markupController.text))! / 100)
        .toStringAsFixed(2);

    precoVendaTemp = precoVenda(
      double.tryParse(_precoCustoText)!,
      double.tryParse(_markupText)!,
    );

    if ((widget.precoCusto == 0) && (widget.precoVenda > 0)) {
      _precoCustoController.text = widget.precoVenda.toStringAsFixed(2);
      _precoCustoText = widget.precoVenda.toStringAsFixed(2);
    }

    if ((widget.precoVenda == 0) && (widget.precoCusto > 0)) {
      _markupController.text = widget.precoVenda.toStringAsFixed(2);
      _markupText = widget.precoVenda.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    final formatPercentual = NumberFormat.currency(locale: 'pt_BR', symbol: '');

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
        title: const Padding(
          padding: EdgeInsets.only(bottom: 2),
          child: Text(
            'Calculadora de preço',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          child: WidgetTextFormField(
                                            labelText: 'Custo',
                                            border: true,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: _precoCustoController,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          child: WidgetTextFormField(
                                            labelText: 'Markup',
                                            border: true,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.done,
                                            controller: _markupController,
                                            onFieldSubmitted: (_) => _confirm(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),

                            color: Color.fromRGBO(248, 248, 248, 1),
                          ),

                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const FittedBox(
                                        child: Text(
                                          'Lucro',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          formatCurrency.format(
                                            lucro(
                                              double.tryParse(_precoCustoText)!,
                                              precoVendaTemp,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const FittedBox(
                                          child: Text(
                                            'Venda',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        FittedBox(
                                          child: Text(
                                            ' ${formatCurrency.format(precoVenda(double.tryParse(_precoCustoText)!, double.tryParse(_markupText)!))}'
                                                .trim(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const FittedBox(
                                        child: Text(
                                          'Margem',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          ' ${formatPercentual.format(percentualLucroMarkup(double.tryParse(_precoCustoText)!, precoVendaTemp))} %',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: Size(double.infinity, 45),
                    elevation: 0,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('Confirmar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
