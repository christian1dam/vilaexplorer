import 'package:flutter/material.dart';
import 'src/pages/splash_page.dart';

void main() {
  runApp(const LaVilaExplorerApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la banda de "debug"
      title: 'Vila Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
