import 'package:flutter/material.dart';

class DetallePlatillo extends StatefulWidget {
  @override
  _DetallePlatilloState createState() => _DetallePlatilloState();
}

class _DetallePlatilloState extends State<DetallePlatillo> {
  bool showIngredientes = true;

  @override
  Widget build(BuildContext context) {
    final String platillo = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(platillo),
        backgroundColor: Colors.black.withOpacity(0.7),
      ),
      body: Column(
        children: [
          Image.asset('assets/paella.jpg', height: 200, fit: BoxFit.cover),
          Expanded(
            child: Column(
              children: [
                _buildToggleButton('Ingredientes', showIngredientes, () {
                  setState(() {
                    showIngredientes = true;
                  });
                }),
                _buildToggleButton('Receta', !showIngredientes, () {
                  setState(() {
                    showIngredientes = false;
                  });
                }),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: showIngredientes ? _buildIngredientes() : _buildReceta(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.black.withOpacity(0.7) : Colors.grey,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Widget _buildIngredientes() {
    return Text(
      '1 taza de arroz\n2 muslos de pollo\n100g de judías verdes\nPimiento rojo\n...',
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildReceta() {
    return Text(
      'En una paellera, sofríe el pollo con las verduras. Luego añade el arroz y cubre con caldo de pollo...',
      style: TextStyle(fontSize: 16),
    );
  }
}
