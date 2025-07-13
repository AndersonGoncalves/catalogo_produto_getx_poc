import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_text_button.dart';

class WidgetDialog {
  final String nao;
  final String sim;

  WidgetDialog(this.nao, this.sim);

  /// Dialog de confirmação usando GetX
  /// Retorna Future<bool?> onde true = confirmou, false = cancelou, null = dismissiu
  Future<bool?> confirm({
    required String titulo,
    required String pergunta,
    required Function onConfirm,
    Function? onCancel,
    bool barrierDismissible = false,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Get.theme.canvasColor,
        title: Text(titulo),
        content: Text(pergunta),
        actions: <Widget>[
          WidgetTextButton(
            nao,
            onPressed: () {
              Get.back(result: false);
            },
          ),
          WidgetTextButton(
            sim,
            onPressed: () {
              Get.back(result: true);
            },
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
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

  /// Dialog de OK usando GetX
  /// Para exibir mensagens informativas
  Future<T?> ok<T>({
    required String titulo,
    required String frase,
    bool barrierDismissible = false,
  }) {
    return Get.dialog<T>(
      AlertDialog(
        backgroundColor: Get.theme.canvasColor,
        title: Text(titulo),
        content: Text(frase),
        actions: <Widget>[
          WidgetTextButton(
            'Ok',
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Métodos estáticos para facilitar o uso sem instanciar a classe
  static Future<bool?> confirmDialog({
    required String titulo,
    required String pergunta,
    required Function onConfirm,
    Function? onCancel,
    String nao = 'Não',
    String sim = 'Sim',
    bool barrierDismissible = false,
  }) {
    return WidgetDialog(nao, sim).confirm(
      titulo: titulo,
      pergunta: pergunta,
      onConfirm: onConfirm,
      onCancel: onCancel,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<T?> okDialog<T>({
    required String titulo,
    required String frase,
    bool barrierDismissible = false,
  }) {
    return WidgetDialog('', '').ok<T>(
      titulo: titulo,
      frase: frase,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Método para exibir dialog de loading usando GetX
  static void showLoading({
    String title = 'Carregando...',
    bool barrierDismissible = false,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.canvasColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(title),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Método para fechar o dialog de loading
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Dialog customizado com ações personalizadas
  static Future<T?> customDialog<T>({
    required String titulo,
    required Widget content,
    required List<Widget> actions,
    bool barrierDismissible = false,
  }) {
    return Get.dialog<T>(
      AlertDialog(
        backgroundColor: Get.theme.canvasColor,
        title: Text(titulo),
        content: content,
        actions: actions,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Dialog de input de texto
  static Future<String?> inputDialog({
    required String titulo,
    required String hint,
    String? initialValue,
    String? Function(String?)? validator,
    bool barrierDismissible = false,
  }) {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Get.dialog<String>(
      AlertDialog(
        backgroundColor: Get.theme.canvasColor,
        title: Text(titulo),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(),
            ),
            validator: validator,
            autofocus: true,
          ),
        ),
        actions: [
          WidgetTextButton('Cancelar', onPressed: () => Get.back(result: null)),
          WidgetTextButton(
            'OK',
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Get.back(result: controller.text);
              }
            },
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Dialog de seleção de opções
  static Future<T?> selectionDialog<T>({
    required String titulo,
    required List<T> options,
    required String Function(T) optionLabel,
    bool barrierDismissible = false,
  }) {
    return Get.dialog<T>(
      AlertDialog(
        backgroundColor: Get.theme.canvasColor,
        title: Text(titulo),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return ListTile(
                title: Text(optionLabel(option)),
                onTap: () => Get.back(result: option),
              );
            }).toList(),
          ),
        ),
        actions: [
          WidgetTextButton('Cancelar', onPressed: () => Get.back(result: null)),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
