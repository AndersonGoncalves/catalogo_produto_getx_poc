import 'package:flutter/material.dart';

class WidgetTextButton extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Function() onPressed;
  const WidgetTextButton(
    this.label, {
    this.backgroundColor,
    this.foregroundColor,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return backgroundColor;
          }
          return backgroundColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return foregroundColor;
          }
          return foregroundColor;
        }),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
