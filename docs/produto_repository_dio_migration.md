# Migração HTTP para Dio - ProdutoRepositoryImpl

## Visão Geral

Este documento descreve a migração da implementação do `ProdutoRepositoryImpl` do pacote `http` padrão do Flutter para o `Dio`, um cliente HTTP mais poderoso e flexível.

## Motivação para Migração

### Vantagens do Dio sobre HTTP padrão:

1. **Serialização Automática**: Conversão automática de JSON, eliminando `jsonDecode()`
2. **Interceptors**: Suporte nativo para interceptors de request/response
3. **Configuração Global**: Headers, timeouts e configurações reutilizáveis
4. **Melhor Tratamento de Erros**: `DioException` com informações detalhadas
5. **Performance Superior**: Otimizações internas e reutilização de conexões
6. **Cancelamento de Requests**: Suporte nativo para cancelar requisições
7. **Upload/Download**: Funcionalidades avançadas para transferência de arquivos

## Alterações Implementadas

### 1. Dependências

```yaml
# pubspec.yaml
dependencies:
  dio: ^5.8.0+1  # Adicionado
  # http: ^1.2.2  # Removido (mantido para outras partes do projeto)
```

### 2. Imports

**Antes:**
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
```

**Depois:**
```dart
import 'package:dio/dio.dart';
```

### 3. Instância do Dio

```dart
class ProdutoRepositoryImpl implements ProdutoRepository {
  late final Dio _dio;

  ProdutoRepositoryImpl({String token = '', List<Produto> produtos = const []})
    : _token = token,
      _produtos = produtos {
    _dio = Dio();  // Inicialização no construtor
  }
}
```

### 4. Métodos HTTP

#### GET Request
**Antes:**
```dart
final response = await http.get(
  Uri.parse('${Url.firebase().produto}.json?auth=$_token'),
);
if (response.body == 'null') return;
Map<String, dynamic> data = jsonDecode(response.body);
```

**Depois:**
```dart
final response = await _dio.get(
  '${Url.firebase().produto}.json?auth=$_token',
);
if (response.data == null) return;
Map<String, dynamic> data = response.data; // Já deserializado
```

#### POST Request
**Antes:**
```dart
final response = await http.post(
  Uri.parse('${Url.firebase().produto}.json?auth=$_token'),
  body: model.toJson(),
);
final id = jsonDecode(response.body)['name'];
```

**Depois:**
```dart
final response = await _dio.post(
  '${Url.firebase().produto}.json?auth=$_token',
  data: model.toJson(),
);
final id = response.data['name']; // Acesso direto
```

#### PATCH Request
**Antes:**
```dart
await http.patch(
  Uri.parse('${Url.firebase().produto}/${model.id}.json?auth=$_token'),
  body: model.toJson(),
);
```

**Depois:**
```dart
await _dio.patch(
  '${Url.firebase().produto}/${model.id}.json?auth=$_token',
  data: model.toJson(),
);
```

#### DELETE Request
**Antes:**
```dart
final response = await http.delete(
  Uri.parse('${Url.firebase().produto}/${model.id}.json?auth=$_token'),
  body: model.toJson(),
);

if (response.statusCode >= 400) {
  _produtos.insert(index, model);
  throw HttpException(
    msg: 'Falha ao excluir o produto',
    statusCode: response.statusCode,
  );
}
```

**Depois:**
```dart
try {
  await _dio.delete(
    '${Url.firebase().produto}/${model.id}.json?auth=$_token',
    data: model.toJson(),
  );
} catch (e) {
  _produtos.insert(index, model);
  if (e is DioException) {
    throw HttpException(
      msg: 'Falha ao excluir o produto',
      statusCode: e.response?.statusCode ?? 500,
    );
  }
  rethrow;
}
```

## Uso da Classe

### Exemplo Básico

```dart
// Instanciação
final repository = ProdutoRepositoryImpl(
  token: 'seu_firebase_token_aqui',
  produtos: [], // Lista inicial vazia
);

// Carregar produtos do Firebase
await repository.get();

// Acessar produtos carregados
List<Produto> produtos = repository.produtos;

// Adicionar novo produto
final novoProduto = Produto(
  nome: 'Produto Teste',
  preco: 99.99,
  // ... outros campos
);
await repository.post(novoProduto);

// Atualizar produto existente
final produtoAtualizado = novoProduto.copyWith(preco: 89.99);
await repository.patch(produtoAtualizado);

// Excluir produto
await repository.delete(produtoAtualizado);

