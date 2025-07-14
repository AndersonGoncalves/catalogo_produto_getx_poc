import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_dialog.dart';

/// Exemplos de uso da WidgetDialog
class ExemplosUsoDialog {
  /// Exemplo 1: Dialog de confirmação básico
  static Future<void> exemploConfirmacao() async {
    await WidgetDialog.confirmDialog(
      titulo: 'Atenção',
      pergunta: 'Deseja realmente excluir este item?',
      onConfirm: () {
        // Ação de confirmação
        Get.snackbar('Sucesso', 'Item excluído com sucesso!');
      },
      onCancel: () {
        // Ação de cancelamento (opcional)
        Get.snackbar('Cancelado', 'Operação cancelada');
      },
    );
  }

  /// Exemplo 2: Dialog OK para informação
  static Future<void> exemploOk() async {
    await WidgetDialog.okDialog(
      titulo: 'Informação',
      frase: 'Operação realizada com sucesso!',
    );
  }

  /// Exemplo 3: Dialog de loading
  static Future<void> exemploLoading() async {
    // Mostrar loading
    WidgetDialog.showLoading(title: 'Processando...');

    // Simular operação
    await Future.delayed(Duration(seconds: 3));

    // Esconder loading
    WidgetDialog.hideLoading();

    // Mostrar resultado
    await WidgetDialog.okDialog(
      titulo: 'Concluído',
      frase: 'Processamento finalizado!',
    );
  }

  /// Exemplo 4: Dialog de input
  static Future<void> exemploInput() async {
    final String? nome = await WidgetDialog.inputDialog(
      titulo: 'Digite seu nome',
      hint: 'Nome completo',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nome é obrigatório';
        }
        if (value.length < 3) {
          return 'Nome deve ter pelo menos 3 caracteres';
        }
        return null;
      },
    );

    if (nome != null) {
      Get.snackbar('Nome digitado', 'Olá, $nome!');
    }
  }

  /// Exemplo 5: Dialog de seleção
  static Future<void> exemploSelecao() async {
    final List<String> cores = ['Vermelho', 'Verde', 'Azul', 'Amarelo'];

    final String? corSelecionada = await WidgetDialog.selectionDialog<String>(
      titulo: 'Escolha uma cor',
      options: cores,
      optionLabel: (cor) => cor,
    );

    if (corSelecionada != null) {
      Get.snackbar('Cor selecionada', 'Você escolheu: $corSelecionada');
    }
  }

  /// Exemplo 6: Dialog customizado
  static Future<void> exemploCustomizado() async {
    await WidgetDialog.customDialog(
      titulo: 'Dialog Customizado',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning, size: 48, color: Colors.orange),
          SizedBox(height: 16),
          Text('Este é um dialog totalmente customizado'),
          SizedBox(height: 8),
          Text('Você pode adicionar qualquer widget aqui'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('Entendi')),
      ],
    );
  }

  /// Exemplo 7: Usando a instância da classe (método tradicional)
  static Future<void> exemploInstancia() async {
    final dialog = WidgetDialog('Cancelar', 'Confirmar');

    await dialog.confirm(
      titulo: 'Logout',
      pergunta: 'Deseja sair da aplicação?',
      onConfirm: () {
        // Lógica de logout
        Get.offAllNamed('/login');
      },
    );
  }

  /// Exemplo 8: Dialog com tema customizado
  static Future<void> exemploTemaCustomizado() async {
    await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Tema Escuro', style: TextStyle(color: Colors.white)),
        content: Text(
          'Este dialog usa um tema customizado',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

/// Widget de exemplo para demonstrar os dialogs
class DialogExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exemplos Dialog GetX')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: ExemplosUsoDialog.exemploConfirmacao,
              child: Text('Dialog de Confirmação'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: ExemplosUsoDialog.exemploOk,
              child: Text('Dialog OK'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: ExemplosUsoDialog.exemploLoading,
              child: Text('Dialog Loading'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: ExemplosUsoDialog.exemploInput,
              child: Text('Dialog Input'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: ExemplosUsoDialog.exemploSelecao,
              child: Text('Dialog Seleção'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: ExemplosUsoDialog.exemploCustomizado,
              child: Text('Dialog Customizado'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: ExemplosUsoDialog.exemploInstancia,
              child: Text('Usando Instância'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: ExemplosUsoDialog.exemploTemaCustomizado,
              child: Text('Tema Customizado'),
            ),
          ],
        ),
      ),
    );
  }
}
