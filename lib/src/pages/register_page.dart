import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';
import 'package:vilaexplorer/providers/usuarios_provider.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:vilaexplorer/src/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _buttonAnimation;

  // Controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
      curve: Curves.easeInOut, // Ajusta la curva como desees
    );

    _rotationController.forward(); // Inicia la animación de rotación
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _registerUser(BuildContext context) async {
    final usuarioSerivce = Provider.of<UsuarioService>(context, listen: false);

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    try {
      if (await usuarioSerivce.signupUsuario(
          name, email, password, confirmPassword)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado exitosamente')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return;
    }
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
              opacity: 0.3,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                // Hero con rotación
                Hero(
                  tag: 'logoHero',
                  child: RotationTransition(
                    turns:
                        Tween(begin: 0.0, end: 1.0).animate(_rotationAnimation),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/images/VilaExplorer.png'),
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
                Text(
                  AppLocalizations.of(context)!.translate('do_register'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Campos de texto
                _buildTextField(AppLocalizations.of(context)!.translate('name'),
                    false, _nameController),
                const SizedBox(height: 20),
                _buildTextField(
                    AppLocalizations.of(context)!.translate('email'),
                    false,
                    _emailController),
                const SizedBox(height: 20),
                _buildTextField(
                    AppLocalizations.of(context)!.translate('password'),
                    true,
                    _passwordController),
                const SizedBox(height: 20),
                _buildTextField(
                    AppLocalizations.of(context)!.translate('confirm_password'),
                    true,
                    _confirmPasswordController),

                // Espacio desde el fondo del 10%
                SizedBox(height: MediaQuery.of(context).size.height * 0.10),

                Spacer(),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
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
                        child: Text(
                          AppLocalizations.of(context)!.translate('return'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      // Botón de idioma
                      IconButton(
                        icon: const Icon(Icons.language, color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          _showLanguageOptions(context);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 155, 58, 51),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          _registerUser(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate('access'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildTextField(
      String label, bool isPassword, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(30), // El mismo radio que el TextField
      ),
      child: TextField(
        controller: controller,
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