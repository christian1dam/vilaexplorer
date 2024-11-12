import 'package:flutter/material.dart';
import 'package:vilaexplorer/src/pages/favoritosPage/favorito_page.dart';

class FiestaCard extends StatelessWidget {
  final String nombre;
  final String fecha;
  final String imagen;
  final VoidCallback detalleTap; // Callback

  const FiestaCard({
    super.key,
    required this.nombre,
    required this.fecha,
    required this.imagen,
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
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(imagen, fit: BoxFit.cover),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
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
                    nombre,
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
                      fecha,
                      style: const TextStyle(
                          color: Color.fromRGBO(224, 120, 62, 1), fontSize: 16),
                    ),
                    GestureDetector(
                      child:
                          const MySvgWidget(path: 'lib/icon/guardar_icon.svg'),
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
