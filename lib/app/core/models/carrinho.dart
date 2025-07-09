import 'dart:convert';
import 'package:flutter/widgets.dart';

class Carrinho {
  final String id;
  final String? produtoId;
  String nome;
  double quantidade;
  double preco;

  Carrinho({
    required this.id,
    this.produtoId = '',
    required this.nome,
    required this.quantidade,
    required this.preco,
  });

  Carrinho copyWith({
    String? id,
    ValueGetter<String?>? produtoId,
    String? nome,
    double? quantidade,
    double? preco,
  }) {
    return Carrinho(
      id: id ?? this.id,
      produtoId: produtoId != null ? produtoId() : this.produtoId,
      nome: nome ?? this.nome,
      quantidade: quantidade ?? this.quantidade,
      preco: preco ?? this.preco,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idProduto': produtoId,
      'nome': nome,
      'quantidade': quantidade,
      'preco': preco,
    };
  }

  factory Carrinho.fromMap(Map<String, dynamic> map) {
    return Carrinho(
      id: map['id'] ?? '',
      produtoId: map['idProduto'],
      nome: map['nome'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0.0,
      preco: map['preco']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Carrinho.fromJson(String source) =>
      Carrinho.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Carrinho(id: $id, idProduto: $produtoId, nome: $nome, quantidade: $quantidade, preco: $preco)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Carrinho &&
        other.id == id &&
        other.produtoId == produtoId &&
        other.nome == nome &&
        other.quantidade == quantidade &&
        other.preco == preco;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        produtoId.hashCode ^
        nome.hashCode ^
        quantidade.hashCode ^
        preco.hashCode;
  }
}
