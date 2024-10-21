import 'package:flutter/material.dart';

class CategoriaPlatos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.black.withOpacity(0.7),
      ),
      body: ListView.builder(
        itemCount: 5, // Simulación de datos de platos
        itemBuilder: (context, index) {
          return _buildPlatoCard(context, 'Paella Valenciana', 'assets/paella.jpg');
        },
      ),
    );
  }

  Widget _buildPlatoCard(BuildContext context, String name, String imagePath) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(imagePath, width: 50, height: 50),
        title: Text(name),
        onTap: () {
          Navigator.pushNamed(context, '/detallePlatillo', arguments: name);
        },
      ),
    );
  }
}
