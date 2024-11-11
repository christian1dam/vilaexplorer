import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vilaexplorer/src/pages/homePage/home_page.dart';
import 'package:vilaexplorer/src/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _buttonAnimation;

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

    // Ahora inicializamos correctamente la animación de los botones
    _buttonAnimation = CurvedAnimation(
      parent: _rotationController, // Usamos el mismo AnimationController
      curve: Curves.easeInOut,  // Ajusta la curva como desees
    );

    _rotationController.forward();  // Inicia la animación de rotación
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
                  Hero(
                    tag: 'textHero', // Debe coincidir con el `tag` de LoginPage
                    child: RichText(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.10),

                  // Botones de registro y entrar
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 0.5), // Desplazar hacia arriba
                      end: Offset.zero,
                    ).animate(_buttonAnimation),
                    child: Row(
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
                                  // Cambiar Offset a (-1.0, 0.0) para deslizar hacia la izquierda
                                  const begin = Offset(-0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Text(
                            'VOLVER',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'lib/icon/language.svg',
                            height: 30,
                            width: 30,
                          )
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 155, 58, 51),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(seconds: 2),
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
                  ),
                  const SizedBox(height: 30),
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
        borderRadius: BorderRadius.circular(30), // El mismo radio que el TextField
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black26, // Fondo semitransparente
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
