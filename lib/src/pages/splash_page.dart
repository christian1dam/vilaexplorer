import 'package:flutter/material.dart';
import 'package:pruebas_vila_explorer/src/pages/login_page.dart';

class SplashPage extends StatefulWidget {
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
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
              opacity: 0.5, // Controla la transparencia de la imagen
              child: Image.asset(
                'assets/images/fondoVilaBN.png', // Asegúrate de tener la ruta correcta
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.3, // Ocupa el 30% de la pantalla
                width: double.infinity,
              ),
            ),
          ),
          // Contenido principal en el centro de la pantalla
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen circular en el centro
                CircleAvatar(
                  radius: 100, // Tamaño de la imagen circular
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/VilaExplorer.png'), // La imagen circular del logo
                ),
                const SizedBox(height: 20), // Espacio entre la imagen circular y cualquier texto adicional
              ],
            ),
          ),
        ],
      ),
    );
  }
}
