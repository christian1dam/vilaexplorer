import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';
import 'package:vilaexplorer/providers/usuarios_provider.dart';

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
  String userPassword = "*****"; // La contraseña no se muestra por seguridad

  // Método que podría obtener los datos del usuario desde una base de datos
  Future<Map<String, String>> _loadUserData() async {
    // Aquí iría el código para cargar los datos del usuario desde la base de datos.
    await Future.delayed(
        const Duration(seconds: 2)); // Simula un delay de carga
    return {
      'name': userName,
      'email': userEmail,
      'password': userPassword,
    };
  }

  // Función para mostrar las opciones de idioma
  void _showLanguageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[850]?.withOpacity(0.8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                  'Español', 'assets/images/BanderaEspañola.png'),
              _buildLanguageOption(
                  'English', 'assets/images/BanderaInglaterra.png'),
              _buildLanguageOption(
                  'Valencià', 'assets/images/BanderaComunidadValenciana.png'),
              _buildLanguageOption('Chino', 'assets/images/BanderaChina.png'),
              _buildLanguageOption(
                  'Francés', 'assets/images/BanderaFrancia.png'),
            ],
          ),
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    setState(() {
      MyApp.setLocale(context, locale);
    });
  }

  // Widget para mostrar una opción de idioma con la bandera
  Widget _buildLanguageOption(String language, String flagPath) {
    return ListTile(
      onTap: () {
        Locale newLocale;
        if (language == 'Español') {
          newLocale = Locale('es');
        } else if (language == 'English') {
          newLocale = Locale('en');
        } else if (language == 'Chino') {
          newLocale = Locale('zh');
        } else if (language == 'Francés') {
          newLocale = Locale('fr');
        } else {
          newLocale = Locale('ca'); // Valenciano
        }
        _changeLanguage(context, newLocale);
        Navigator.pop(context);
      },
      leading: Image.asset(flagPath, height: 60, width: 60),
      title: Text(language, style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final usuario = usuarioProvider.usuarioAutenticado;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
        title: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(30, 30, 30, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            AppLocalizations.of(context)!.translate('account'),
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
            widget.onClose(); // Llamas al onClose aquí
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(32, 29, 29, 1),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User profile section
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.black),
                    ),
                    const SizedBox(width: 10),
                    FutureBuilder<Map<String, String>>(
                      future: _loadUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              usuario!.nombre,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              usuario.email,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '${AppLocalizations.of(context)!.translate('password')}:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  initialValue: usuario!.password,
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
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para editar el perfil
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 40),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                        AppLocalizations.of(context)!.translate('edit_profile'),
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.translate('help'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 80,
                  child: const Divider(color: Colors.white),
                ),
                Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          '◦ ${AppLocalizations.of(context)!.translate('frequent_questions')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          '◦ ${AppLocalizations.of(context)!.translate('contact')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.translate('settings'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 80,
                  child: const Divider(color: Colors.white),
                ),
                Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          '◦ ${AppLocalizations.of(context)!.translate('language')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _showLanguageOptions(
                            context); // Llama a la función para cambiar idioma
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          '◦ ${AppLocalizations.of(context)!.translate('news')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.translate('more_information'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 80,
                  child: const Divider(color: Colors.white),
                ),
                Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          '◦ ${AppLocalizations.of(context)!.translate('terms_conditions')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          '◦ ${AppLocalizations.of(context)!.translate('privacy_policy')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        usuarioProvider.cerrarSesion();
                        widget.onClose();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Cerrar sesión",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment
                      .center, // Usa 'Alignment.center' en lugar de 'Center()'
                  child: SizedBox(
                    width: 150,
                    child: const Divider(color: Colors.white),
                  ),
                ),
                // Versión de la app
                Center(
                  child: Text(
                    "${AppLocalizations.of(context)!.translate('version')} 1.0.0 (1)", // Aquí actualizas la versión de tu app
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
