import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/src/pages/gastronomia/addPlato.dart';
import 'package:vilaexplorer/src/pages/gastronomia/detalle_platillo.dart';
import 'package:vilaexplorer/src/pages/gastronomia/myRecipesPage.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';

class GastronomiaPage extends StatefulWidget {
  final Function(String) onCategoriaPlatoSelected;

  const GastronomiaPage({
    super.key,
    required this.onCategoriaPlatoSelected,
  });

  @override
  _GastronomiaPageState createState() => _GastronomiaPageState();
}

class _GastronomiaPageState extends State<GastronomiaPage> {
  Future<void>? _fetchPlatosFuture;

  String? selectedCategory;
  String? selectedDishType;
  bool isSearchActive = false;
  bool isGridView = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPlatosFuture = Provider.of<GastronomiaService>(context, listen: false)
        .fetchAllPlatos();
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
    final gastronomiaService =
        Provider.of<GastronomiaService>(context, listen: false);
    final pageProvider = Provider.of<PageProvider>(context, listen: false);

    final isLoading = gastronomiaService.isLoading;
    final platos = gastronomiaService.platos;

    return FutureBuilder(
        future: _fetchPlatosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                if (isSearchActive) {
                  setState(() {
                    isSearchActive = false;
                    searchController.clear();
                  });
                }
              },
              child: BackgroundBoxDecoration(
                child: SizedBox(
                  height: 470.h,
                  child: Column(
                    children: [
                      Expanded(child: BarraDeslizamiento()),
                      Expanded(child: _buildHeader(context, pageProvider)),
                      if (isSearchActive) Expanded(child: _buildSearchField(context)),
                      Expanded(child: _buildButton(context)),
                      Expanded(
                        flex: 5,
                        child: platos == null
                            ? const Center(
                                child: Text(
                                  "No hay platos disponibles",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : isGridView
                                ? _buildGridView(platos, gastronomiaService)
                                : _buildListView(platos, gastronomiaService),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });
  }

  Widget _buildHeader(BuildContext context, PageProvider pageProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: _toggleSearch,
            ),
          ),
          Expanded(
            child: IconButton(
              alignment: Alignment.centerLeft,
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
          ),
          Expanded(
            flex: 3,
            child: Text(
              AppLocalizations.of(context)!.translate('gastronomy'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, AddPlato.route)
            ),
          ),
          Expanded(
            child: IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.translate('search_recipe'),
          hintStyle: const TextStyle(color: Colors.white54),
          fillColor: const Color.fromARGB(255, 47, 42, 42),
          filled: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyRecipesPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 47, 42, 42),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.translate('own_recipe'),
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List platos, GastronomiaService service) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      itemCount: platos.length,
      itemBuilder: (context, index) {
        final plato = platos[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetallePlatillo(
                  platillo: plato.nombre, // Nombre del plato
                  ingredientes: plato.ingredientes, // Ingredientes del plato
                  receta: plato.receta, // Receta del plato
                  closeWidget: () {
                    Navigator.pop(context); // Cierra la pantalla
                  },
                ),
              ),
            );
          },
          child: _buildPlatoCard(plato, service, index),
        );
      },
    );
  }

  Widget _buildGridView(List platos, GastronomiaService service) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: platos.length,
      itemBuilder: (context, index) {
        final plato = platos[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetallePlatillo(
                  platillo: plato.nombre, // Nombre del plato
                  ingredientes: plato.ingredientes, // Ingredientes del plato
                  receta: plato.receta, // Receta del plato
                  closeWidget: () {
                    Navigator.pop(context); // Cierra la pantalla
                  },
                ),
              ),
            );
          },
          child: _buildGridPlatoCard(plato, service, index),
        );
      },
    );
  }

  Widget _buildGridPlatoCard(
      dynamic plato, GastronomiaService service, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r), // Bordes redondeados
      ),
      color: const Color.fromARGB(255, 47, 42, 42),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(8.0.w), // Padding interno
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Asegura que el contenido ocupe todo el ancho
          children: [
            // Imagen de los platos (cubre todo el cuadrado)
            FutureBuilder<Widget>(
              future:
                  service.getImageForPlato(plato.imagenBase64, plato.imagen),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: double.infinity, // La imagen ocupa todo el ancho
                    height: 90
                        .h, // Ajusta la altura de la imagen para evitar el desbordamiento
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.broken_image,
                      size: 50.r, color: Colors.grey);
                } else if (snapshot.hasData) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: SizedBox(
                      width: double.infinity, // La imagen ocupa todo el ancho
                      height: 90
                          .h, // Ajusta la altura para evitar el desbordamiento
                      child: snapshot.data!, // La imagen cargada
                    ),
                  );
                } else {
                  return Icon(Icons.image_not_supported,
                      size: 50.r, color: Colors.grey);
                }
              },
            ),
            const SizedBox(height: 8.0), // Espacio entre imagen y nombre
            // Nombre del plato
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.w),
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                      10.r), // Esquina inferior izquierda redondeada
                  bottomRight: Radius.circular(
                      10.r), // Esquina inferior derecha redondeada
                ),
              ),
              child: Text(
                plato.nombre,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlatoCard(dynamic plato, GastronomiaService service, int index) {
    // Determina si la imagen estará a la izquierda o a la derecha
    bool isImageLeft = index % 2 == 0;

    return Card(
      margin:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // Espaciado
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r), // Esquinas redondeadas
      ),
      color: const Color.fromARGB(255, 47, 42, 42),
      child: Padding(
        padding: EdgeInsets.all(16.0.w), // Padding interno
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: isImageLeft
              ? _buildCardContent(service, plato)
              : _buildCardContent(service, plato).reversed.toList(),
        ),
      ),
    );
  }

  List<Widget> _buildCardContent(GastronomiaService service, dynamic plato) {
    return [
      FutureBuilder<Widget>(
        future: service.getImageForPlato(plato.imagenBase64, plato.imagen),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: 100.w, // Esto sigue siendo mientras carga
              height: 100.h,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Icon(Icons.broken_image, size: 50.r, color: Colors.grey);
          } else if (snapshot.hasData) {
            // Aquí aumentamos el tamaño de la imagen cargada
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width: 100.w, // Aumenta el tamaño de la imagen
                height: 100.h, // Aumenta el tamaño de la imagen
                child: snapshot.data!, // La imagen cargada
              ),
            );
          } else {
            return Icon(Icons.image_not_supported,
                size: 50.r, color: Colors.grey);
          }
        },
      ),
      SizedBox(width: 16.w), // Espacio entre la imagen y el texto
      Expanded(
        child: Text(
          plato.nombre,
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];
  }
}
