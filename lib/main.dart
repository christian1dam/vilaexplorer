import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/providers/map_state_provider.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/favorito_service.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:vilaexplorer/service/puntuacion_service.dart';
import 'package:vilaexplorer/service/tipo_plato_service.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/src/pages/homePage/home_page.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';
import 'src/pages/splash_page.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Configura el manejador de errores global
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exception}');
    debugPrint('StackTrace: ${details.stack}');
    // exit(1);
  };

  try {
    await FMTCObjectBoxBackend().initialise();
  } catch (error, stackTrace) {
    debugPrint('Error durante la inicialización: $error');
    debugPrint('StackTrace: $stackTrace');
    exit(1);
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
        ChangeNotifierProvider(create: (_) => UsuarioService(), lazy: false),
        ChangeNotifierProvider(
            create: (_) => TradicionesService(), lazy: false),
        ChangeNotifierProvider(
            create: (_) => GastronomiaService(), lazy: false),
        ChangeNotifierProvider(create: (_) => TipoPlatoService(), lazy: false),
        ChangeNotifierProvider(create: (_) => PageProvider(), lazy: false),
        ChangeNotifierProvider(
            create: (_) => LugarDeInteresService(), lazy: false),
        ChangeNotifierProvider(create: (_) => PuntuacionService(), lazy: false),
        ChangeNotifierProvider(create: (_) => FavoritoService(), lazy: false),
        ChangeNotifierProvider(create: (_) => MapStateProvider(), lazy: false),
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
    return await UserPreferences().sesion ? MyHomePage() : SplashPage();
  }
}


// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.black,
//         body: MyDraggableSheet(
//             child: Column(
//           children: [
//             BottomSheetDummyUI(),
//             BottomSheetDummyUI(),
//             BottomSheetDummyUI(),
//             BottomSheetDummyUI(),
//             BottomSheetDummyUI(),
//             BottomSheetDummyUI(),
//             BottomSheetDummyUI(),
//           ],
//         )),
//       ),
//     );
//   }
// }

// class BottomSheetDummyUI extends StatelessWidget {
//   const BottomSheetDummyUI({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Container(
//           padding: EdgeInsets.only(left: 30, right: 30),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15.0),
//                     child: Container(
//                       color: Colors.black12,
//                       height: 100,
//                       width: 100,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(15.0),
//                         child: Container(
//                           color: Colors.black12,
//                           height: 20,
//                           width: 240,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(15.0),
//                         child: Container(
//                           color: Colors.black12,
//                           height: 20,
//                           width: 180,
//                         ),
//                       ),
//                       SizedBox(height: 50),
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(height: 10),
//             ],
//           )),
//     );
//   }
// }

// class MyDraggableSheet extends StatefulWidget {
//   final Widget child;
//   const MyDraggableSheet({super.key, required this.child});

//   @override
//   State<MyDraggableSheet> createState() => _MyDraggableSheetState();
// }

// class _MyDraggableSheetState extends State<MyDraggableSheet> {
//   final sheet = GlobalKey();
//   final controller = DraggableScrollableController();

//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(onChanged);
//   }

//   void onChanged() {
//     final currentSize = controller.size;
//     if (currentSize <= 0.05) collapse();
//   }

//   void collapse() {
//     print("he etnrado en collapse;");
//     animateSheet(getSheet.snapSizes!.first);
//   }

//   void anchor() => animateSheet(getSheet.snapSizes!.last);

//   void expand() => animateSheet(getSheet.maxChildSize);

//   void hide() => animateSheet(getSheet.minChildSize);

//   void animateSheet(double size) {
//     controller.animateTo(
//       size,
//       duration: const Duration(milliseconds: 50),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }

//   DraggableScrollableSheet get getSheet =>
//       (sheet.currentWidget as DraggableScrollableSheet);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       return DraggableScrollableSheet(
//         key: sheet,
//         initialChildSize: 0.5,
//         maxChildSize: 0.95,
//         minChildSize: 0,
//         expand: true,
//         snap: true,
//         snapSizes: [
//           60 / constraints.maxHeight,
//           0.5,
//         ],
//         controller: controller,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return DecoratedBox(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.yellow,
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(22),
//                 topRight: Radius.circular(22),
//               ),
//             ),
//             child: CustomScrollView(
//               controller: scrollController,
//               slivers: [
//                 topButtonIndicator(),
//                 SliverToBoxAdapter(
//                   child: widget.child,
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }

//   SliverToBoxAdapter topButtonIndicator() {
//     return SliverToBoxAdapter(
//       child: Container(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//             Container(
//                 child: Center(
//                     child: Wrap(children: <Widget>[
//               Container(
//                   width: 100,
//                   margin: const EdgeInsets.only(top: 10, bottom: 10),
//                   height: 5,
//                   decoration: const BoxDecoration(
//                     color: Colors.black45,
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   )),
//             ]))),
//           ])),
//     );
//   }
// }
