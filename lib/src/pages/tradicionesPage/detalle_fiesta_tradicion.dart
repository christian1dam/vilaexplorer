import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';

class DetalleFiestaTradicion extends StatelessWidget {
  final String fiestaName;

  const DetalleFiestaTradicion({super.key, required this.fiestaName});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
    final tradicionesService = Provider.of<TradicionesService>(context, listen: false);
    final Tradiciones tradicion = tradicionesService.todasLasTradiciones!.firstWhere((element) => element.nombre == fiestaName);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width,
        height: size.height * 0.6,
        padding: const EdgeInsets.all(16),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    tradicion.imagen,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180.h,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            20), // Redondeamos la esquina superior izquierda
                        topRight: Radius.circular(
                            20), // Redondeamos la esquina superior derecha
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.7),
                          Color.fromRGBO(0, 0, 0, 0.0),
                        ],
                      ),
                    ),
                    child: Text(
                      tradicion.nombre,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10, // Mover la flecha hacia la derecha
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      color: Color.fromRGBO(15, 15, 15, 0.9),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white), // Flecha hacia atrás
                      onPressed: () {
                        pageProvider.changePage('tradiciones');
                      }
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              tradicion.fecha,
              style: TextStyle(
                color: Color.fromRGBO(224, 120, 62, 1),
                fontSize: 21.sp,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    tradicion.descripcion,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Lógica para ver más detalles de la fiesta
                },
                child: const Text(
                  "VER MÁS",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
