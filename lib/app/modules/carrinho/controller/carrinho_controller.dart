import 'package:get/get.dart';
import 'package:catalogo_produto_poc/app/core/ui/messages.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/models/carrinho.dart';
import 'package:catalogo_produto_poc/app/services/carrinho/carrinho_service.dart';

class CarrinhoController extends GetxController {
  final CarrinhoService _carrinhoService;

  CarrinhoController({required CarrinhoService carrinhoService})
    : _carrinhoService = carrinhoService;

  // Observables reactivos
  final RxString _error = RxString('');
  final RxBool _success = false.obs;
  final RxBool _isLoading = false.obs;
  final RxList<Carrinho> _items = <Carrinho>[].obs;

  // Getters para acessar os valores reativos
  String get error => _error.value;
  bool get success => _success.value;
  bool get isLoading => _isLoading.value;
  List<Carrinho> get items => _items;

  // Getters para observables (para uso em workers externos)
  RxString get errorObservable => _error;
  RxBool get successObservable => _success;
  RxBool get isLoadingObservable => _isLoading;

  // Getters do serviço
  Map<String, Carrinho> get itemsMap => _carrinhoService.items;
  int get quantidadeItem => _carrinhoService.quantidadeItem;
  double get valorTotal => _carrinhoService.valorTotal;

  @override
  void onInit() {
    super.onInit();
    // Inicializa com os itens atuais do serviço
    _updateItems();
  }

  void _updateItems() {
    _items.value = _carrinhoService.items.values.toList();
  }

  void _setLoading(bool loading) {
    _isLoading.value = loading;
    if (loading) {
      _error.value = '';
      _success.value = false;
    }
  }

  void _setSuccess() {
    _success.value = true;
    _isLoading.value = false;
    _error.value = '';
    _updateItems();
  }

  void _setError(String errorMessage) {
    _error.value = errorMessage;
    _isLoading.value = false;
    _success.value = false;
  }

  void add(Produto produto) {
    _setLoading(true);

    try {
      _carrinhoService.add(produto);
      _setSuccess();
    } catch (e) {
      _setError('Erro ao adicionar produto: ${e.toString()}');
    }
  }

  void remove(String produtoId) {
    _setLoading(true);

    try {
      _carrinhoService.remove(produtoId);
      _setSuccess();
    } catch (e) {
      _setError('Erro ao remover produto: ${e.toString()}');
    }
  }

  void removeSingleItem(String produtoId) {
    _setLoading(true);

    try {
      _carrinhoService.removeSingleItem(produtoId);
      _setSuccess();
    } catch (e) {
      _setError('Erro ao remover item: ${e.toString()}');
    }
  }

  void clear() {
    _setLoading(true);

    try {
      _carrinhoService.clear();
      _setSuccess();
    } catch (e) {
      _setError('Erro ao limpar carrinho: ${e.toString()}');
    }
  }

  // Workers para side effects
  void _setupWorkers() {
    // Worker para monitorar mudanças no sucesso
    ever(_success, (bool success) {
      if (success) {
        // Pode ser usado para mostrar snackbars ou outras ações
        // quando uma operação é bem-sucedida
      }
    });

    // Worker para monitorar erros
    ever(_error, (String error) {
      if (error.isNotEmpty) {
        // Pode ser usado para mostrar snackbars de erro
        Messages.showError(error);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _setupWorkers();
  }

  // Método para limpar o estado de erro
  void clearError() {
    _error.value = '';
  }

  // Método para limpar o estado de sucesso
  void clearSuccess() {
    _success.value = false;
  }
}
