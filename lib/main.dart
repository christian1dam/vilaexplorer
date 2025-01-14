import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/service/tipo_plato_service.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:vilaexplorer/providers/monumentos_provider.dart'; // Asegúrate de importar el MonumentosProvider
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Importa ScreenUtil
import 'src/pages/splash_page.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const AppState());
}

// Envolver MyApp con MultiProvider para inyectar los Providers
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioService(), lazy: false),
        ChangeNotifierProvider(create: (_) => TradicionesService(), lazy: false),
        ChangeNotifierProvider(create: (_) => GastronomiaService(), lazy: false),
        ChangeNotifierProvider(create: (_) => TipoPlatoService(), lazy: false),
        ChangeNotifierProvider(create: (_) => MonumentosProvider(), lazy: false), // Agrega MonumentosProvider aquí
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
    // Inicializa ScreenUtil
    return ScreenUtilInit(
      designSize: const Size(384, 857), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Vila Explorer',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: SplashPage(),
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
      },
    );
  }
}
