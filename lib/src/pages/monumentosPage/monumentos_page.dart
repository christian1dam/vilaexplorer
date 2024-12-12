import 'package:flutter/material.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';

class MonumentosPage extends StatelessWidget {
  final Function onClose;

  const MonumentosPage({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // Acción al tocar fuera del contenido
              onClose();
            },
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(30, 30, 30, 1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          width: size.width * 0.5,
                          height: 35,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate('sights'),
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
                          onPressed: () {
                            onClose();
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/maintenance.png', // Ruta de la imagen
                        width: 150, // Ajusta el tamaño según sea necesario
                        height: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}