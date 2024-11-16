import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homePage/home_page.dart';
import 'package:vilaexplorer/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
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
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  // Botones de registro y entrar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 58, 58, 58),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 136, 55, 55),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
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
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5), // Sombra blanca
            blurRadius: 10, // Desenfoque
            offset: Offset(0, 4), // Desplazamiento horizontal y vertical de la sombra
          ),
        ],
        borderRadius: BorderRadius.circular(30), // El mismo radio que el TextField
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Color.fromARGB(255, 65, 65, 65), // Fondo semitransparente
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
