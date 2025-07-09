import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/ui/theme_extensions.dart';

class Messages {
  final BuildContext context;

  Messages._(this.context);

  factory Messages.of(BuildContext context) {
    return Messages._(context);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: backgroundColor, content: Text(message)),
    );
  }

  void _showSnackBarWithAction(
    String message,
    String action,
    Function() onPressed,
    Color backgroundColor,
  ) {
    Scaffold.of(context).openDrawer();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(message),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(label: action, onPressed: onPressed),
      ),
    );
  }

  void showError(String message) => _showSnackBar(message, Colors.red);

  void info(String message) => _showSnackBar(message, context.primaryColor);

  void infoWithAction(String message, String action, Function() onPressed) =>
      _showSnackBarWithAction(message, action, onPressed, context.primaryColor);
}
