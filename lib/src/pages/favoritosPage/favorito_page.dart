import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(39, 39, 39, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Cambiado a blanco
          onPressed: () {
            Navigator.of(context).pop(); // Vuelve a la página anterior
          },
        ),
        title: const Text(
          'Favoritos',
          style: TextStyle(color: Colors.white), // Cambiado el color del texto
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white), // Cambiado a blanco
            onPressed: () {
              // Acción para favoritos si es necesario
            },
          ),
          const SizedBox(width: 8), // Espacio entre iconos si es necesario
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(32, 29, 29, 0.9),
        ),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            // Buscador en la parte superior
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(39, 39, 39, 1).withOpacity(0.92),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                      child: SizedBox(
                        height: 40,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 1),
                              icon: const Padding(
                                padding: EdgeInsets.only(top: 7, left: 20, bottom: 5),
                                child: SizedBox(
                                  width: 35,
                                  child: MySvgWidget(
                                    path: "lib/icon/lupa.svg",
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
                              hintText: 'Buscar un lugar, restaurante o tradicción...',
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(239, 239, 239, 0.8),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(39, 39, 39, 1).withOpacity(0.92),
                            ),
                            cursorColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 5, color: Colors.transparent),

            // Listas desplegables para los favoritos
            Expanded(
              child: ListView(
                children: [
                  // Primera lista desplegable
                  ExpansionTile(
                    title: const Text(
                      'Lugares',
                      style: TextStyle(color: Colors.white),
                    ),
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    children: const [
                      ListTile(
                        title: Text(
                          'Lugar 1',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Lugar 2',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Lugar 3',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  // Segunda lista desplegable
                  /*
                  ExpansionTile(
                    title: const Text(
                      'Gastronomía',
                      style: TextStyle(color: Colors.white),
                    ),
                    children: const [
                      ListTile(
                        title: Text(
                          'Restaurante 1',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Restaurante 2',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Restaurante 3',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  */

                  // Tercera lista desplegable
                  /*
                  ExpansionTile(
                    title: const Text(
                      'Tradiciones',
                      style: TextStyle(color: Colors.white),
                    ),
                    children: const [
                      ListTile(
                        title: Text(
                          'Tradicion 1',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Tradicion 2',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Tradicion 3',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de SVG personalizado para el buscador
class MySvgWidget extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;

  const MySvgWidget({
    super.key,
    required this.path,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path, height: height, width: width);
  }
}
