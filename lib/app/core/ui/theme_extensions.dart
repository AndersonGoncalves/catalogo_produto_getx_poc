import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  Color get canvasColor => Theme.of(this).canvasColor;
}
