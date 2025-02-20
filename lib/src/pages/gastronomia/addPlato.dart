import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/models/gastronomia/tipoPlato.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/service/tipo_plato_service.dart';
import 'package:vilaexplorer/src/widgets/product_image.dart';

class AddPlato extends StatefulWidget {
  static const String route = "AddPlato";
  const AddPlato({super.key});

  @override
  _AddPlatoState createState() => _AddPlatoState();
}

class _AddPlatoState extends State<AddPlato> {
  String? selectedType;
  String? nombrePlato;
  String? descripcion;
  String? receta;
  String? image;

  List<TipoPlato> types = [];

  List<Map<String, dynamic>> ingredientControllers = [];
  List<String> unitOptions = ['Tazas', 'Gramos', 'Litros', 'Piezas'];

  bool _isFormSubmitted =
      false; // Para controlar si se ha intentado enviar el formulario

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addIngredientRow();
      Provider.of<TipoPlatoService>(context, listen: false)
          .fetchTiposPlatoActivos();
    });
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
        selectedType != null &&
        descripcion != null &&
        descripcion!.isNotEmpty &&
        receta != null &&
        receta!.isNotEmpty &&
        ingredientsFilled;
  }


  @override
  Widget build(BuildContext context) {
    final tipoPlatoService = Provider.of<TipoPlatoService>(context);
    final platoService = Provider.of<GastronomiaService>(context);

    types = tipoPlatoService.tiposPlato ?? [];

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
          child: types.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ProductImage(
                          url: image,
                        ),
                        const SizedBox(height: 20),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: IconButton(
                            onPressed: () async {
                              await _pickImage(context);
                            },
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        width: 150,
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
                        hintText: AppLocalizations.of(context)!
                            .translate('insert_dish_name'),
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: _isFormSubmitted &&
                                (nombrePlato == null || nombrePlato!.isEmpty)
                            ? "*Campo obligatorio"
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedType,
                            onChanged: (value) {
                              setState(() {
                                selectedType = value;
                              });
                            },
                            items: types
                                .map((type) => DropdownMenuItem<String>(
                                      value: type.nombreTipo,
                                      child: Text(type.nombreTipo,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ))
                                .toList(),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .translate('type'),
                              hintStyle: const TextStyle(color: Colors.white54),
                              fillColor: const Color.fromARGB(255, 47, 42, 42),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorText:
                                  _isFormSubmitted && selectedType == null
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
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        width: 150,
                        child: const Divider(color: Colors.white),
                      ),
                    ),
                    Column(
                      children: [
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
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .translate('quantity'),
                                          hintStyle: const TextStyle(
                                              color: Colors.white54),
                                          fillColor: const Color.fromARGB(
                                              255, 47, 42, 42),
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          errorText: _isFormSubmitted &&
                                                  controllers['quantity']!
                                                      .text
                                                      .isEmpty
                                              ? "*Campo obligatorio"
                                              : null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        value: controllers['unit'],
                                        onChanged: (value) {
                                          setState(() {
                                            controllers['unit'] = value;
                                          });
                                        },
                                        items: unitOptions
                                            .map((unit) =>
                                                DropdownMenuItem<String>(
                                                  value: unit,
                                                  child: Text(unit,
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                ))
                                            .toList(),
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .translate('units'),
                                          hintStyle: const TextStyle(
                                              color: Colors.white54),
                                          fillColor: const Color.fromARGB(
                                              255, 47, 42, 42),
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          errorText: _isFormSubmitted &&
                                                  controllers['name']!
                                                      .text
                                                      .isEmpty
                                              ? "*Campo obligatorio"
                                              : null,
                                        ),
                                        dropdownColor:
                                            const Color.fromRGBO(47, 42, 42, 1),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: controllers['name'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .translate('ingredients'),
                                          hintStyle: const TextStyle(
                                              color: Colors.white54),
                                          fillColor: const Color.fromARGB(
                                              255, 47, 42, 42),
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          errorText: _isFormSubmitted &&
                                                  controllers['name']!
                                                      .text
                                                      .isEmpty
                                              ? "*Campo obligatorio"
                                              : null,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          color: Color.fromARGB(255, 182, 40, 41)),
                                      onPressed: () =>
                                          _removeIngredientRow(index),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                        if (ingredientControllers.length < 15)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: _addIngredientRow,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  backgroundColor: const Color.fromARGB(255, 44, 155, 48),
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
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        width: 150,
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
                        hintText: AppLocalizations.of(context)!
                            .translate('desc_text'),
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: _isFormSubmitted &&
                                (descripcion == null || descripcion!.isEmpty)
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
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        width: 150,
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
                        hintText: AppLocalizations.of(context)!
                            .translate('recipe_text'),
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: const Color.fromARGB(255, 47, 42, 42),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: _isFormSubmitted &&
                                (receta == null || receta!.isEmpty)
                            ? "Campo obligatorio"
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isFormSubmitted = true;
                          });

                          if (!_isFormValid()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Por favor, rellena todos los campos obligatorios.")),
                            );
                            return;
                          }

                          final ingredientesString =
                              ingredientControllers.map((ing) {
                            final quantity = ing['quantity']!.text;
                            final unit = ing['unit'];
                            final name = ing['name']!.text;
                            return "$quantity $unit de $name";
                          }).join(',');

                          late int tipoPlato;

                          for (var t in types) {
                            if (t.nombreTipo == selectedType) {
                              tipoPlato = t.idTipoPlato;
                            }
                          }

                          platoService.createPlato(
                              nombrePlato!,
                              tipoPlato,
                              ingredientesString,
                              descripcion!,
                              receta!,
                              image!);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
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

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar una foto'),
                onTap: () async {
                  final XFile? photo =
                      await picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    setState(() {
                      image = photo.path; // Guardar la ruta local de la foto
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar desde la galería'),
                onTap: () async {
                  final XFile? selectedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (selectedImage != null) {
                    setState(() {
                      image = selectedImage.path; // Guardar la ruta local
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
