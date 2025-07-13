import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Messages {
  Messages._();

  static void _showSnackBar(String message, Color backgroundColor) {
    Get.snackbar(
      '',
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  static void _showSnackBarWithAction(
    String message,
    String action,
    Function() onPressed,
    Color backgroundColor,
  ) {
    Get.snackbar(
      '',
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(10),
      borderRadius: 8,
      duration: Duration(seconds: 3),
      mainButton: TextButton(
        onPressed: onPressed,
        child: Text(action, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  static void showError(String message) => _showSnackBar(message, Colors.red);

  static void info(String message) =>
      _showSnackBar(message, Get.theme.primaryColor);

  static void infoWithAction(
    String message,
    String action,
    Function() onPressed,
  ) => _showSnackBarWithAction(
    message,
    action,
    onPressed,
    Get.theme.primaryColor,
  );
}
