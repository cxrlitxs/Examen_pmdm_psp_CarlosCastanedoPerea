import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ExamenCarlos.dart';
import 'firebase_options.dart';

void main() async {
  //Inicializar Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Arrancar la App
  ExamenCarlos examenCarlos = ExamenCarlos();
  runApp(examenCarlos);
}
