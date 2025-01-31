import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/contacto.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/editar_perfil.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/preguntas_frecuentes.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/privacidad.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/terminos_condiciones.dart';
import 'package:vilaexplorer/src/pages/login_page.dart';

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

 void _showRedirectConfirmation(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('redirect_warning')),
          content: Text(AppLocalizations.of(context)!.translate('redirect_message')),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('cancel')),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('accept')),
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                // Redirige al enlace de la ciudad
                final url = Uri.parse('https://www.villajoyosa.com/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('Could not launch $url');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
        title: Container(
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
                              usuarioService.allUserData.nombre!,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              usuarioService.allUserData.email!,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditarPerfilPage()),
                        );
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
                SizedBox(height: 20.h),
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PreguntasFrecuentesPage()),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          '◦ ${AppLocalizations.of(context)!.translate('contact')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ContactoPage()),
                        );
                      },
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
                          '◦ ${AppLocalizations.of(context)!.translate('terms_conditions')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TerminosCondicionesPage()),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          '◦ ${AppLocalizations.of(context)!.translate('privacy_policy')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PrivacidadPage()),
                        );
                      },
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
                          '◦ ${AppLocalizations.of(context)!.translate('news')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _showRedirectConfirmation(context); // Llama a la función para mostrar el cuadro de diálogo
                      },
                    ),
                  ],
                ),


                const SizedBox(height: 70),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        usuarioService.cerrarSesion();
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              // Cambiar Offset a (-1.0, 0.0) para deslizar hacia la izquierda
                              const begin = Offset(-0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 99, 99),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.translate('signout'),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
