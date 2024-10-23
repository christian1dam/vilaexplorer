import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/gastronomia/categoria_platos.dart';

class GastronomiaMain extends StatelessWidget {
  const GastronomiaMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
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
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar receta...',
                    hintStyle: const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
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
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: const Color.fromARGB(255, 80, 79, 79).withOpacity(0.5),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoriaPlatos(category: category),  // Cambiamos la navegación para pasar directamente la categoría
            ),
          );
        },
        child: Text(
          category,
          style: const TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'Roboto', fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
