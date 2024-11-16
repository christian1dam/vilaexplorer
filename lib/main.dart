import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/providers/usuarios_provider.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        // ChangeNotifierProvider(create: (_) => TradicionesProvider(), lazy: false),
      ],
      child: const MyApp(),
    );
  }
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
