import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_text_button.dart';

class WidgetDialog {
  final BuildContext _context;
  final String nao;
  final String sim;

  WidgetDialog(this._context, this.nao, this.sim);

  Future<bool?> confirm({
    required String titulo,
    required String pergunta,
    required Function onConfirm,
    Function? onCancel,
  }) {
    return showDialog<bool>(
      barrierDismissible: false, //força o usuário tocar em um dos botões
      context: _context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(_context).canvasColor,
        title: Text(titulo),
        content: Text(pergunta),
        actions: <Widget>[
          WidgetTextButton(
            nao,
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          WidgetTextButton(
            sim,
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    ).then((value) {
      if (value ?? false) {
        return onConfirm();
      } else {
        if (onCancel != null) {
          onCancel();
        }
      }
      return null;
    });
  }

  Future<T?> ok<T>({required String titulo, required String frase}) {
    return showDialog<T>(
      barrierDismissible: false,
      context: _context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(_context).canvasColor,
        title: Text(titulo),
        content: Text(frase),
        actions: <Widget>[
          WidgetTextButton(
            'Ok',
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
