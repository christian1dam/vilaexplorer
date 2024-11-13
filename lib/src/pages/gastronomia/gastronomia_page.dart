import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';

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
  List<dynamic> categories = [];
  List<dynamic> allDishes = [];
  List<dynamic> displayedDishes = [];
  String? selectedCategory;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final String response = await rootBundle.loadString('assets/gastronomia.json');
    final data = json.decode(response);
    setState(() {
      categories = data['categories'];
      allDishes = categories.expand((category) => category['dishes']).toList();
      displayedDishes = List.from(allDishes); // Muestra todos los platos inicialmente
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

  void _filterByCategory(String? category) {
    setState(() {
      selectedCategory = category;
      if (category == null) {
        displayedDishes = List.from(allDishes); // Muestra todos los platos
      } else {
        final selectedCategoryObj = categories.firstWhere(
          (cat) => cat['name'] == category,
          orElse: () => null,
        );
        displayedDishes = selectedCategoryObj != null
            ? List.from(selectedCategoryObj['dishes'])
            : [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (isSearchActive) {
          setState(() {
            isSearchActive = false;
            searchController.clear();
          });
        } else {
          widget.onClose();  // Se ejecuta el cierre si se toca fuera
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
            onTap: () {}, // Evita que el toque en el contenedor interior cierre la página
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.search, 
                          color: Colors.white
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
                            AppLocalizations.of(context)!.translate('gastronomy'),
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
                        onPressed: widget.onClose, // Cierra la página
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
                        hintText: AppLocalizations.of(context)!.translate('search_recipe'),
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text(
                      'Filtrar',
                      style: const TextStyle(color: Colors.white),
                    ),
                    dropdownColor: const Color.fromARGB(255, 47, 42, 42),
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Filtrar', style: TextStyle(color: Colors.white54)),
                          ],
                        ),
                      ),
                      ...categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['name'],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category['name']),
                              if (selectedCategory == category['name'])
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () {
                                    _filterByCategory(null); // Quita el filtro
                                  },
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (String? newValue) {
                      _filterByCategory(newValue);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: displayedDishes.length,
                    itemBuilder: (context, index) {
                      final dish = displayedDishes[index];
                      return _buildDishItem(context, dish);
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

  Widget _buildDishItem(BuildContext context, dynamic dish) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
        ),
        onPressed: () {
          widget.onCategoriaPlatoSelected(dish['name']);
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                dish['image'], // Aquí usamos la imagen del platillo
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              dish['name'], // Nombre del platillo
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
