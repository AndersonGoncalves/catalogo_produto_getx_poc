import 'package:flutter/material.dart';

class WidgetLoadingPage extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? labelColor;
  const WidgetLoadingPage({
    required this.label,
    this.backgroundColor,
    this.labelColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // RefreshProgressIndicator(
              //   backgroundColor: backgroundColor ?? Colors.white,
              // ),
              CircularProgressIndicator(
                backgroundColor: backgroundColor ?? Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: labelColor ?? Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
