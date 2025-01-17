import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/monumentos/monumento.dart'; // Importa la clase Monumentos
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart'; // Importa tu widget SVG si es necesario

class MonumentoCard extends StatelessWidget {
  final Monumentos monumento; // Cambiar para usar el modelo Monumento
  final VoidCallback detalleTap; // Callback

  const MonumentoCard({
    super.key,
    required this.monumento,
    required this.detalleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: detalleTap,
            child: Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: FadeInImage(
                      placeholder: AssetImage("assets/no-image.jpg"),
                      image: NetworkImage(monumento.imagen!), // Usar la URL de la imagen del monumento
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.7),
                        Color.fromRGBO(0, 0, 0, 0.0),
                      ],
                    ),
                  ),
                  child: Text(
                    monumento.nombreLugar!, // Usar el nombre del monumento
                    style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      monumento.fechaAlta as String, // Usar la fecha del monumento
                      style: const TextStyle(
                          color: Color.fromRGBO(224, 120, 62, 1),
                          fontSize: 16),
                    ),
                    GestureDetector(
                      child: const MySvgWidget(path: 'lib/icon/guardar_icon.svg'), // Tu widget SVG
                      onTap: () => {},
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
