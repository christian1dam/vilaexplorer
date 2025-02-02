import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/providers/edit_profile_provider.dart';
import 'package:vilaexplorer/providers/map_state_provider.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/favorito_service.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:vilaexplorer/service/puntuacion_service.dart';
import 'package:vilaexplorer/service/tipo_plato_service.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/src/pages/homePage/home_page.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';
import 'src/pages/splash_page.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exception}');
    debugPrint('StackTrace: ${details.stack}');
  };

  try {
    await FMTCObjectBoxBackend().initialise();
  } catch (error, stackTrace) {
    debugPrint('Error durante la inicialización: $error');
    debugPrint('StackTrace: $stackTrace');
  }

  await FMTCStore('VilaExplorerMapStore').manage.create();

  runApp(AppState());
}

class AppState extends StatelessWidget {
  const AppState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TradicionesService(), lazy: false),
        ChangeNotifierProvider(create: (_) => GastronomiaService(), lazy: false),
        ChangeNotifierProvider(create: (_) => TipoPlatoService(), lazy: false),
        ChangeNotifierProvider(create: (_) => PageProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => LugarDeInteresService(), lazy: false),
        ChangeNotifierProvider(create: (_) => PuntuacionService(), lazy: false),
        ChangeNotifierProvider(create: (_) => FavoritoService(), lazy: false),
        ChangeNotifierProvider(create: (_) => MapStateProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => EditProfileFormProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => UserPreferences(), lazy: false),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('es');
  late Future<Widget> _splashOrHomeFuture;

  @override
  void initState() {
    super.initState();
    _splashOrHomeFuture = _checkEstadoSesion();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _splashOrHomeFuture,
      builder: (context, snapshot) {
        return ScreenUtilInit(
          designSize: const Size(384, 857),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Vila Explorer',
              theme: ThemeData(primarySwatch: Colors.blue),
              home: snapshot.data,
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
    );
  }

  Future<Widget> _checkEstadoSesion() async {
    // bool sesion = ;
    debugPrint("ESTADO DE LA SESION DEL USUARIO: ${await UserPreferences().sesion}");
    return await UserPreferences().sesion ? MyHomePage() : SplashPage();
  }
}