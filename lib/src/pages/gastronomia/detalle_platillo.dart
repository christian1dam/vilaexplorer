import 'package:flutter/material.dart';

// Definimos constantes para los estilos de los botones y textos
const kButtonBackgroundColorSelected = Colors.black87;
const kButtonBackgroundColorUnselected = Colors.grey;
const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
  fontSize: 18,
  decoration: TextDecoration.none,
);
const kIngredientesTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.none,
);
const kTituloTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w400,
  fontSize: 22,
  decoration: TextDecoration.none,
);

class DetallePlatillo extends StatefulWidget {
  final String platillo;
  final VoidCallback closeWidget;

  const DetallePlatillo({super.key, required this.platillo, required this.closeWidget});

  @override
  _DetallePlatilloState createState() => _DetallePlatilloState();
}

class _DetallePlatilloState extends State<DetallePlatillo> {
  bool showIngredientes = true;

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height *
            0.75, // Ajustamos la altura al 75%
        decoration: BoxDecoration(
          color: Colors.black
              .withOpacity(0.7), // Semi-transparente para dejar ver el mapa
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Encabezado con título centrado y flecha de regreso
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => widget.closeWidget(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.platillo,
                      style: kTituloTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            // Imagen del platillo con borde redondeado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    15), // Aplicamos radio de borde de 15
                child: Image.asset(
                  'assets/images_gastronomia/paella-valenciana.jpg',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _buildButtonRow(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  // Añadimos scroll en caso de contenido largo
                  child: showIngredientes
                      ? _buildIngredientes()
                      : _buildReceta(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleButton('Ingredientes', showIngredientes, () {
          setState(() {
            showIngredientes = true;
          });
        }),
        const SizedBox(width: 10),
        _buildToggleButton('Receta', !showIngredientes, () {
          setState(() {
            showIngredientes = false;
          });
        }),
      ],
    );
  }

  Widget _buildToggleButton(
      String text, bool isSelected, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? kButtonBackgroundColorSelected
            : kButtonBackgroundColorUnselected,
        minimumSize: const Size(150, 50), // Tamaño uniforme de los botones
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: kButtonTextStyle,
      ),
    );
  }

  Widget _buildIngredientes() {
    return Text(
      '1 taza de arroz\n2 muslos de pollo\n100g de judías verdes\nPimiento rojo\n...',
      style: kIngredientesTextStyle,
    );
  }

  Widget _buildReceta() {
    return Text(
      'En una paellera, sofríe el pollo con las verduras. Luego añade el arroz y cubre con caldo de pollo...',
      style: kIngredientesTextStyle,
    );
  }
}
