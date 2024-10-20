import 'package:flutter/material.dart';

class TradicionesPage extends StatelessWidget {
  const TradicionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter, // Alinea el contenedor al fondo
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.black12.withOpacity(0.7),
        ),
        height: MediaQuery.of(context).size.height *
            0.8, // 80% del alto de la página
      ),
    );
  }
}
