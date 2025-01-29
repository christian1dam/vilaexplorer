import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:vilaexplorer/src/pages/login_page.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class CuentaPage extends StatefulWidget {
  const CuentaPage({super.key});

  @override
  _CuentaPageState createState() => _CuentaPageState();
}

class _CuentaPageState extends State<CuentaPage> {
  final _userData = UserPreferences();
  late Future<void> _userDataFuture;
  late String username;
  late String email;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
  }

  Future<void> _loadUserData() async {
    username = await _userData.username;
    email = await _userData.email;
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

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
    
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
              fontFamily: 'Poppins',
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            pageProvider.changePage('map');
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                              username,
                              style: TextStyle(
                                  fontSize: 20.sp, color: Colors.white),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              email,
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
                Text(
                  '${AppLocalizations.of(context)!.translate('password')}:',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 5.h),
                TextFormField(
                  initialValue: "*********",
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "******",
                    hintStyle: TextStyle(color: Colors.white54),
                    fillColor: Color.fromARGB(255, 47, 42, 42),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para editar el perfil
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
                          '◦ ${AppLocalizations.of(context)!.translate('news')}',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
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
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200.w,
                    child: ElevatedButton(
                      onPressed: () async {
                        pageProvider.clearScreen();
                        Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      LoginPage(),
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
                              transitionDuration:
                                  const Duration(milliseconds: 250),
                            ),
                            (route) => false);
                        await UserPreferences().storage.deleteAll();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 4.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: const Text("Cerrar sesión",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
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
