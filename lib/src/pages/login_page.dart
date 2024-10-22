import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homePage/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    );

    _rotationController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      resizeToAvoidBottomInset: false, // Ajuste realizado aquí
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/fondoVilaBN.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // Espacio superior del 30% de la pantalla
                SizedBox(height: MediaQuery.of(context).size.height * 0.18),

                // Hero con rotación
                Hero(
                  tag: 'logoHero',
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_rotationAnimation),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/VilaExplorer.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Título
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'VILA ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: 'Explorer',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'INICIAR SESIÓN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Campos de texto
                _buildTextField('Correo', false),
                const SizedBox(height: 20),
                _buildTextField('Contraseña', true),

                // Enlace de contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      '¿Has olvidado tu contraseña?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // Espacio desde el fondo del 10%
                //const SizedBox(height: 30),

                // Espacio superior del 30% de la pantalla
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),

                // Botones de registro y entrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 58, 58, 58),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'REGISTRO',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 155, 58, 51),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        // Navegamos a MyHomePage con animación de desvanecimiento
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              // Usamos FadeTransition para crear un efecto de desvanecimiento
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(seconds: 2), // Duración de la animación
                          ),
                        );
                      },
                      child: const Text(
                        'ENTRAR',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Icono de idioma con fondo blanco
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15), // Esquinas redondeadas
                    ),
                    padding: const EdgeInsets.all(8.0), // Espacio interno
                    child: Image.asset(
                      'assets/images/language.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, bool isPassword) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
