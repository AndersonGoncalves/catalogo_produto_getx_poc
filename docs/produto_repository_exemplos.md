# Exemplos Práticos - ProdutoRepositoryImpl com Dio

## Exemplos de Uso Completos

### 1. Uso Básico no Controller GetX

```dart
// lib/app/modules/produto/produto_controller.dart
import 'package:get/get.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository_impl.dart';

class ProdutoController extends GetxController {
  final ProdutoRepositoryImpl _repository = Get.find<ProdutoRepositoryImpl>();
  
  final _produtos = <Produto>[].obs;
  final _loading = false.obs;
  final _erro = ''.obs;

  // Getters
  List<Produto> get produtos => _produtos;
  bool get loading => _loading.value;
  String get erro => _erro.value;

  @override
  void onInit() {
    super.onInit();
    carregarProdutos();
  }

  Future<void> carregarProdutos() async {
    try {
      _loading.value = true;
      _erro.value = '';
      
      await _repository.get();
      _produtos.value = _repository.produtos;
      
      Get.snackbar('Sucesso', 'Produtos carregados com sucesso');
    } catch (e) {
      _erro.value = 'Erro ao carregar produtos: $e';
      Get.snackbar('Erro', _erro.value, backgroundColor: Colors.red);
    } finally {
      _loading.value = false;
    }
  }

  Future<void> adicionarProduto(Produto produto) async {
    try {
      _loading.value = true;
      
      await _repository.post(produto);
      _produtos.value = _repository.produtos;
      
      Get.back(); // Fechar tela de cadastro
      Get.snackbar('Sucesso', 'Produto adicionado com sucesso');
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao adicionar produto: $e');
    } finally {
      _loading.value = false;
    }
  }

  Future<void> atualizarProduto(Produto produto) async {
    try {
      _loading.value = true;
      
      await _repository.patch(produto);
      _produtos.value = _repository.produtos;
      
      Get.back(); // Fechar tela de edição
      Get.snackbar('Sucesso', 'Produto atualizado com sucesso');
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao atualizar produto: $e');
    } finally {
      _loading.value = false;
    }
  }

  Future<void> excluirProduto(Produto produto) async {
    try {
      final confirmacao = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Deseja realmente excluir o produto "${produto.nome}"?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: Text('Excluir'),
            ),
          ],
        ),
      );

      if (confirmacao == true) {
        _loading.value = true;
        
        await _repository.delete(produto);
        _produtos.value = _repository.produtos;
        
        Get.snackbar('Sucesso', 'Produto excluído com sucesso');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao excluir produto: $e');
    } finally {
      _loading.value = false;
    }
  }

  void filtrarProdutos(String termo) {
    if (termo.isEmpty) {
      _produtos.value = _repository.produtos;
    } else {
      _produtos.value = _repository.produtos
          .where((produto) => 
              produto.nome.toLowerCase().contains(termo.toLowerCase()))
          .toList();
    }
  }
}
```

### 2. Configuração Avançada do Dio

```dart
// lib/app/core/http/dio_config.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioConfig {
  static Dio createDio({String? token}) {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptor de logs (apenas em desenvolvimento)
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        logPrint: (log) => debugPrint('DIO: $log'),
      ));
    }

    // Interceptor de autenticação
    if (token != null && token.isNotEmpty) {
      dio.interceptors.add(AuthInterceptor(token));
    }

    // Interceptor de retry
    dio.interceptors.add(RetryInterceptor());

    return dio;
  }
}

// Interceptor de autenticação
class AuthInterceptor extends Interceptor {
  final String token;

  AuthInterceptor(this.token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Adicionar token automaticamente na query string para Firebase
    options.queryParameters['auth'] = token;
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token inválido/expirado
      // Aqui você pode implementar logout automático
      Get.offAllNamed('/login');
    }
    super.onError(err, handler);
  }
}

// Interceptor de retry automático
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] ?? 0;

    if (retryCount < maxRetries && _shouldRetry(err)) {
      extra['retryCount'] = retryCount + 1;
      
      await Future.delayed(retryDelay * (retryCount + 1));
      
      try {
        final response = await err.requestOptions.copyWith(extra: extra);
        handler.resolve(response);
      } catch (e) {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode != null && 
            err.response!.statusCode >= 500);
  }
}
```

### 3. Repository Melhorado com Dio Configurado

