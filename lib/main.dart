import 'package:flutter/material.dart';
import 'app/core/ui/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:catalogo_produto_poc/app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(AppWidget());
}
