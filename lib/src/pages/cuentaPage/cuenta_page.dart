import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/contacto.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/editar_perfil.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/preguntas_frecuentes.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/privacidad.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/terminos_condiciones.dart';
import 'package:vilaexplorer/src/pages/login_page.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class CuentaPage extends StatefulWidget {
  static const String route = "cuentaPage";
  const CuentaPage({super.key});

  @override
  _CuentaPageState createState() => _CuentaPageState();
}

class _CuentaPageState extends State<CuentaPage> {
  final _userData = UserPreferences();
  late Future<void> _userDataFuture;
  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
  }

  Future<void> _loadUserData() async {
    await _userData.username;
    await _userData.email;
  }

  void _showLanguageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical:20.h),
          decoration: BoxDecoration(
            color: Colors.grey[850]?.withOpacity(0.8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
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
      leading: Image.asset(flagPath, height: 60.h, width: 60.w),
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
    final prefsProvider = Provider.of<UserPreferences>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
        title: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(30, 30, 30, 1),
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
          child: Text(
            AppLocalizations.of(context)!.translate('account'),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop()
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(32, 29, 29, 1),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal:16.w, vertical:16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User profile section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.person, size: 40.w, color: Colors.black),
                    ),
                    SizedBox(width: 10.w),
                    FutureBuilder(
                      future: _userDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Expanded(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prefsProvider.nombre,
                              style: TextStyle(
                                  fontSize: 20.sp, color: Colors.white),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              prefsProvider.correo,
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white70),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditarPerfilPage()),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 40.w),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
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
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 80.w,
                  child: const Divider(color: Colors.white),
                ),
                Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          AppLocalizations.of(context)!.translate('frequent_questions'),
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
                          AppLocalizations.of(context)!.translate('contact'),
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ContactoPage()),
                        );
                      },
                    ),

                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  AppLocalizations.of(context)!.translate('settings'),
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 80.w,
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
                SizedBox(height: 20.h),
                Text(
                  AppLocalizations.of(context)!.translate('more_information'),
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 80.w,
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
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200.w,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 250),
                            ),
                            (route) => false);
                        await UserPreferences().storage.deleteAll();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 99, 99),
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 40.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.translate('signout'),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment
                      .center, // Usa 'Alignment.center' en lugar de 'Center()'
                  child: SizedBox(
                    width: 150.w,
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