```dart
// lib/app/repositories/produto/produto_repository_impl_v2.dart
import 'package:dio/dio.dart';
import 'package:catalogo_produto_poc/app/core/constants/url.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/exceptions/http_exception.dart';
import 'package:catalogo_produto_poc/app/core/http/dio_config.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository.dart';

class ProdutoRepositoryImplV2 implements ProdutoRepository {
  final String _token;
  final List<Produto> _produtos;
  late final Dio _dio;

  ProdutoRepositoryImplV2({
    String token = '',
    List<Produto> produtos = const [],
  }) : _token = token,
       _produtos = produtos {
    _dio = DioConfig.createDio(token: _token);
  }

  @override
  List<Produto> get produtos => [..._produtos];

  @override
  void add(Produto produto) {
    _produtos.add(produto);
  }

  @override
  Future<void> get() async {
    try {
      _produtos.clear();
      
      final response = await _dio.get(
        '${Url.firebase().produto}.json',
      );
      
      if (response.data == null) return;
      
      final Map<String, dynamic> data = response.data;
      data.forEach((modelId, modelData) {
        modelData['id'] = modelId;
        _produtos.add(Produto.fromMap(modelData, true));
      });
    } on DioException catch (e) {
      throw _handleDioException(e, 'Erro ao carregar produtos');
    }
  }

  @override
  Future<void> post(Produto model) async {
    try {
      final response = await _dio.post(
        '${Url.firebase().produto}.json',
        data: model.toMap(),
      );
      
      final id = response.data['name'];
      _produtos.add(model.copyWith(id: id));
    } on DioException catch (e) {
      throw _handleDioException(e, 'Erro ao criar produto');
    }
  }

  @override
  Future<void> patch(Produto model) async {
    try {
      final index = _produtos.indexWhere((p) => p.id == model.id);
      if (index >= 0) {
        await _dio.patch(
          '${Url.firebase().produto}/${model.id}.json',
          data: model.toMap(),
        );
        _produtos[index] = model;
      }
    } on DioException catch (e) {
      throw _handleDioException(e, 'Erro ao atualizar produto');
    }
  }

  @override
  Future<void> delete(Produto model) async {
    final index = _produtos.indexWhere((p) => p.id == model.id);
    if (index >= 0) {
      final produto = _produtos[index];
      _produtos.remove(produto);

      try {
        await _dio.delete(
          '${Url.firebase().produto}/${model.id}.json',
        );
      } on DioException catch (e) {
        // Reverter remoção em caso de erro
        _produtos.insert(index, produto);
        throw _handleDioException(e, 'Erro ao excluir produto');
      }
    }
  }

  @override
  Future<void> save(Map<String, dynamic> map) {
    final model = Produto.fromMap(map, false);
    if (model.id.isEmpty) {
      return post(model);
    } else {
      return patch(model);
    }
  }

  // Método privado para tratamento unificado de erros
  HttpException _handleDioException(DioException e, String defaultMessage) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return HttpException(
          msg: 'Timeout: Verifique sua conexão com a internet',
          statusCode: 408,
        );
      
      case DioExceptionType.connectionError:
        return HttpException(
          msg: 'Erro de conexão: Verifique sua internet',
          statusCode: 0,
        );
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 500;
        final message = e.response?.data?['error'] ?? defaultMessage;
        return HttpException(
          msg: message,
          statusCode: statusCode,
        );
      
      case DioExceptionType.cancel:
        return HttpException(
          msg: 'Operação cancelada',
          statusCode: 0,
        );
      
      default:
        return HttpException(
          msg: defaultMessage,
          statusCode: 500,
        );
    }
  }
}
```

### 4. Configuração no App Provider

```dart
// lib/app/app_provider.dart (atualizado)
import 'package:get/get.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository_impl_v2.dart';
import 'package:catalogo_produto_poc/app/services/usuario/usuario_service_impl.dart';

class AppProvider {
  static void init() {
    // Usuario Service
    Get.lazyPut<UsuarioServiceImpl>(() => UsuarioServiceImpl());
    
    // Produto Repository com token dinâmico
    Get.lazyPut<ProdutoRepositoryImplV2>(() {
      final usuarioService = Get.find<UsuarioServiceImpl>();
      final token = usuarioService.token; // Assumindo que existe um getter token
      
      return ProdutoRepositoryImplV2(token: token);
    });
    
    // Controllers
    Get.lazyPut<ProdutoController>(() => ProdutoController());
  }
}
```

### 5. Exemplo de Uso na UI

```dart
// lib/app/modules/produto/produto_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:catalogo_produto_poc/app/modules/produto/produto_controller.dart';

class ProdutoListPage extends GetView<ProdutoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        actions: [
          IconButton(
            onPressed: controller.carregarProdutos,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar produtos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: controller.filtrarProdutos,
            ),
          ),
          
          // Lista de produtos
          Expanded(
            child: Obx(() {
              if (controller.loading) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (controller.erro.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(controller.erro),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.carregarProdutos,
                        child: Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                );
              }
              
              if (controller.produtos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Nenhum produto encontrado'),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                itemCount: controller.produtos.length,
                itemBuilder: (context, index) {
                  final produto = controller.produtos[index];
                  return ListTile(
                    title: Text(produto.nome),
                    subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Editar'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Excluir'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.toNamed('/produto/edit', arguments: produto);
                        } else if (value == 'delete') {
                          controller.excluirProduto(produto);
                        }
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/produto/add'),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## Testes Unitários

### Exemplo de Teste com Mock

```dart
// test/app/repositories/produto_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository_impl.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';

@GenerateMocks([Dio])
import 'produto_repository_test.mocks.dart';

void main() {
  group('ProdutoRepositoryImpl', () {
    late MockDio mockDio;
    late ProdutoRepositoryImpl repository;

    setUp(() {
      mockDio = MockDio();
      // Para usar mock, seria necessário refatorar o construtor
      // ou usar injeção de dependência
    });

    test('deve carregar produtos com sucesso', () async {
      // Arrange
      final responseData = {
        'produto1': {
          'nome': 'Produto Teste',
          'preco': 99.99,
        }
      };

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      await repository.get();

      // Assert
      expect(repository.produtos.length, 1);
      expect(repository.produtos.first.nome, 'Produto Teste');
      verify(mockDio.get(any)).called(1);
    });

    test('deve tratar erro de timeout', () async {
      // Arrange
      when(mockDio.get(any)).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act & Assert
      expect(
        () => repository.get(),
        throwsA(isA<HttpException>()),
      );
    });
  });
}
```

Este arquivo complementa a documentação principal com exemplos práticos detalhados de como usar o `ProdutoRepositoryImpl` com Dio em um contexto real de aplicação Flutter com GetX.
