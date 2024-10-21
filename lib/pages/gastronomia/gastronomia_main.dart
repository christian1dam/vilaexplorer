import 'package:flutter/material.dart';

class GastronomiaMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, //Superposicion sobre el mapa
      appBar: AppBar(
        title: Text('Gastronomía'),
        backgroundColor:Colors.black.withOpacity(0.5),
      ),
      body: Column(
      children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar receta...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
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
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.black.withOpacity(0.7),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/categoriaPlatos', arguments: category);
        },
        child: Text(category, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}