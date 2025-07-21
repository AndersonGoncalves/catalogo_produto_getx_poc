import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:catalogo_produto_poc/app/core/constants/url.dart';
import 'package:catalogo_produto_poc/app/core/models/produto.dart';
import 'package:catalogo_produto_poc/app/core/exceptions/http_exception.dart';
import 'package:catalogo_produto_poc/app/repositories/produto/produto_repository.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  final String _token;
  final List<Produto> _produtos;

  ProdutoRepositoryImpl({String token = '', List<Produto> produtos = const []})
    : _token = token,
      _produtos = produtos;

  @override
  List<Produto> get produtos => [..._produtos];

  @override
  void add(Produto produto) {
    _produtos.add(produto);
  }

  @override
  Future<void> get() async {
    _produtos.clear();
    final response = await http.get(
      Uri.parse('${Url.firebase().produto}.json?auth=$_token'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((modelId, modelData) {
      modelData['id'] = modelId;
      _produtos.add(Produto.fromMap(modelData, true));
    });
  }

  @override
  Future<void> post(Produto model) async {
    final response = await http.post(
      Uri.parse('${Url.firebase().produto}.json?auth=$_token'),
      body: model.toJson(),
    );
    final id = jsonDecode(response.body)['name'];
    _produtos.add(model.copyWith(id: id));
  }

  @override
  Future<void> patch(Produto model) async {
    int index = _produtos.indexWhere((p) => p.id == model.id);
    if (index >= 0) {
      await http.patch(
        Uri.parse('${Url.firebase().produto}/${model.id}.json?auth=$_token'),
        body: model.toJson(),
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
