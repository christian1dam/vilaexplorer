import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/src/pages/gastronomia/addPlato.dart';

class GastronomiaPage extends StatefulWidget {
  final Function(String) onCategoriaPlatoSelected;
  final VoidCallback onClose;

  const GastronomiaPage({
    super.key,
    required this.onCategoriaPlatoSelected,
    required this.onClose,
  });

  @override
  _GastronomiaPageState createState() => _GastronomiaPageState();
}

class _GastronomiaPageState extends State<GastronomiaPage> {
  String? selectedCategory;
  String? selectedDishType;
  bool isSearchActive = false;
  bool isGridView = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<GastronomiaService>(context, listen: false).fetchAllPlatos();
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
    final gastronomiaService = Provider.of<GastronomiaService>(context);
    final size = MediaQuery.of(context).size;

    // Lógica para mostrar la pantalla de carga o los datos
    final isLoading = gastronomiaService.isLoading;
    final platos = gastronomiaService.platos;

    return GestureDetector(
      onTap: () {
        if (isSearchActive) {
          setState(() {
            isSearchActive = false;
            searchController.clear();
          });
        } else {
          widget.onClose();
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: size.height * 0.65,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(32, 29, 29, 0.9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: GestureDetector(
            onTap: () {},
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Column(
                    children: [
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
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.search, color: Colors.white),
                              onPressed: _toggleSearch,
                            ),
                            IconButton(
                              icon: Icon(
                                isGridView ? Icons.list : Icons.grid_on,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  isGridView = !isGridView;
                                });
                              },
                            ),
                            const SizedBox(width: 20),
                            Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              width: size.width * 0.4,
                              height: 35,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('gastronomy'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AddPlato(),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: widget.onClose,
                                ),
                              ],
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
                                  .translate('search_recipe'),
                              hintStyle: const TextStyle(color: Colors.white54),
                              fillColor: const Color.fromARGB(255, 47, 42, 42),
                              filled: true,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: platos == null
                            ? const Center(
                                child: Text(
                                  "No hay platos disponibles",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : isGridView
                                ? GridView.builder(
                                    padding: const EdgeInsets.all(8.0),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                    ),
                                    itemCount: platos!.length,
                                    itemBuilder: (context, index) {
                                      final plato = platos[index];
                                      final gastronomiaService =
                                          Provider.of<GastronomiaService>(
                                              context,
                                              listen: false);

                                      return Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: FutureBuilder<Widget>(
                                                future: gastronomiaService
                                                    .getImageForPlato(
                                                  plato.imagenBase64,
                                                  plato.imagen,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return const Icon(
                                                      Icons.broken_image,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    );
                                                  } else if (snapshot.hasData) {
                                                    return Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: (snapshot.data
                                                                  as Image)
                                                              .image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return const Icon(
                                                      Icons.image_not_supported,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                plato.nombre,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount: platos.length,
                                    itemBuilder: (context, index) {
                                      final plato = platos[index];
                                      final gastronomiaService =
                                          Provider.of<GastronomiaService>(
                                              context,
                                              listen: false);

                                      return Card(
                                        color: const Color.fromARGB(
                                            255, 47, 42, 42),
                                        child: ListTile(
                                          leading: FutureBuilder<Widget>(
                                            future: gastronomiaService
                                                .getImageForPlato(
                                                    plato.imagenBase64,
                                                    plato.imagen),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                  color: Colors.grey,
                                                );
                                              } else if (snapshot.hasData) {
                                                return snapshot.data!;
                                              } else {
                                                return const Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                  color: Colors.grey,
                                                );
                                              }
                                            },
                                          ),
                                          title: Text(
                                            plato.nombre,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