// Salvar (criar ou atualizar baseado no ID)
await repository.save({
  'id': 'opcional',
  'nome': 'Produto',
  'preco': 50.0,
  // ... outros campos
});
```

### Integração com GetX Controller

```dart
class ProdutoController extends GetxController {
  final ProdutoRepositoryImpl _repository;
  
  ProdutoController(this._repository);

  final _produtos = <Produto>[].obs;
  final _loading = false.obs;

  List<Produto> get produtos => _produtos;
  bool get loading => _loading.value;

  Future<void> carregarProdutos() async {
    try {
      _loading.value = true;
      await _repository.get();
      _produtos.value = _repository.produtos;
    } catch (e) {
      // Tratar erro
    } finally {
      _loading.value = false;
    }
  }

  Future<void> adicionarProduto(Produto produto) async {
    try {
      await _repository.post(produto);
      _produtos.value = _repository.produtos;
    } catch (e) {
      // Tratar erro
    }
  }
}
```

## Configurações Avançadas do Dio

### Interceptors para Logs

```dart
ProdutoRepositoryImpl({String token = '', List<Produto> produtos = const []})
  : _token = token,
    _produtos = produtos {
  _dio = Dio();
  
  // Adicionar interceptor para logs (apenas em desenvolvimento)
  if (kDebugMode) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
    ));
  }
}
```

### Configurações Globais

```dart
_dio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
));
```

### Interceptor de Autenticação

```dart
_dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    // Adicionar token automaticamente
    if (_token.isNotEmpty) {
      options.queryParameters['auth'] = _token;
    }
    handler.next(options);
  },
  onError: (error, handler) {
    // Tratar erros globalmente
    if (error.response?.statusCode == 401) {
      // Token expirado, redirecionar para login
    }
    handler.next(error);
  },
));
```

## Tratamento de Erros

### Tipos de Erro do Dio

```dart
Future<void> exemploTratamentoErros() async {
  try {
    await _dio.get('/endpoint');
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        // Timeout de conexão
        break;
      case DioExceptionType.sendTimeout:
        // Timeout de envio
        break;
      case DioExceptionType.receiveTimeout:
        // Timeout de recebimento
        break;
      case DioExceptionType.badResponse:
        // Resposta HTTP com erro (4xx, 5xx)
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'];
        break;
      case DioExceptionType.cancel:
        // Requisição cancelada
        break;
      case DioExceptionType.connectionError:
        // Erro de conexão
        break;
      case DioExceptionType.unknown:
        // Erro desconhecido
        break;
    }
  }
}
```

## Testes Unitários

### Mockando Dio

```dart
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('ProdutoRepositoryImpl', () {
    late MockDio mockDio;
    late ProdutoRepositoryImpl repository;

    setUp(() {
      mockDio = MockDio();
      repository = ProdutoRepositoryImpl();
      // Injetar mock (requer refatoração do construtor)
    });

    test('deve carregar produtos com sucesso', () async {
      // Arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
        data: {'produto1': {'nome': 'Teste'}},
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ));

      // Act
      await repository.get();

      // Assert
      expect(repository.produtos.length, 1);
      verify(mockDio.get(any)).called(1);
    });
  });
}
```

## Migração Recomendada

### Próximos Passos

1. **Aplicar em outros repositórios**: Migrar `UsuarioRepositoryImpl` e `CarrinhoRepositoryImpl`
2. **Configuração centralizada**: Criar uma classe `DioConfig` para configurações globais
3. **Interceptors**: Implementar interceptors para autenticação automática
4. **Cache**: Adicionar interceptor de cache para melhorar performance
5. **Retry**: Implementar retry automático para falhas de rede

### Estrutura Sugerida

```
lib/
  core/
    http/
      dio_config.dart          # Configurações globais do Dio
      auth_interceptor.dart    # Interceptor de autenticação
      cache_interceptor.dart   # Interceptor de cache
      error_interceptor.dart   # Tratamento global de erros
```

## Considerações Finais

A migração para Dio melhora significativamente a robustez e flexibilidade do sistema de requisições HTTP. As principais melhorias incluem:

- ✅ Código mais limpo e legível
- ✅ Melhor tratamento de erros
- ✅ Performance superior
- ✅ Facilidade para adicionar funcionalidades como cache e retry
- ✅ Configuração centralizada e reutilizável

Esta migração estabelece uma base sólida para futuras expansões do sistema de comunicação HTTP da aplicação.
