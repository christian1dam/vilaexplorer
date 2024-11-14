import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/src/pages/gastronomia/detalle_platillo.dart';

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
  String? selectedDishType;  // Cambiamos selectedDish a selectedDishType
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
        selectedDishType = null; // Restablece el tipo de plato seleccionado
      } else {
        final selectedCategoryObj = categories.firstWhere(
          (cat) => cat['name'] == category,
          orElse: () => null,
        );
        displayedDishes = selectedCategoryObj != null
            ? List.from(selectedCategoryObj['dishes'])
            : [];
        selectedDishType = null; // Restablece el tipo de plato seleccionado al cambiar la categoría
      }
    });
  }

  void _filterByDishType(String? dishType) {
    setState(() {
      selectedDishType = dishType;
      if (dishType == null) {
        // Muestra todos los platos de la categoría actual si no hay tipo seleccionado
        displayedDishes = categories
            .firstWhere((category) => category['name'] == selectedCategory)
            ['dishes'];
      } else {
        // Filtra los platos por `dish_type`
        displayedDishes = categories
            .firstWhere((category) => category['name'] == selectedCategory)
            ['dishes']
            .where((item) => item['dish_type'] == dishType)
            .toList();
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
                    AppLocalizations.of(context)!.translate('filter'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  dropdownColor: const Color.fromARGB(255, 47, 42, 42),
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white,
                  isExpanded: true,
                  // Cambia el icono entre la flecha y la "X" si hay una categoría seleccionada
                  icon: selectedCategory == null
                      ? const Icon(Icons.arrow_drop_down, color: Colors.white)
                      : GestureDetector(
                          onTap: () {
                            // Restablece el filtro de categoría al presionar la "X"
                            _filterByCategory(null);
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
                          ...categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category['name'],
                              child: Text(category['name']),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? newValue) {
                          _filterByCategory(newValue);
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
                      // Cambia el icono entre la flecha y la "X" si hay un tipo seleccionado
                      icon: selectedDishType == null
                          ? const Icon(Icons.arrow_drop_down, color: Colors.white)
                          : GestureDetector(
                              onTap: () {
                                // Restablece el filtro de tipo de plato al presionar la "X"
                                _filterByDishType(null);
                              },
                              child: const Icon(Icons.close, color: Colors.white),
                            ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(AppLocalizations.of(context)!.translate('type'), style: TextStyle(color: Colors.white54)),
                        ),
                        ...{
                          for (var dish in categories
                              .firstWhere((category) => category['name'] == selectedCategory)['dishes'])
                            dish['dish_type']
                        }.map((dishType) {
                          return DropdownMenuItem<String>(
                            value: dishType,
                            child: Text(dishType),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? newValue) {
                        _filterByDishType(newValue);
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
        padding: const EdgeInsets.symmetric(vertical: 10), // Ajustamos el padding
        backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallePlatillo(
              platillo: dish['name'],
              ingredientes: dish['ingredients'],
              receta: dish['recipe'],
              closeWidget: widget.onClose,
            ),
          ),
        );
      },
      child: Row(
        children: [
          // Imagen del plato
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              dish['image'],
              width: 50, // Ajusta el tamaño de la imagen según lo que necesites
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10), // Espacio entre imagen y texto
          // Nombre del plato
          Expanded(
            child: Text(
              dish['name'],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );
}

}
