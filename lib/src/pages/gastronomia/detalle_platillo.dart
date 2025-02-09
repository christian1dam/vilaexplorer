import 'package:flutter/material.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';

const kButtonBackgroundColorSelected = Color.fromRGBO(32, 29, 29, 0.9);
const kButtonBackgroundColorUnselected = Color.fromRGBO(45, 45, 45, 1);
const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w300,
  fontSize: 18,
  decoration: TextDecoration.none,
);
const kIngredientesTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.none,
);
const kTituloTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 22,
  decoration: TextDecoration.none,
);

class DetallePlatillo extends StatefulWidget {
  final String platillo;
  final String ingredientes;
  final String receta;
  final VoidCallback closeWidget;

  const DetallePlatillo({
    super.key,
    required this.platillo,
    required this.ingredientes,
    required this.receta,
    required this.closeWidget,
  });

  @override
  _DetallePlatilloState createState() => _DetallePlatilloState();
}

class _DetallePlatilloState extends State<DetallePlatillo> {
  bool showIngredientes = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        widget.closeWidget();
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: size.height * 0.65,
          width: size.width,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(32, 29, 29, 0.9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: GestureDetector(
            onTap: () {},
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images_gastronomia/paella-valenciana.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildButtonRow(size),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: showIngredientes
                          ? _buildIngredientes()
                          : _buildReceta(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(Size size) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    margin: const EdgeInsets.symmetric(horizontal: 14), // Más margen horizontal para extender
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 55, 55, 55),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildToggleButton(
          AppLocalizations.of(context)!.translate('ingredients'),
          showIngredientes,
          () {
            setState(() {
              showIngredientes = true;
            });
          },
        ),
        _buildToggleButton(
          AppLocalizations.of(context)!.translate('recipe'),
          !showIngredientes,
          () {
            setState(() {
              showIngredientes = false;
            });
          },
        ),
      ],
    ),
  );
}

Widget _buildToggleButton(String text, bool isSelected, VoidCallback onPressed) {
  return Expanded(
    child: GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Ajusta para un gris claro más corto
        margin: EdgeInsets.symmetric(horizontal: isSelected ? 5 : 0), // Márgenes más pequeños para el gris claro
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey[700]
              : const Color.fromARGB(255, 55, 55, 55),
          borderRadius: BorderRadius.circular(17),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: kButtonTextStyle,
        ),
      ),
    ),
  );
}


  Widget _buildIngredientes() {
    return Text(
      widget.ingredientes,
      style: kIngredientesTextStyle,
    );
  }

  Widget _buildReceta() {
    return Text(
      widget.receta,
      style: kIngredientesTextStyle,
    );
  }
}
