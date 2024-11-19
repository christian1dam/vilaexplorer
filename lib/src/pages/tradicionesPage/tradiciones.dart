import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';
import 'package:vilaexplorer/providers/tradiciones_provider.dart';
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
  String? selectedFiesta;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Llamar a fetchAllTradiciones cuando se inicia la página
    Future.microtask(() {
      Provider.of<TradicionesProvider>(context, listen: false).fetchAllTradiciones();
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

    return Consumer<TradicionesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Text(
              provider.error!,
              style: const TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        }

        final tradiciones = provider.todasLasTradiciones;

        if (tradiciones == null || tradiciones.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron tradiciones.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Stack(
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
                              width: size.width * 0.7,
                              height: 35,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('holidays_traditions'),
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
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .translate('search_traditions'),
                              hintStyle: TextStyle(color: Colors.white54),
                              fillColor: Color.fromARGB(255, 47, 42, 42),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            ),
                          ),
                        ),
                      if (isSearchActive) const SizedBox(height: 10),
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
                              MyBotonText(AppLocalizations.of(context)!
                                  .translate('all')),
                              MyBotonText(AppLocalizations.of(context)!
                                  .translate('popular')),
                              MyBotonText(AppLocalizations.of(context)!
                                  .translate('nearby')),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: tradiciones.length,
                          itemBuilder: (context, index) {
                            final tradicion = tradiciones[index];
                            return FiestaCard(
                              nombre: tradicion.nombre,
                              fecha: tradicion.fecha,
                              imagen:  tradicion.getImagen(),
                              detalleTap: () => _toggleContainer(tradicion.nombre),
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
      },
    );
  }

  //Necesario para hacer las traducciones
  void _changeLanguage(BuildContext context, Locale locale) {
    setState(() {
      MyApp.setLocale(context, locale);
    });
  }

  SizedBox MyBotonText(String texto) {
    return SizedBox(
      width: 117,
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
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