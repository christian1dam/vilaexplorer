import 'package:flutter/material.dart';

class CuentaPage extends StatefulWidget {
  final Function onClose;

  const CuentaPage({super.key, required this.onClose});

  @override
  _CuentaPageState createState() => _CuentaPageState();
}

class _CuentaPageState extends State<CuentaPage> {
  // Datos simulados del usuario. En la vida real, los cargarías de tu base de datos.
  String userName = "Juan Pérez";
  String userEmail = "juan.perez@email.com";
  String userPassword = "*****";  // La contraseña no se muestra por seguridad

  // Método que podría obtener los datos del usuario desde una base de datos
  Future<Map<String, String>> _loadUserData() async {
    // Aquí iría el código para cargar los datos del usuario desde la base de datos.
    await Future.delayed(const Duration(seconds: 2)); // Simula un delay de carga
    return {
      'name': userName,
      'email': userEmail,
      'password': userPassword,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
        title: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(30, 30, 30, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: const Text(
            "Cuenta",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            widget.onClose();  // Llamas al onClose aquí
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(32, 29, 29, 1),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User profile section
                Row(
                  children: [
                    // Icono de usuario
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.black),
                    ),
                    const SizedBox(width: 10),
                    // Nombre del usuario
                    FutureBuilder<Map<String, String>>(
                      future: _loadUserData(), // Carga los datos del usuario
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Muestra un loading
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        final data = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name']!,
                              style: const TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              data['email']!,
                              style: const TextStyle(fontSize: 16, color: Colors.white70),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Contraseña
                const Text(
                  "Contraseña:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  initialValue: userPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "******",
                    hintStyle: TextStyle(color: Colors.white54),
                    fillColor: Color.fromARGB(255, 47, 42, 42),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Botón de editar perfil
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para editar el perfil
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Editar Perfil", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),

                // Sección de apartados
                const Text(
                  "Ayuda",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                // Barra separadora corta
                Container(
                  width: 80, // Ancho fijo para el divider
                  child: const Divider(color: Colors.white),
                ),
                Column(
                  children: [
                    ListTile(
                      title: const Text("Preguntas frecuentes", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Acción para navegar a Preguntas frecuentes
                      },
                    ),
                    ListTile(
                      title: const Text("Ponte en contacto con nosotros", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Acción para navegar al contacto
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sección de ajustes
                const Text(
                  "Ajustes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                // Barra separadora corta
                Container(
                  width: 80, // Ancho fijo para el divider
                  child: const Divider(color: Colors.white),
                ),
                Column(
                  children: [
                    ListTile(
                      title: const Text("Idioma", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Acción para cambiar idioma
                      },
                    ),
                    ListTile(
                      title: const Text("Noticias", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Acción para mostrar noticias
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sección de más información
                const Text(
                  "Más Información",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                // Barra separadora corta
                Container(
                  width: 80, // Ancho fijo para el divider
                  child: const Divider(color: Colors.white),
                ),
                Column(
                  children: [
                    ListTile(
                      title: const Text("Términos y condiciones", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Acción para mostrar términos y condiciones
                      },
                    ),
                    ListTile(
                      title: const Text("Política de privacidad", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Acción para mostrar política de privacidad
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Barra separadora de versión corta
                Align(
  alignment: Alignment.center, // Esto asegura que se alinee al centro
  child: Container(
    width: 150, // Ancho fijo para el divider
    child: const Divider(color: Colors.white),
  ),
),


                // Versión de la app
                Center(
                  child: Text(
                    "Versión 1.0.0 (1)", // Aquí actualizas la versión de tu app
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
