import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart'; 

class MyRecipesPage extends StatefulWidget {
  const MyRecipesPage({super.key});

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  Plato? _platoSeleccionado;  // Variable para almacenar el plato seleccionado

  @override
  void initState() {
    super.initState();
    // Obtener las recetas del usuario actual
    final gastronomiaService =
        Provider.of<GastronomiaService>(context, listen: false);
    gastronomiaService.fetchUserRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final gastronomiaService = Provider.of<GastronomiaService>(context);
    final platos = gastronomiaService.platos;
    final isLoading = gastronomiaService.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_platoSeleccionado != null ? _platoSeleccionado!.nombre : 'Mis Recetas'),
        backgroundColor: const Color.fromRGBO(32, 29, 29, 0.9),
        foregroundColor: const Color.fromRGBO(255, 255, 255, 0.898),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromRGBO(32, 29, 29, 0.9),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _platoSeleccionado == null
              ? platos == null || platos.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay recetas disponibles.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: platos.length,
                      itemBuilder: (context, index) {
                        final plato = platos[index];
                        return Card(
                          color: const Color.fromARGB(255, 47, 42, 42),
                          child: ListTile(
                            leading: FutureBuilder<Widget>(
                              future: gastronomiaService.getImageForPlato(
                                plato.imagenBase64,
                                plato.imagen,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  );
                                } else {
                                  return snapshot.data!;
                                }
                              },
                            ),
                            title: Text(
                              plato.nombre,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              plato.descripcion ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _platoSeleccionado = plato;  // Al seleccionar el plato, lo almacenamos
                                });
                              },
                            ),
                          ),
                        );
                      },
                    )
              : _buildEditForm(gastronomiaService), // Mostrar el formulario de edición
    );
  }

  // Método para construir el formulario de edición
  Widget _buildEditForm(GastronomiaService gastronomiaService) {
    final nombreController = TextEditingController(text: _platoSeleccionado!.nombre);
    final descripcionController = TextEditingController(text: _platoSeleccionado!.descripcion);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editar Plato',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nombreController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Nombre del Plato',
              labelStyle: TextStyle(color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descripcionController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Descripción',
              labelStyle: TextStyle(color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Guardar cambios (si es necesario)
                  setState(() {
                    _platoSeleccionado!.nombre = nombreController.text;
                    _platoSeleccionado!.descripcion = descripcionController.text;
                    // Llamar a un método de GastronomiaService si necesitas actualizar la receta en el servidor
                  });
                },
                child: const Text('Guardar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _platoSeleccionado = null;  // Volver al listado de recetas
                  });
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
