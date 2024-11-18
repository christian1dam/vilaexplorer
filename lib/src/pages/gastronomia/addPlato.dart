import 'package:flutter/material.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';

class AddPlato extends StatefulWidget {
  const AddPlato({super.key});

  @override
  _AddPlatoState createState() => _AddPlatoState();
}

class _AddPlatoState extends State<AddPlato> {
  String? selectedCategory;
  String? selectedType;
  String? nombrePlato;
  String? descripcion;
  String? receta;

  List<String> categories = ['Entrante', 'Principal', 'Postre'];
  Map<String, List<String>> typesByCategory = {
    'Entrante': ['Ensalada', 'Sopa', 'Otros'],
    'Principal': ['Carne', 'Pescado', 'Vegetariano'],
    'Postre': ['Helado', 'Pastel', 'Fruta']
  };

  List<Map<String, dynamic>> ingredientControllers = [];
  List<String> unitOptions = ['Tazas', 'Gramos', 'Litros', 'Piezas'];

  bool _isFormSubmitted = false; // Para controlar si se ha intentado enviar el formulario

  @override
  void initState() {
    super.initState();
    _addIngredientRow();
  }

  void _addIngredientRow() {
    setState(() {
      ingredientControllers.add({
        'quantity': TextEditingController(),
        'unit': unitOptions[0],
        'name': TextEditingController(),
      });
    });
  }

  void _removeIngredientRow(int index) {
    setState(() {
      ingredientControllers[index]['quantity']!.dispose();
      ingredientControllers[index]['name']!.dispose();
      ingredientControllers.removeAt(index);
    });
  }

  bool _isFormValid() {
    bool ingredientsFilled = ingredientControllers.isNotEmpty &&
        ingredientControllers.any((ingredient) {
          return ingredient['quantity']!.text.isNotEmpty &&
              ingredient['name']!.text.isNotEmpty;
        });

    return nombrePlato != null &&
        nombrePlato!.isNotEmpty &&
        selectedCategory != null &&
        selectedType != null &&
        descripcion != null &&
        descripcion!.isNotEmpty &&
        receta != null &&
        receta!.isNotEmpty &&
        ingredientsFilled;
  }

  void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Impide que el pop-up se cierre al tocar fuera de él
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500), // Duración de la animación
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 350,
                height: 350, // Aumenta el alto del contenedor para evitar overflow
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(32, 29, 29, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Image.asset(
      'assets/images/sending.gif',
      width: 250,
      height: 250,
    ),
    const SizedBox(height: 20),
    Flexible(
      child: Text(
        AppLocalizations.of(context)!.translate('sending'),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    ),
  ],
),

              ),
            ),
          );
        },
      );
    },
  );

  // Cierra el diálogo después de 3 segundos (simula que el proceso se completó)
  Future.delayed(const Duration(seconds: 3), () {
    Navigator.of(context).pop(); // Cierra el diálogo después de 3 segundos
  });
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
        title: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(30, 30, 30, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            AppLocalizations.of(context)!.translate('new_dish'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(32, 29, 29, 1),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate('dish_name'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5), // Ajusta el valor según necesites
                child: SizedBox(
                  width: 150, // Ancho fijo para el divider
                  child: const Divider(color: Colors.white),
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    nombrePlato = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.translate('insert_dish_name'),
                  hintStyle: const TextStyle(color: Colors.white54),
                  fillColor: const Color.fromARGB(255, 47, 42, 42),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorText: _isFormSubmitted && (nombrePlato == null || nombrePlato!.isEmpty)
                      ? "*Campo obligatorio"
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          selectedType = null; // Reseteamos el tipo
                        });
                      },
                      items: categories
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category, style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.translate('category'),
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: _isFormSubmitted && selectedCategory == null
                            ? "*Campo obligatorio"
                            : null,
                      ),
                      dropdownColor: const Color.fromRGBO(47, 42, 42, 1),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      onChanged: selectedCategory == null
                          ? null
                          : (value) {
                              setState(() {
                                selectedType = value;
                              });
                            },
                      items: (selectedCategory != null
                              ? typesByCategory[selectedCategory]!
                              : [])
                          .map((type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(type, style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.translate('type'),
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: _isFormSubmitted && selectedType == null
                            ? "*Campo obligatorio"
                            : null,
                      ),
                      dropdownColor: const Color.fromRGBO(47, 42, 42, 1),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate('ingredients'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5), // Ajusta el valor según necesites
                child: SizedBox(
                  width: 150, // Ancho fijo para el divider
                  child: const Divider(color: Colors.white),
                ),
              ),
              Column(
                children: [
                  // Mostrar los ingredientes ya añadidos
                  ...ingredientControllers.asMap().entries.map(
                        (entry) {
                          final index = entry.key;
                          final controllers = entry.value;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controllers['quantity'],
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.translate('quantity'),
                                        hintStyle: const TextStyle(color: Colors.white54),
                                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        errorText: _isFormSubmitted && controllers['quantity']!.text.isEmpty
                                            ? "*Campo obligatorio"
                                            : null,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: controllers['unit'],
                                      onChanged: (value) {
                                        setState(() {
                                          controllers['unit'] = value;
                                        });
                                      },
                                      items: unitOptions
                                          .map((unit) => DropdownMenuItem<String>(
                                                value: unit,
                                                child: Text(unit, style: const TextStyle(color: Colors.white)),
                                              ))
                                          .toList(),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.translate('units'),
                                        hintStyle: const TextStyle(color: Colors.white54),
                                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        errorText: _isFormSubmitted && controllers['name']!.text.isEmpty
                                            ? "*Campo obligatorio"
                                            : null,
                                      ),
                                      dropdownColor: const Color.fromRGBO(47, 42, 42, 1),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: controllers['name'],
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.translate('ingredients'),
                                        hintStyle: const TextStyle(color: Colors.white54),
                                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        errorText: _isFormSubmitted && controllers['name']!.text.isEmpty
                                            ? "*Campo obligatorio"
                                            : null,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () => _removeIngredientRow(index),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                  // Agregar el botón "+" solo si hay menos de 10 ingredientes
                  if (ingredientControllers.length < 15)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: _addIngredientRow,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "+ ${AppLocalizations.of(context)!.translate('add_ingredient')}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate('description'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5), // Ajusta el valor según necesites
                child: SizedBox(
                  width: 150, // Ancho fijo para el divider
                  child: const Divider(color: Colors.white),
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    descripcion = value;
                  });
                },
                maxLines: 6,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.translate('desc_text'),
                  hintStyle: const TextStyle(color: Colors.white54),
                  fillColor: const Color.fromARGB(255, 47, 42, 42),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorText: _isFormSubmitted && (descripcion == null || descripcion!.isEmpty)
                      ? "*Campo obligatorio"
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate('recipe'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5), // Ajusta el valor según necesites
                child: SizedBox(
                  width: 150, // Ancho fijo para el divider
                  child: const Divider(color: Colors.white),
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    receta = value;
                  });
                },
                maxLines: ingredientControllers.isEmpty ? 12 : 6,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.translate('recipe_text'),
                  hintStyle: const TextStyle(color: Colors.white54),
                  fillColor: const Color.fromARGB(255, 47, 42, 42),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorText: _isFormSubmitted && (receta == null || receta!.isEmpty)
                      ? "Campo obligatorio"
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isFormSubmitted = true;
                    });

                    if (_isFormValid()) {
                      // Mostrar el pop-up de éxito
                      _showSuccessDialog(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('send'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            
          ),
        ),
      ),
    );
  }
}
