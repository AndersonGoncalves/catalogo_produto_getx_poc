import 'package:catalogo_produto_poc/app/core/models/produto.dart';

class ProdutoState {
  String? error;
  bool success = false;
  bool isLoading = false;
  final List<Produto> produtos;

  ProdutoState({
    this.error,
    this.success = false,
    this.isLoading = false,
    this.produtos = const [],
  });

  ProdutoState copyWith({
    String? error,
    bool? success,
    bool? isLoading,
    List<Produto>? produtos,
  }) {
    return ProdutoState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      produtos: produtos ?? this.produtos,
    );
  }
}
