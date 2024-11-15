import 'package:flutter/material.dart';

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
          child: const Text(
            "Crear Receta",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Nombre del Plato:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    nombrePlato = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Introduce el nombre del plato",
                  hintStyle: const TextStyle(color: Colors.white54),
                  fillColor: const Color.fromARGB(255, 47, 42, 42),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorText: _isFormSubmitted && (nombrePlato == null || nombrePlato!.isEmpty)
                      ? "Campo obligatorio"
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
                        hintText: "Categoría",
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: _isFormSubmitted && selectedCategory == null
                            ? "Campo obligatorio"
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
                        hintText: "Tipo",
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: _isFormSubmitted && selectedType == null
                            ? "Campo obligatorio"
                            : null,
                      ),
                      dropdownColor: const Color.fromRGBO(47, 42, 42, 1),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Ingredientes:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
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
                                        hintText: "Cantidad",
                                        hintStyle: const TextStyle(color: Colors.white54),
                                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        errorText: _isFormSubmitted && controllers['quantity']!.text.isEmpty
                                            ? "Campo obligatorio"
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
                                        hintText: "Unidad",
                                        hintStyle: const TextStyle(color: Colors.white54),
                                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        errorText: _isFormSubmitted && controllers['name']!.text.isEmpty
                                            ? "Campo obligatorio"
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
                                        hintText: "Ingrediente",
                                        hintStyle: const TextStyle(color: Colors.white54),
                                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        errorText: _isFormSubmitted && controllers['name']!.text.isEmpty
                                            ? "Campo obligatorio"
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
                          child: const Text(
                            "+ Agregar Ingrediente",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Descripción:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    descripcion = value;
                  });
                },
                maxLines: 6,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Describe los pasos para preparar la receta",
                  hintStyle: const TextStyle(color: Colors.white54),
                  fillColor: const Color.fromARGB(255, 47, 42, 42),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorText: _isFormSubmitted && (descripcion == null || descripcion!.isEmpty)
                      ? "Campo obligatorio"
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Receta:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    receta = value;
                  });
                },
                maxLines: ingredientControllers.isEmpty ? 12 : 6,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Describe la receta aquí",
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Receta guardada con éxito"),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Guardar",
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
