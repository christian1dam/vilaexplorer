import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homepage/map_view.dart'; // Importamos el mapa correctamente

// Definimos constantes para los valores repetidos
// para mejorar la legibilidad y mantenibilidad del codigo
const kContainerColor = Colors.white10;  // Usamos white10 en lugar de withOpacity(0.1) para mejor legibilidad
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
  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context)!.settings.arguments as String;

    return Stack(  // Usamos Stack para mostrar el mapa en el fondo (de otra forma no se vera)
      children: [
        MapView(),  // Mostramos el mapa en el fondo
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,  // Ajustamos la altura al 75% para dejar el mapa visible
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),  // Fondo semi-transparente
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Encabezado con Stack para centrar el titulo correctamente
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
                        alignment: Alignment.center,  // Centramos el titulo
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 22,  // Aumentamos el tamano de la fuente
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,  // Simulacion de datos de platos
                    itemBuilder: (context, index) {
                      return _buildPlatoCard(
                        context, 
                        'Paella Valenciana', 
                        'assets/images_gastronomia/paella-valenciana.jpg'
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

  // Metodo para construir la tarjeta del plato
  Widget _buildPlatoCard(BuildContext context, String name, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: GestureDetector(  // Usamos GestureDetector para manejar el clic
        onTap: () {
          Navigator.pushNamed(context, '/detallePlatillo', arguments: name);  // Navegamos hacia la pantalla de detalle del platillo
        },
        child: Container(
          decoration: BoxDecoration(
            color: kContainerColor,  // Color semi-transparente
            borderRadius: BorderRadius.circular(kBorderRadius),  // Bordes redondeados
          ),
          child: Column(  // Formato vertical
            children: [
              _buildImage(imagePath),  // Imagen del platillo
              _buildTitle(name),  // Titulo del platillo
            ],
          ),
        ),
      ),
    );
  }

  // Metodo para construir la imagen del platillo
  Widget _buildImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),  // Borde redondeado para la imagen
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: kImageHeight,
        fit: BoxFit.cover,  // La imagen se ajusta al ancho del contenedor
      ),
    );
  }

  // Metodo para construir el titulo del platillo
  Widget _buildTitle(String name) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Text(
        name,
        style: kTitleTextStyle,  // Aplicamos el estilo de texto definido en las constantes
      ),
    );
  }
}
