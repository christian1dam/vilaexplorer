import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DetalleFiestaTradicion extends StatefulWidget {
  final String fiestaName;

  const DetalleFiestaTradicion({super.key, required this.fiestaName});

  @override
  _DetalleFiestaTradicionState createState() => _DetalleFiestaTradicionState();
}

class _DetalleFiestaTradicionState extends State<DetalleFiestaTradicion> {
  List<Map<String, String>> detalleTradiciones = [];

  @override
  void initState() {
    super.initState();
    _loadDetallesTradiciones();
  }

  Future<void> _loadDetallesTradiciones() async {
    final String response =
        await rootBundle.loadString('assets/detalleTradiciones.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      detalleTradiciones =
          data.map((item) => Map<String, String>.from(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fiestaDetalles = detalleTradiciones
        .firstWhere((element) => element['nombre'] == widget.fiestaName);

    return detalleTradiciones.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              height: size.height * 0.6,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(15, 15, 15, 0.9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen y Título
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Image.asset(
                          fiestaDetalles['imagen']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 16,
                        child: Text(
                          "Fiesta de ${fiestaDetalles['nombre']}",
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Fecha de la fiesta
                  Text(
                    fiestaDetalles['fecha']!,
                    style: const TextStyle(
                      color: Color.fromRGBO(224, 120, 62, 1),
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Descripción
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          fiestaDetalles['descripcion']!,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                  // Botón Ver Más
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
