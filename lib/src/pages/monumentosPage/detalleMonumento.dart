import 'package:flutter/material.dart';

class DetalleMonumentoPage extends StatelessWidget {
  final String nombre;
  final VoidCallback onClose;

  const DetalleMonumentoPage({super.key, required this.nombre, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Monumento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Aquí puedes agregar más detalles del monumento, como su descripción, ubicación, etc.
            Text(
              'Descripción del monumento: Este es un monumento histórico ubicado en ...',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
