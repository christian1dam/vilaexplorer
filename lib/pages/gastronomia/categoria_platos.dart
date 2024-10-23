import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/gastronomia/detalle_platillo.dart';
import 'package:vilaexplorer/pages/homepage/map_view.dart'; // Importamos el mapa correctamente

const kContainerColor = Colors.white10;
const kBorderRadius = 15.0;
const kImageHeight = 150.0;
const kPadding = 10.0;
const kTitleTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
  fontSize: 24,
  decoration: TextDecoration.none,
);

class CategoriaPlatos extends StatelessWidget {
  final String category;  // Añadimos el argumento categoría como una variable final

  const CategoriaPlatos({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(  // Usamos Stack para mostrar el mapa en el fondo
      children: [
        const MapView(),  // Mostramos el mapa en el fondo
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          category,  // Ahora usamos directamente el argumento
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _buildPlatoCard(
                        context,
                        'Paella Valenciana',
                        'assets/images_gastronomia/paella-valenciana.jpg',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

    Widget _buildPlatoCard(BuildContext context, String name, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: GestureDetector(
        onTap: () {
          print('Navegando a /detalle_platillo con argumento: $name');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetallePlatillo(platillo: name),  // Pasamos el nombre del platillo como argumento
  ),
);
        },
        child: Container(
          decoration: BoxDecoration(
            color: kContainerColor,
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: Column(
            children: [
              _buildImage(imagePath),
              _buildTitle(name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: kImageHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTitle(String name) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Text(
        name,
        style: kTitleTextStyle,
      ),
    );
  }
}
