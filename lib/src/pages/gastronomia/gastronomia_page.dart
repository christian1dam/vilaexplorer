import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/providers/gastronomia_provider.dart';
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
  // List<dynamic> categories = [];
  // List<dynamic> allDishes = [];
  // List<dynamic> displayedDishes = [];
  String? selectedCategory;
  String? selectedDishType;
  bool isSearchActive = false;
  bool isGridView =
      false; // Variable para alternar entre vista de lista y cuadrícula
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<GastronomiaProvider>(context, listen: false).fetchAllPlatos();
    });
    // _loadCategories();
  }

  // Future<void> _loadCategories() async {
  //   final String response = await rootBundle.loadString('assets/gastronomia.json');
  //   final data = json.decode(response);
  //   setState(() {
  //     categories = data['categories'];
  //     allDishes = categories.expand((category) => category['dishes']).toList();
  //     displayedDishes = List.from(allDishes);
  //   });
  // }

  void _toggleSearch() {
    setState(() {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        searchController.clear();
      }
    });
  }

  // void _filterByCategory(String? category) {
  //   setState(() {
  //     selectedCategory = category;
  //     if (category == null) {
  //       displayedDishes = List.from(allDishes);
  //       selectedDishType = null;
  //     } else {
  //       final selectedCategoryObj = categories.firstWhere(
  //         (cat) => cat['name'] == category,
  //         orElse: () => null,
  //       );
  //       displayedDishes = selectedCategoryObj != null
  //           ? List.from(selectedCategoryObj['dishes'])
  //           : [];
  //       selectedDishType = null;
  //     }
  //   });
  // }

  // void _filterByDishType(String? dishType) {
  //   setState(() {
  //     selectedDishType = dishType;
  //     if (dishType == null) {
  //       displayedDishes = categories
  //           .firstWhere((category) => category['name'] == selectedCategory)
  //           ['dishes'];
  //     } else {
  //       displayedDishes = categories
  //           .firstWhere((category) => category['name'] == selectedCategory)
  //           ['dishes']
  //           .where((item) => item['dish_type'] == dishType)
  //           .toList();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final gastronomiaProvider = Provider.of<GastronomiaProvider>(context);
    final size = MediaQuery.of(context).size;

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
            child: Column(
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
                    // Asegura que los elementos estén espaciados
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: _toggleSearch,
                      ),
                      // Botón para cambiar entre vista de lista y cuadrícula
                      IconButton(
                        icon: Icon(
                          isGridView
                              ? Icons.list
                              : Icons.grid_on, // Alternar el icono
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isGridView = !isGridView; // Alternar la vista
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(30, 30, 30, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        width: size.width *
                            0.4, // Reducido para dejar espacio para los botones
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
                      Spacer(),
                      Row(
                        children: [
                          // Botón para añadir receta
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPlato(),
                                ),
                              );
                            },
                          ),
                          // Botón para volver atrás
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text(
                      AppLocalizations.of(context)!.translate('filter'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    dropdownColor: const Color.fromARGB(255, 47, 42, 42),
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    isExpanded: true,
                    icon: selectedCategory == null
                        ? const Icon(Icons.arrow_drop_down, color: Colors.white)
                        : GestureDetector(
                            onTap: () {
                              // _filterByCategory(null);
                            },
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          AppLocalizations.of(context)!.translate('filter'),
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      // ...categories.map((category) {
                      //   return DropdownMenuItem<String>(
                      //     value: category['name'],
                      //     child: Text(category['name']),
                      //   );
                      // }),
                    ],
                    onChanged: (String? newValue) {
                      // _filterByCategory(newValue);
                    },
                  ),
                ),
                if (selectedCategory != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DropdownButton<String>(
                      value: selectedDishType,
                      hint: Text(
                        AppLocalizations.of(context)!.translate('type'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      dropdownColor: const Color.fromARGB(255, 47, 42, 42),
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.white,
                      isExpanded: true,
                      icon: selectedDishType == null
                          ? const Icon(Icons.arrow_drop_down,
                              color: Colors.white)
                          : GestureDetector(
                              onTap: () {
                                // _filterByDishType(null);
                              },
                              child:
                                  const Icon(Icons.close, color: Colors.white),
                            ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                              AppLocalizations.of(context)!.translate('type'),
                              style: TextStyle(color: Colors.white54)),
                        ),
                        // ...{
                        // //   for (var dish in categories
                        // //       .firstWhere((category) => category['name'] == selectedCategory)['dishes'])
                        // //     dish['dish_type']
                        // // }.map((dishType) {
                        // //   return DropdownMenuItem<String>(
                        // //     value: dishType,
                        // //     child: Text(dishType),
                        // //   );
                        // }
                        // ),
                      ],
                      onChanged: (String? newValue) {
                        // _filterByDishType(newValue);
                      },
                    ),
                  ),
                Expanded(
                  child: isGridView // Cambiar entre vista de lista y cuadrícula
                      ? GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: gastronomiaProvider.platos!.length,
                          itemBuilder: (context, index) {
                            final plato = gastronomiaProvider.platos![index];
                            return Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.memory(
                                      base64Decode(plato.imagenBase64),
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                          itemCount: gastronomiaProvider.platos!.length,
                          itemBuilder: (context, index) {
                            final plato = gastronomiaProvider.platos![index];
                            return Card(
                              color: const Color.fromARGB(255, 47, 42, 42),
                              child: ListTile(
                                leading: Image.memory(
                                  base64Decode(plato.imagenBase64),
                                  width: 50, // Ajuste del ancho
                                  height: 50, // Ajuste de la altura
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                                title: Text(
                                  plato.nombre,
                                  style: const TextStyle(color: Colors.white),
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