import 'package:flutter/material.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';

// Definimos constantes para los estilos de los botones y textos
const kButtonBackgroundColorSelected = Color.fromRGBO(32, 29, 29, 0.9);
const kButtonBackgroundColorUnselected = Color.fromRGBO(45, 45, 45, 1);
const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w300,
  fontSize: 18,
  decoration: TextDecoration.none,
);
const kIngredientesTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.none,
);
const kTituloTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Poppins',
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
      // Cierra el widget cuando se toca fuera de la zona activa
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
            onTap: () {}, // Evita que el toque en el contenedor interior cierre la página
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
                SizedBox(height: 10),
                _buildButtonRow(),
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

   void _changeLanguage(BuildContext context, Locale locale) {
    setState(() {
      MyApp.setLocale(context, locale);
    });
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleButton(AppLocalizations.of(context)!.translate('ingredients'), showIngredientes, () {
          setState(() {
            showIngredientes = true;
          });
        }),
        const SizedBox(width: 10),
        _buildToggleButton(AppLocalizations.of(context)!.translate('recipe'), !showIngredientes, () {
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
            ? kButtonBackgroundColorUnselected
            : kButtonBackgroundColorSelected,
        minimumSize: const Size(150, 50),
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
