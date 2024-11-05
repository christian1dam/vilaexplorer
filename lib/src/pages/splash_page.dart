import 'package:flutter/material.dart';

import 'login_page.dart'; // Adjust the path to where LoginPage is defined

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Espera 3 segundos y luego redirige a la LoginPage
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2), // Duración de la transición
          pageBuilder: (_, __, ___) => const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850], // Fondo gris oscuro
      body: Stack(
        children: [
          // Imagen de fondo en la parte inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/fondoVilaBN.png',
                fit: BoxFit.cover, // Cambia a BoxFit.cover
                height: MediaQuery.of(context).size.height * 0.4, // Ajusta la altura si es necesario
                width: double.infinity,
              ),
            ),
          ),

          // Contenido principal en el centro de la pantalla
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero animación de translado (sin rotación aquí)
                Hero(
                  tag: 'logoHero', // El tag debe coincidir en ambas páginas
                  child: CircleAvatar(
                    radius: 100, // Tamaño de la imagen circular
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/VilaExplorer.png'), // La imagen circular del logo
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
