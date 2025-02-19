import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';

class MyRecipesPage extends StatefulWidget {
  static const String route = 'RecetasUsuario';
  const MyRecipesPage({super.key});

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  Plato? _platoSeleccionado;
  Future<void>? _recetasDelUsuarioFuture;

  @override
  void initState() {
    super.initState();
    _recetasDelUsuarioFuture =
        Provider.of<GastronomiaService>(context, listen: false).fetchUserRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final gastronomiaService =
        Provider.of<GastronomiaService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(_platoSeleccionado != null
            ? _platoSeleccionado!.nombre
            : 'Mis Recetas'),
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
        foregroundColor: const Color.fromRGBO(255, 255, 255, 0.898),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      body: FutureBuilder(
        future: _recetasDelUsuarioFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final platos = gastronomiaService.platosUsuario;
            return _platoSeleccionado == null
                ? platos.isEmpty
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
                              leading: FadeInImage(
                                placeholder: AssetImage("assets/no-image.jpg"),
                                image: NetworkImage(plato.imagen!),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/no-image.jpg",
                                    height: 90,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              title: Text(
                                plato.nombre,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                plato.descripcion,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _platoSeleccionado = plato;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      )
                : _buildEditForm(gastronomiaService);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildEditForm(GastronomiaService gastronomiaService) {
    final nombreController =
        TextEditingController(text: _platoSeleccionado!.nombre);
    final descripcionController =
        TextEditingController(text: _platoSeleccionado!.descripcion);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                  setState(() {
                    _platoSeleccionado!.nombre = nombreController.text;
                    _platoSeleccionado!.descripcion = descripcionController.text;
                  });
                },
                child: const Text('Guardar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _platoSeleccionado = null;
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
