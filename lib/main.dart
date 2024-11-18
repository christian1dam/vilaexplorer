import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/providers/gastronomia_provider.dart';
import 'package:vilaexplorer/providers/tradiciones_provider.dart';
import 'package:vilaexplorer/providers/usuarios_provider.dart';
import 'src/pages/splash_page.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const AppState());
}

// Envolver MyApp con MultiProvider para inyectar los Providers
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider(), lazy: false),
        ChangeNotifierProvider(
            create: (_) => TradicionesProvider(), lazy: false),
        ChangeNotifierProvider(
            create: (_) => GastronomiaProvider(), lazy: false),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  // Método estático para cambiar el idioma
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('es'); // Idioma por defecto

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vila Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashPage(),
      locale: _locale, // Define el idioma actual
      supportedLocales: const [
        Locale('en'), // Inglés
        Locale('es'), // Español
        Locale('ca'), // Valenciano
        Locale('zh'), // Chino
        Locale('fr'), // Francés
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Verifica si el idioma del sistema está soportado
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first; // Por defecto, selecciona el primero
      },
    );
  }
}