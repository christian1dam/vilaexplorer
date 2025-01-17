import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:vilaexplorer/service/tipo_plato_service.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'src/pages/splash_page.dart';
import 'l10n/app_localizations.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const AppState());
}

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
        ChangeNotifierProvider(create: (_) => PageProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => LugarDeInteresService(), lazy: false),
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
  Locale _locale = const Locale('es');

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
            Locale('en'),
            Locale('es'),
            Locale('ca'),
            Locale('zh'),
            Locale('fr'),
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
            return supportedLocales.first;
          },
        );
      },
    );
  }
}
