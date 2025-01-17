import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';

class DetalleMonumentoPage extends StatelessWidget {
  final LugarDeInteres lugarDeInteres;

  const DetalleMonumentoPage({Key? key, required this.lugarDeInteres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.90,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(32, 29, 29, 0.9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Barra de estilo iOS
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: 100,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Título y botón de cerrar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              lugarDeInteres.nombreLugar ?? 'Nombre no disponible',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  // Imagen del monumento
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            lugarDeInteres.imagen ?? '', // Asegúrate de que la imagen no sea nula
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              // Si la imagen no se puede cargar, muestra una imagen de placeholder
                              return Image.asset('assets/no-image.jpg', fit: BoxFit.cover);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estado: ${lugarDeInteres.activo != null ? (lugarDeInteres.activo! ? "Abierto" : "Cerrado") : "Desconocido"}",
                                  style: const TextStyle(color: Colors.green, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  lugarDeInteres.descripcion ?? 'Descripción no disponible',
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Opinión de Turistas",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                               //Text(
                                  //lugarDeInteres.opinion ?? 'Opinión no disponible',
                                  //style: const TextStyle(color: Colors.white, fontSize: 16),
                                //),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // Aquí podrías implementar la lógica para obtener la ruta
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Obtener ruta', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}