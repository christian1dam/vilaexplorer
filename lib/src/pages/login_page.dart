import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:vilaexplorer/src/pages/homePage/home_page.dart';
import 'package:vilaexplorer/src/pages/passwordRecover_page.dart';
import 'package:vilaexplorer/src/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Future<void>? _loginFuture;

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

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationController.forward();

    _loginFuture = null;
  }

  Future<void> _loginUser() async {
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    email.isEmpty || password.isEmpty
        ? ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor, ingrese todos los campos'),
              duration: Duration(milliseconds: 800),
            ),
          )
        : await usuarioService.loginUsuario(email, password);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Hero(
                  tag: 'logoHero',
                  child: RotationTransition(
                    turns:
                        Tween(begin: 1.0, end: 0.0).animate(_rotationAnimation),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/images/VilaExplorer.png'),
                    ),
                  ),
                ),
                Hero(
                  tag: 'textHero',
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
                SizedBox(height: 20.h),
                Text(
                  AppLocalizations.of(context)!.translate('login'),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildTextField(
                    AppLocalizations.of(context)!.translate('email'),
                    false,
                    _emailController),
                SizedBox(height: 20.h),
                _buildTextField(
                    AppLocalizations.of(context)!.translate('password'),
                    true,
                    _passwordController),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return const PasswordRecoverPage();
                        },
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('forgot_password'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0.0, 0.10),
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
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      RegisterPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                          AppLocalizations.of(context)!.translate('register'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.language, color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          _showLanguageOptions(context);
                        },
                      ),
                      FutureBuilder(
                          future: _loginFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    snapshot.error.toString(),
                                  ),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.done) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
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
                                    transitionDuration: const Duration(milliseconds: 100),
                                  ),
                                );
                              });
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 155, 58, 51),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                              onPressed: () {
                                setState(() {
                                  _loginFuture = _loginUser();
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('access'),
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
    return TextField(
      controller: controller,
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
