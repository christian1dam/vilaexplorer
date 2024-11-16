import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'tarjetaFiestaTradicion.dart';

class TradicionesPage extends StatefulWidget {
  final Function(String) onFiestaSelected;
  final VoidCallback onClose; // Añadido para gestionar el cierre

  const TradicionesPage({
    super.key,
    required this.onFiestaSelected,
    required this.onClose,
  });

  @override
  _TradicionesPageState createState() => _TradicionesPageState();
}

class _TradicionesPageState extends State<TradicionesPage> {
  List<Map<String, String>> tradiciones = [];
  String? selectedFiesta;

  @override
  void initState() {
    super.initState();
    _loadTradiciones();
  }

  Future<void> _loadTradiciones() async {
    final String response =
        await rootBundle.loadString('assets/tradiciones.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      tradiciones = data.map((item) => Map<String, String>.from(item)).toList();
    });
  }

  void _toggleContainer(String nombreFiesta) {
    setState(() {
      selectedFiesta = nombreFiesta;
      widget.onFiestaSelected(nombreFiesta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return tradiciones.isEmpty
        ? const Center(child: null)
        : Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: size.height * 0.75,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(30, 30, 30, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              width: size.width * 0.5,
                              height: 35,
                              child: const Center(
                                child: Text(
                                  'Fiestas y tradiciones',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed:
                                  widget.onClose, // Usa el callback para cerrar
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                        margin: const EdgeInsets.only(bottom: 10),
                        width: size.width - 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(36, 36, 36, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyBotonText("Todo"),
                            MyBotonText("Populares"),
                            MyBotonText("Cercanos")
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: tradiciones.length,
                          itemBuilder: (context, index) {
                            return FiestaCard(
                              nombre: tradiciones[index]['nombre']!,
                              fecha: tradiciones[index]['fecha']!,
                              imagen: tradiciones[index]['imagen']!,
                              detalleTap: () => _toggleContainer(
                                  tradiciones[index]['nombre']!),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  SizedBox MyBotonText(String texto) {
    return SizedBox(
        width: 117,
        child: TextButton(
          onPressed: () {},
          style: const ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Color.fromRGBO(45, 45, 45, 1))),
          child: Text(
            texto,
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
