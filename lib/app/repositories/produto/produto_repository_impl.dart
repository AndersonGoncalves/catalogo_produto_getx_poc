import 'package:dio/dio.dart';
import 'package:catalogo_produto_poc/app/core/constants/url.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/exceptions/http_exception.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  final String _token;
  final List<Produto> _produtos;
  late final Dio _dio;

  ProdutoRepositoryImpl({String token = '', List<Produto> produtos = const []})
    : _token = token,
      _produtos = produtos {
    _dio = Dio();
  }

  @override
  List<Produto> get produtos => [..._produtos];

  @override
  void add(Produto produto) {
    _produtos.add(produto);
  }

  @override
  Future<void> get() async {
    _produtos.clear();
    final response = await _dio.get(
      '${Url.firebase().produto}.json?auth=$_token',
    );
    if (response.data == null) return;
    Map<String, dynamic> data = response.data;
    data.forEach((modelId, modelData) {
      modelData['id'] = modelId;
      _produtos.add(Produto.fromMap(modelData, true));
    });
  }

  @override
  Future<void> post(Produto model) async {
    final response = await _dio.post(
      '${Url.firebase().produto}.json?auth=$_token',
      data: model.toJson(),
    );
    final id = response.data['name'];
    _produtos.add(model.copyWith(id: id));
  }

  @override
  Future<void> patch(Produto model) async {
    int index = _produtos.indexWhere((p) => p.id == model.id);
    if (index >= 0) {
      await _dio.patch(
        '${Url.firebase().produto}/${model.id}.json?auth=$_token',
        data: model.toJson(),
      );
      _produtos[index] = model;
    }
  }

  @override
  Future<void> delete(Produto model) async {
    int index = _produtos.indexWhere((p) => p.id == model.id);
    if (index >= 0) {
      final model = _produtos[index];
      _produtos.remove(model);

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
    }
  }

  @override
  Future<void> save(Map<String, dynamic> map) {
    final model = Produto.fromMap(map, false);
    if (model.id == '') {
      return post(model);
    } else {
      return patch(model);
    }
  }
}
