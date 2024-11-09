import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'tarjetaFiestaTradicion.dart';

class TradicionesPage extends StatefulWidget {
  final Function(String) onFiestaSelected;
  final VoidCallback onClose;

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
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTradiciones();
  }

  Future<void> _loadTradiciones() async {
    final String response = await rootBundle.loadString('assets/tradiciones.json');
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

  void _toggleSearch() {
    setState(() {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        searchController.clear();
      }
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
                child: GestureDetector(
                  onTap: () {
                    if (isSearchActive) {
                      setState(() {
                        isSearchActive = false;
                        searchController.clear();
                      });
                    }
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
                              IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleSearch,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(30, 30, 30, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                margin: const EdgeInsets.only(top: 10, left: 10),
                                width: size.width * 0.5,
                                height: 35,
                                child: const Center(
                                  child: Text(
                                    'Fiestas & tradiciones',
                                    style: TextStyle(
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
                                onPressed: widget.onClose,
                              ),
                            ],
                          ),
                        ),
                        if (isSearchActive)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Buscar tradiciones o fiestas locales...',
                                hintStyle: TextStyle(color: Colors.white54),
                                fillColor: Color.fromARGB(255, 47, 42, 42),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              ),
                            ),
                          ),
                        if (isSearchActive)
                          const SizedBox(height: 10),
                        if (!isSearchActive)
                          Container(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            margin: const EdgeInsets.only(bottom: 10),
                            width: size.width - 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(36, 36, 36, 1),
                                borderRadius: BorderRadius.all(Radius.circular(20))),
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
              ),
            ],
          );
  }

  SizedBox MyBotonText(String texto) {
    return SizedBox(
      width: 117,
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            Color.fromRGBO(45, 45, 45, 1),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
