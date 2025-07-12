import 'package:get/get.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/services/produto/produto_service.dart';

class ProdutoController extends GetxController {
  final ProdutoService _produtoService;

  ProdutoController({required ProdutoService produtoService})
    : _produtoService = produtoService;

  // Estados reativos usando GetX
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _success = false.obs;
  final RxList<Produto> _produtos = <Produto>[].obs;

  // Getters para acessar os estados
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get success => _success.value;
  List<Produto> get produtos => _produtos.toList();

  // Getters observáveis para uso com ever() e outros workers
  RxBool get isLoadingObs => _isLoading;
  RxString get errorObs => _error;
  RxBool get successObs => _success;
  RxList<Produto> get produtosObs => _produtos;

  /// Métodos privados para controle de estado
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setError(String error) {
    _error.value = error;
    _success.value = false;
  }

  void _setSuccess(bool success) {
    _success.value = success;
    if (success) {
      _error.value = '';
    }
  }

  /// Carrega a lista de produtos
  Future<void> load() async {
    try {
      _setLoading(true);
      await _produtoService.get();

      // Atualiza produtos apenas se mudaram
      final newProdutos = _produtoService.produtos;
      if (_produtos.length != newProdutos.length ||
          !_produtos.every((p) => newProdutos.any((np) => np.id == p.id))) {
        _produtos.value = newProdutos;
      }

      // Apenas limpa erro se havia erro anterior
      if (_error.value.isNotEmpty) {
        _error.value = '';
      }
    } catch (e) {
      _setError('Erro ao carregar produtos: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Salva um produto
  Future<void> save(Map<String, dynamic> formData) async {
    try {
      _setLoading(true);

      // Usa o método save do service que já aceita Map<String, dynamic>
      await _produtoService.save(formData);

      // Atualiza a lista após salvar
      _produtos.value = _produtoService.produtos;

      _setSuccess(true);
    } catch (e) {
      _setError('Erro ao salvar produto: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Remove um produto
  Future<void> remove(Produto produto) async {
    try {
      _setLoading(true);
      await _produtoService.delete(produto);

      // Atualiza a lista após remover
      _produtos.value = _produtoService.produtos;

      _setSuccess(true);
    } catch (e) {
      _setError('Erro ao remover produto: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Atualiza um produto específico
  Future<void> updateProduto(Produto produto) async {
    try {
      _setLoading(true);

      // Converte produto para Map para usar o método save
      final formData = produto.toMap();
      await _produtoService.save(formData);

      // Atualiza a lista após atualizar
      _produtos.value = _produtoService.produtos;

      _setSuccess(true);
    } catch (e) {
      _setError('Erro ao atualizar produto: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Adiciona um produto localmente (sem persistir)
  void add(Produto produto) {
    _produtos.add(produto);
  }

  /// Limpa mensagens de erro
  void clearError() {
    _error.value = '';
  }

  /// Limpa estado de sucesso
  void clearSuccess() {
    _success.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    // Cleanup se necessário
    super.onClose();
  }
}
