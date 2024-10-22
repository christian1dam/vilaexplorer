import 'package:flutter/material.dart';
import 'package:vilaexplorer/routes/routes.dart';
import 'package:vilaexplorer/src/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la banda de "debug"
      title: 'Vila Explorer',
      //initialRoute: '/',
      //routes: getApplicationRoutes(),  // Si se descomentan estas dos líneas la App dice que home == null y no inicia
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
