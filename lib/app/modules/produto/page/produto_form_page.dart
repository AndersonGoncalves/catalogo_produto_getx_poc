import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';
import 'package:catalogo_produto_poc/app/core/ui/messages.dart';
import 'package:catalogo_produto_poc/app/core/ui/functions.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_loading_page.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_text_form_field.dart';
import 'package:catalogo_produto_poc/app/modules/produto/cubit/produto_controller.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_foto_grid.dart';
import 'package:catalogo_produto_poc/app/modules/produto/page/produto_calculadora_preco_page.dart';
import 'package:catalogo_produto_poc/app/modules/produto/cubit/produto_state.dart';

class ProdutoFormPage extends StatefulWidget {
  const ProdutoFormPage({super.key});

  @override
  State<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  bool _isLoading = false;
  Map<String, dynamic> _formData = <String, dynamic>{};
  final List<String> _fotos = [];
  final _formKey = GlobalKey<FormState>();
  final _nomeFocus = FocusNode();
  final _precoVendaFocus = FocusNode();
  final _precoCustoFocus = FocusNode();
  final _marcaFocus = FocusNode();
  final _descricaoFocus = FocusNode();
  final _quantidadeEmEstoqueFocus = FocusNode();
  final _codigoBarrasFocus = FocusNode();
  final _precoCustoController = TextEditingController();
  final _precoVendaController = TextEditingController();
  final _quantidadeEmEstoqueController = TextEditingController();
  final _codeBarController = TextEditingController();

