import 'package:flutter/material.dart';

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

    // Controlador para la rotación de la imagen
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2), // Duración de la rotación
      vsync: this,
    );

    // Definir la animación de rotación con curva de desaceleración
    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut, // Probar otra curva más suave
    );


    // Inicia la animación de rotación al entrar a la página
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
      backgroundColor: Colors.grey[850], // Fondo gris oscuro
      body: Stack(
        children: [
          // Imagen de fondo posicionada en la parte baja (imagen en blanco y negro)
          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.5, // Transparencia de la imagen
              child: Image.asset(
                'assets/images/fondoVilaBN.png', // Ajusta la ruta según tu imagen
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.3, // Ocupa el 30% de la pantalla
                width: double.infinity,
              ),
            ),
          ),
          // Contenido principal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero con rotación desacelerada durante la transición
                Hero(
                  tag: 'logoHero', // El tag debe coincidir con el de SplashPage
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_rotationAnimation),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/VilaExplorer.png'), // Imagen de logo
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Título y subtítulo
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

                // Campo de correo
                _buildTextField('Correo', false),
                const SizedBox(height: 20),

                // Campo de contraseña
                _buildTextField('Contraseña', true),
                const SizedBox(height: 10),

                // Enlace para recuperar la contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Aquí agregas tu lógica para recuperar la contraseña
                    },
                    child: const Text(
                      '¿Has olvidado tu contraseña?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botones de registro y entrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black26, // Color del botón de registro
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        // Navegar a la página de registro
                      },
                      child: const Text(
                        'REGISTRO',
                        style: TextStyle(color: Colors.white),
                        ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 155, 58, 51), // Color del botón de entrar
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        // Iniciar sesión
                      },
                      child: const Text(
                        'ENTRAR',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Icono pequeño en la parte inferior derecha
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/images/language.png',
                    height: 50,
                    width: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper para los campos de texto
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
