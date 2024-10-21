import 'package:flutter/material.dart';
import 'package:vilaexplorer/routes/routes.dart';

void main() {
  runApp(const LaVilaExplorerApp());
}

class LaVilaExplorerApp extends StatelessWidget {
  const LaVilaExplorerApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings){
        print("Ruta llamada: ${settings.name}");
        return null; // or provide a valid Route<dynamic> if needed
      },
    );
  }
}
