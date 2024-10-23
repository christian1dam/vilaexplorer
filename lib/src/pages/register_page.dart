import 'package:flutter/material.dart';
import '../../pages/homePage/home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  bool _isKeyboardVisible = false; // Estado para verificar si el teclado está visible

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
    // Detectar si el teclado está visible
    _isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      resizeToAvoidBottomInset: true, // Ajustar el contenido al teclado
      body: Stack(
        children: [
          // Imagen de fondo
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
            child: SingleChildScrollView( // Mantener SingleChildScrollView
              child: Column(
                children: [
                  // Espacio superior del 30% de la pantalla
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),

                  // Hero con rotación y opacidad
                  AnimatedOpacity(
                    opacity: _isKeyboardVisible ? 0.0 : 1.0, // Cambiar opacidad según la visibilidad del teclado
                    duration: const Duration(milliseconds: 300), // Duración de la animación
                    child: Hero(
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
                    'REGISTRARSE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campos de texto
                  _buildTextField('Nombre', false),
                  const SizedBox(height: 20),
                  _buildTextField('Correo', false),
                  const SizedBox(height: 20),
                  _buildTextField('Contraseña', true),
                  const SizedBox(height: 20),
                  _buildTextField('Confirmar Contraseña', true),

                  // Espacio desde el fondo del 10%
                  const SizedBox(height: 20),

                  // Botones de registro y entrar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 58, 58, 58),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0); // Desde la izquierda
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        child: const Text(
                          'VOLVER',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      // Icono de idioma
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/language.png',
                          height: 30,
                          width: 30,
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 136, 55, 55),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0); // Desde la izquierda
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        child: const Text(
                          'ACCEDER',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
