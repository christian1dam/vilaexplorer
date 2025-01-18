import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';

class DetalleMonumentoPage extends StatelessWidget {
  final LugarDeInteres lugarDeInteres;
  const DetalleMonumentoPage({Key? key, required this.lugarDeInteres})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height:
                size.height * 0.50, // Cortamos el recuadro antes de los botones
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(32, 29, 29, 0.9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen con título y botón de cerrar superpuestos
                Stack(
                  children: [
                    // Imagen del monumento
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        lugarDeInteres.imagen ??
                            '', // Asegúrate de que la imagen no sea nula
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          // Imagen de placeholder en caso de error
                          return Image.asset('assets/no-image.jpg',
                              fit: BoxFit.cover);
                        },
                      ),
                    ),
                    // Gradiente y superposición para título y botón
                    Container(
                      height: 180, // Misma altura que la imagen
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Título en la esquina superior izquierda
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  lugarDeInteres.nombreLugar ??
                                      'Nombre no disponible',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            // Botón de cerrar en la esquina superior derecha
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Descripción y contenido
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lugarDeInteres.descripcion ??
                                'Descripción no disponible',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Opinión de Turistas",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Aquí se pueden agregar opiniones adicionales
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Botones flotantes debajo del recuadro
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Row(
            children: [
              // Botón de "Obtener ruta"
              Expanded(
                flex: 4, // 80% del espacio
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Lógica para obtener la ruta
                  },
                  child: const Text(
                    'Obtener ruta',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Botón de "Guardar"
              Expanded(
                flex: 1, // 20% del espacio
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Lógica para guardar
                    },
                    child: GestureDetector(
                      child:
                          const MySvgWidget(path: 'lib/icon/guardar_icon.svg'),
                      onTap: () => {},
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
