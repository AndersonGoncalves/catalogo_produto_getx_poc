import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/models/carrinho.dart';
import 'package:catalogo_produto_poc/app/services/carrinho/carrinho_service.dart';
import 'package:catalogo_produto_poc/app/modules/carrinho/cubit/carrinho_state.dart';

class CarrinhoController extends Cubit<CarrinhoState> {
  final CarrinhoService _carrinhoService;

  CarrinhoController({required CarrinhoService carrinhoService})
    : _carrinhoService = carrinhoService,
      super(CarrinhoState());

  Map<String, Carrinho> get items => _carrinhoService.items;

  int get quantidadeItem => _carrinhoService.quantidadeItem;

  double get valorTotal => _carrinhoService.valorTotal;

  void add(Produto produto) {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      _carrinhoService.add(produto);
      emit(
        state.copyWith(
          items: _carrinhoService.items.values.toList(),
          isLoading: false,
          success: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Erro ao adicionar produto: ${e.toString()}',
          isLoading: false,
          success: false,
        ),
      );
    }
  }

  void remove(String produtoId) {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      _carrinhoService.remove(produtoId);
      emit(
        state.copyWith(
          items: _carrinhoService.items.values.toList(),
          isLoading: false,
          success: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Erro ao remover produto: ${e.toString()}',
          isLoading: false,
          success: false,
        ),
      );
    }
  }

  void removeSingleItem(String produtoId) {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      _carrinhoService.removeSingleItem(produtoId);
      emit(
        state.copyWith(
          items: _carrinhoService.items.values.toList(),
          isLoading: false,
          success: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Erro ao remover item: ${e.toString()}',
          isLoading: false,
          success: false,
        ),
      );
    }
  }

  void clear() {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      _carrinhoService.clear();
      emit(
        state.copyWith(
          items: _carrinhoService.items.values.toList(),
          isLoading: false,
          success: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Erro ao limpar carrinho: ${e.toString()}',
          isLoading: false,
          success: false,
        ),
      );
    }
  }
}
