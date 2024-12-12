import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';
import 'package:vilaexplorer/providers/login_form_provider.dart';
import 'package:vilaexplorer/src/pages/homePage/home_page.dart';
import 'package:vilaexplorer/src/pages/passwordRecover_page.dart';
import 'package:vilaexplorer/src/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _buttonAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              _buildLanguageOption('Español', 'assets/images/BanderaEspañola.png'),
              _buildLanguageOption('English', 'assets/images/BanderaInglaterra.png'),
              _buildLanguageOption('Valencià', 'assets/images/BanderaComunidadValenciana.png'),
              _buildLanguageOption('Chino', 'assets/images/BanderaChina.png'),
              _buildLanguageOption('Francés', 'assets/images/BanderaFrancia.png'),
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

  void _loginUser(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context, listen: false);

    if (loginFormProvider.validateForm()) {
      // Simula autenticación exitosa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso')),
      );
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete los campos correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      resizeToAvoidBottomInset: false,
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
            child: Form(
              key: loginFormProvider.formKey,
              child: Column(
                children: [
                  // Parte superior (Logo, título y campos de texto)
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  Hero(
                    tag: 'logoHero',
                    child: RotationTransition(
                      turns: Tween(begin: 1.0, end: 0.0).animate(_rotationAnimation),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.transparent,
                        backgroundImage: const AssetImage('assets/images/VilaExplorer.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Hero(
                    tag: 'textHero',
                    child: RichText(
                      text: const TextSpan(
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
                  const SizedBox(height: 10),
                  const Text(
                    'INICIAR SESIÓN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    AppLocalizations.of(context)!.translate('email'),
                    false,
                    (value) => loginFormProvider.email = value,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    AppLocalizations.of(context)!.translate('password'),
                    true,
                    (value) => loginFormProvider.password = value,
                  ),

                  // Texto "¿Has olvidado tu contraseña?" alineado a la derecha
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return const PasswordRecoverPage(); // Llamar a la nueva página
                        },
                      );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate('forgot_password'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Spacer para separar la parte superior de la inferior
                  const Spacer(),

                  // Parte inferior (Botones de login y registro)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 90.0),
                    child: SlideTransition(
                      position: _buttonAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 58, 58, 58),
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                          RegisterPage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    // Cambiar Offset a (-1.0, 0.0) para deslizar hacia la izquierda
                                    const begin = Offset(-1.0, 0.0);
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
                            child: Text(
                              AppLocalizations.of(context)!.translate('register'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          // Botón para mostrar opciones de idioma
                          Center(
                            child: IconButton(
                              icon: const Icon(Icons.language, color: Colors.white, size: 30),
                              onPressed: () {
                                _showLanguageOptions(context); // Abrir el modal de idiomas
                              },
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 155, 58, 51),
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                            onPressed: () => _loginUser(context),
                            child: Text(
                              AppLocalizations.of(context)!.translate('access'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, bool isPassword, Function(String) onChanged) {
    return TextFormField(
      onChanged: onChanged,
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
