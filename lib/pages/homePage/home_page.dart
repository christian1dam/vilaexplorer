import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homePage/menu_principal.dart';
import 'app_bar_custom.dart';
import 'map_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showContainer = false;
  bool showTradicionesPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapView(),
          Positioned(
            top: 0, 
            left: 0,
            right: 0,
            child: AppBarCustom(onMenuPressed: _toggleContainer),
          ),
          if (showContainer)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MenuPrincipal(
                  onShowTradicionesPressed: _toggleTradicionesPage),
            ),
          if (showTradicionesPage)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container()),
        ],
      ),
    );
  }

  void _toggleTradicionesPage() {
    setState(() {
      _toggleContainer();
      showTradicionesPage = true;
    });
  }

  void _toggleContainer() {
    setState(() {
      showContainer = !showContainer;
      if(showTradicionesPage) showTradicionesPage = false;
    });
  }
}