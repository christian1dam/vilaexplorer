import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DetalleFiestaTradicion extends StatefulWidget {
  final String fiestaName;
  final VoidCallback onClose; // Añadido para gestionar el cierre

  const DetalleFiestaTradicion(
      {super.key, required this.fiestaName, required this.onClose});

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

    if (detalleTradiciones.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final fiestaDetalles = detalleTradiciones
        .firstWhere((element) => element['nombre'] == widget.fiestaName);

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
                  child: Image.asset(
                    fiestaDetalles['imagen']!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 500,
                    padding: EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
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
                      "Fiesta de ${fiestaDetalles['nombre']}",
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
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      color: Color.fromRGBO(15, 15, 15, 0.9),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: widget.onClose,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              fiestaDetalles['fecha']!,
              style: const TextStyle(
                color: Color.fromRGBO(224, 120, 62, 1),
                fontSize: 21,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    fiestaDetalles['descripcion']!,
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