  CurrencyTextInputFormatter currencyTextInputFormatter(
    BuildContext context, {
    int decimalDigits = 2,
  }) {
    return CurrencyTextInputFormatter.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: decimalDigits,
      turnOffGrouping: true,
    );
  }

  void _setValoresInicial() {
    _formData['id'] = '';
    _formData['nome'] = '';
    _formData['precoDeVenda'] = 0.0;
    _formData['precoDeCusto'] = 0.0;
    _formData['marca'] = '';
    _formData['descricao'] = '';
    _formData['quantidadeEmEstoque'] = 0;
    _formData['codigoBarras'] = '';
    _formData['fotos'] = [];
  }

  void _calcularPrecoVenda() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      //fullscreenDialog: true,
      builder: (_) {
        return ProdutoCalculadoraPrecoPage(
          precoCusto:
              (double.tryParse(onlyNumber(_precoCustoController.text))! / 100),
          precoVenda:
              double.tryParse(onlyNumber(_precoVendaController.text))! / 100,
          atualizar: (custo, venda) {
            setState(() {
              _precoCustoController.text = custo;
              _precoVendaController.text = venda;
            });
          },
        );
      },
    );
  }

  void _carregarFotos(Produto produto) {
    _fotos.clear();
    if (produto.fotos != null) {
      for (var i = 0; i < produto.fotos!.length; i++) {
        if (produto.fotos![i] != '') {
          _fotos.add(produto.fotos![i]);
        }
      }
    }
  }

  void _lerCodigoBarras() async {
    //https://pub.dev/documentation/barcode_scanner/latest/

    // String codigo = await FlutterBarcodeScanner.scanBarcode(
    //   '#FFFFFF',
    //   'Cancelar',
    //   true,
    //   ScanMode.BARCODE,
    // );

    // if (codigo == '-1') {
    //   if (mounted) {
    //     Messages.of(context).showError('Falha ao ler código de barras');
    //   }
    // } else {
    //   _codeBarController.text = codigo;
    // }
  }

  Future<void> _save() async {
    _formData['fotos'] = _fotos.toList();
    final formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      _formKey.currentState?.save();
      await context.read<ProdutoController>().save(_formData);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      bool visualizandoDados = (arg != null);
      if (visualizandoDados) {
        final produto = arg as Produto;
        _formData = produto.toMap();
        _carregarFotos(produto);
        _precoVendaController.text = _formData['precoDeVenda'].toStringAsFixed(
          2,
        );
        _precoCustoController.text = _formData['precoDeCusto'].toStringAsFixed(
          2,
        );
        _codeBarController.text = _formData['codigoBarras'].toString();
        _quantidadeEmEstoqueController.text = _formData['quantidadeEmEstoque']
            .toString();
      } else {
        _setValoresInicial();
      }
    }
  }

  @override
  void dispose() {
    _fotos.clear();
    _nomeFocus.dispose();
    _descricaoFocus.dispose();
    _precoVendaFocus.dispose();
    _precoCustoFocus.dispose();
    _quantidadeEmEstoqueFocus.dispose();
    _codigoBarrasFocus.dispose();
    _precoCustoController.dispose();
    _precoVendaController.dispose();
    _quantidadeEmEstoqueController.dispose();
    _codeBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProdutoController, ProdutoState>(
      listener: (context, state) {
        _isLoading = state.isLoading;
        if (state.error != null && state.error!.isNotEmpty) {
          Messages.of(context).showError(state.error!);
        }
        // Se não está carregando e não há erro, fecha a tela após salvar
        if (!state.isLoading &&
            state.error == null &&
            ModalRoute.of(context)?.isCurrent == true) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: _isLoading
              ? WidgetLoadingPage(
                  label: 'Salvando...',
                  labelColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Colors.white,
                )
              : Form(
                  key: _formKey,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverAppBar(
                                elevation: 0,
                                toolbarHeight: 56,
                                automaticallyImplyLeading: true,
                                pinned: true,
                                expandedHeight: _fotos.isEmpty ? 56 : 300,
                                flexibleSpace: FlexibleSpaceBar(
                                  title: Text('Produto'),
                                  background: _fotos.isEmpty
                                      ? const SizedBox()
                                      : Image.network(
                                          _fotos[0],
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.white,
                                foregroundColor: Colors.black,

                                leading: IconButton(
                                  onPressed: Navigator.of(context).pop,
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildListDelegate(<Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        WidgetTextFormField(
                                          labelText: 'Nome',
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _nomeFocus,
                                          initialValue: _formData['nome']
                                              ?.toString(),
                                          validator: Validatorless.required(
                                            'Nome é obrigatório',
                                          ),
                                          onSaved: (value) =>
                                              _formData['nome'] = value ?? '',
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(_precoCustoFocus),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                          ),
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
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: _precoCustoFocus,
                                                    inputFormatters: [
                                                      currencyTextInputFormatter(
                                                        context,
                                                      ),
                                                    ],
                                                    controller:
                                                        _precoCustoController,

                                                    validator:
                                                        Validatorless.multiple([
                                                          Validatorless.required(
                                                            'Custo é obrigatório',
                                                          ),
                                                        ]),
                                                    onSaved: (value) =>
                                                        _formData['precoDeCusto'] =
                                                            value ?? 0.00,
                                                    onFieldSubmitted: (_) =>
                                                        FocusScope.of(
                                                          context,
                                                        ).requestFocus(
                                                          _precoVendaFocus,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: SizedBox(
                                                  child: WidgetTextFormField(
                                                    labelText: 'Venda',
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    suffixIcon: const Icon(
                                                      Icons.calculate_outlined,
                                                    ),
                                                    suffixIconOnPressed:
                                                        _calcularPrecoVenda,
                                                    focusNode: _precoVendaFocus,
                                                    inputFormatters: [
                                                      currencyTextInputFormatter(
                                                        context,
                                                      ),
                                                    ],
                                                    controller:
                                                        _precoVendaController,
                                                    validator:
                                                        Validatorless.multiple([
                                                          Validatorless.required(
                                                            'Venda é obrigatório',
                                                          ),
                                                        ]),
                                                    onSaved: (value) =>
                                                        _formData['precoDeVenda'] =
                                                            value ?? 0.00,
                                                    onFieldSubmitted: (_) =>
                                                        FocusScope.of(
                                                          context,
                                                        ).requestFocus(
                                                          _quantidadeEmEstoqueFocus,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 15,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        WidgetTextFormField(
                                          labelText: 'Quantidade em estoque',
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _quantidadeEmEstoqueFocus,
                                          controller:
                                              _quantidadeEmEstoqueController,
                                          validator: (value) {
                                            final nome = value ?? '';
                                            if (nome.trim().isEmpty) {
                                              return 'Quantidade é obrigatório';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) =>
                                              _formData['quantidadeEmEstoque'] =
                                                  value ?? 0,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(
                                                _codigoBarrasFocus,
                                              ),
                                        ),

                                        WidgetTextFormField(
                                          labelText: 'Código de Barras',
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _codigoBarrasFocus,
                                          suffixIcon:
                                              Theme.of(context).platform ==
                                                  TargetPlatform.windows
                                              ? null
                                              : const Icon(Icons.qr_code_2),
                                          suffixIconOnPressed:
                                              Theme.of(context).platform ==
                                                  TargetPlatform.windows
                                              ? null
                                              : () => _lerCodigoBarras(),

                                          controller: _codeBarController,

                                          onSaved: (value) =>
                                              _formData['codigoBarras'] =
                                                  value ?? '',
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(_marcaFocus),
                                        ),

                                        WidgetTextFormField(
                                          labelText: 'Marca',
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _marcaFocus,
                                          initialValue: _formData['marca']
                                              ?.toString(),
                                          onSaved: (value) =>
                                              _formData['marca'] = value ?? '',
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(_descricaoFocus),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 15,
                                            top: 10,
                                          ),
                                          child: WidgetTextFormField(
                                            labelText: 'Descrição',
                                            keyboardType:
                                                TextInputType.multiline,
                                            textInputAction:
                                                TextInputAction.newline,
                                            focusNode: _descricaoFocus,
                                            initialValue: _formData['descricao']
                                                ?.toString(),
                                            validator: Validatorless.multiple([
                                              Validatorless.required(
                                                'Descrição é obrigatório',
                                              ),
                                            ]),
                                            onSaved: (value) =>
                                                _formData['descricao'] =
                                                    value ?? '',
                                            maxLines: null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ProdutoFotoGrid(fotoList: _fotos),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 10,
                          ),
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: Size(double.infinity, 45),
                              elevation: 0,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text('Salvar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
