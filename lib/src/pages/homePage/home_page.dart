import 'package:flutter/material.dart';
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
          // if (showTradicionesPage)
          //   const Positioned(
          //     top: 0,
          //     left: 0, 
          //     right: 0,
          //     bottom: 0,
          //     child: TradicionesPage()),
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

class MenuPrincipal extends StatelessWidget {
  final Function()? onShowTradicionesPressed;
  final Function()? onShowGastronomiaPressed;

  const MenuPrincipal({
    super.key,
    this.onShowTradicionesPressed,
    this.onShowGastronomiaPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        color: const Color.fromARGB(255, 27, 27, 27).withOpacity(0.7),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child:
                    _crearBoton("Gastronomia", "lib/icon/gastronomia.png", 0.7),
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.topRight,
              child: _crearBoton(
                  "tradiciones", "lib/icon/tradiciones_icon.png", 1),
            ))
          ],
        ));
  }

  SizedBox _crearBoton(String texto, String imagePath, double tamanoTexto) {
    return SizedBox(
      width: 130,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: ElevatedButton(
          style: ButtonStyle(
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            backgroundColor:
                WidgetStateProperty.all<Color>(Colors.black54.withOpacity(0.3)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0))),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 25, width: 25),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      texto,
                      textScaler: TextScaler.linear(tamanoTexto),
                    )),
              ),
            ],
          ),
          onPressed: () {
            if (texto == "tradiciones" && onShowTradicionesPressed != null) {
              onShowTradicionesPressed!();
            } else if (texto == "gastronomia" && onShowGastronomiaPressed != null) {
              onShowGastronomiaPressed!();
            }
          },
        ),
      ),
    );
  }
}
