import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                // Imagen circular en el centro (logo)
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/VilaExplorer.png'), // Imagen de logo
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
                          fontFamily: 'Poppins', // Asegúrate de haber añadido la fuente Poppins en tu proyecto
                        ),
                      ),
                      TextSpan(
                        text: 'Explorer',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w200, // Poppins ExtraLight es w200
                          color: Colors.white,
                          fontFamily: 'Poppins', // Asegúrate de haber añadido la fuente Poppins en tu proyecto
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
                        backgroundColor: Colors.black, // Color del botón de registro
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        // Navegar a la página de registro
                      },
                      child: const Text('REGISTRO'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Color del botón de entrar
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        // Iniciar sesión
                      },
                      child: const Text('ENTRAR'),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Icono pequeño en la parte inferior derecha
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/images/language.png', // Ajusta la ruta según tu imagen
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
