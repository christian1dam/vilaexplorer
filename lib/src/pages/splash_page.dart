import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login_page.dart'; // Adjust the path to where LoginPage is defined

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0.0;
  @override
  void initState() {
    super.initState();

    // // Espera 3 segundos y luego redirige a la LoginPage
    // Future.delayed(Duration(milliseconds: 1000), () {
    //   Navigator.pushReplacement(
    //     context,
    //     PageRouteBuilder(
    //       transitionDuration: Duration(milliseconds: 1500), // Duración de la transición
    //       pageBuilder: (_, __, ___) => const LoginPage(),
    //     ),
    //   );
    // });

    Future.delayed(Duration(milliseconds: 200), (){
      _opacity = 1.0;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _opacity = 0.0;
      });

      // Navegar después de que termine el fade-out
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 1500),
            pageBuilder: (_, __, ___) => const LoginPage(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      body: Stack(
        children: [
          // Imagen de fondo en la parte inferior

          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.6,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                opacity: _opacity,
                child: Image(
                  image: AssetImage(
                    'assets/images/fondoVilaBN.png',
                  ),
                  fit: BoxFit.cover,
                  height: 340.h,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          // Contenido principal en el centro de la pantalla
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero animación de translado (sin rotación aquí)
                AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                  opacity: _opacity,
                  child: Hero(
                    tag: 'logoHero', // El tag debe coincidir en ambas páginas
                    child: CircleAvatar(
                      radius: 100.r,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/images/VilaExplorer.png'),
                    ),
                  ),
                ),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
