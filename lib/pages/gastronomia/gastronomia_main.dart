import 'package:flutter/material.dart';

class GastronomiaMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      backgroundColor: Colors.transparent, // Fondo transparente para que el mapa sea visible
      body: Align(
        alignment: Alignment.bottomCenter, // Alineamos al fondo de la pantalla
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,  // Ajustamos la altura al 75%
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),  // Semi-transparente
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar receta...',
                    hintStyle: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontWeight: FontWeight.w300),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),  // Fondo del buscador
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildCategoryButton(context, 'Arroces Secos'),
                    _buildCategoryButton(context, 'Arroces Melosos'),
                    _buildCategoryButton(context, 'Tapas Típicas'),
                    _buildCategoryButton(context, 'Postres'),
                    _buildCategoryButton(context, 'Helados'),
                    _buildCategoryButton(context, 'Bebidas'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20),
          backgroundColor: const Color.fromARGB(255, 80, 79, 79).withOpacity(0.5),  // Semi-transparente
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/categoriaPlatos', arguments: category);
        },
        child: Text(category, style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'Roboto', fontWeight: FontWeight.w300)),  // Letra blanca Roboto Light
      ),
    );
  }
}
