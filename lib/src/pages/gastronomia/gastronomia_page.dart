import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/src/pages/gastronomia/addPlato.dart';
import 'package:vilaexplorer/src/pages/gastronomia/detalle_platillo.dart';
import 'package:vilaexplorer/src/pages/gastronomia/myRecipesPage.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';

class GastronomiaPage extends StatefulWidget {
  final ScrollController? scrollController;
  final BoxConstraints? boxConstraints;

  final Function(String) onCategoriaPlatoSelected;

  const GastronomiaPage({
    super.key,
    required this.onCategoriaPlatoSelected,
    this.scrollController,
    this.boxConstraints,
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
    final platos = gastronomiaService.platos;

    return FutureBuilder(
        future: _fetchPlatosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BackgroundBoxDecoration(
              child: CustomScrollView(
                controller: widget.scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            fit: FlexFit.loose, child: BarraDeslizamiento()),
                        Flexible(fit: FlexFit.loose, child: _buildHeader()),
                        if (isSearchActive)
                          Flexible(
                              fit: FlexFit.loose, child: _buildSearchField()),
                        Flexible(fit: FlexFit.loose, child: _buildButton()),
                        Flexible(
                          fit: FlexFit.loose,
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
                ],
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: IconButton(
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: _toggleSearch,
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
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
          Flexible(
            fit: FlexFit.loose,
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
          Flexible(
            fit: FlexFit.loose,
            child: IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, AddPlato.route)),
          ),
          Flexible(
            fit: FlexFit.loose,
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

  Widget _buildSearchField() {
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

  Widget _buildButton() {
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
    return SizedBox(
      height: widget.boxConstraints!.maxHeight * 0.76,
      child: ListView.builder(
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
                    platillo: plato.nombre,
                    ingredientes: plato.ingredientes,
                    receta: plato.receta,
                    closeWidget: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            child: _buildPlatoCard(plato, index),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List platos, GastronomiaService service) {
    return SizedBox(
      height: widget.boxConstraints!.maxHeight * 0.76,
      child: GridView.builder(
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
                    platillo: plato.nombre,
                    ingredientes: plato.ingredientes,
                    receta: plato.receta,
                    closeWidget: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            child: _buildGridPlatoCard(plato),
          );
        },
      ),
    );
  }

  Widget _buildGridPlatoCard(Plato plato) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      color: const Color.fromARGB(255, 47, 42, 42),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width: double.infinity,
                height: 90.h,
                child: FadeInImage(
                  placeholder: AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(plato.imagen!),
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/no-image.jpg",
                      height: 90,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
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

  Widget _buildPlatoCard(Plato plato, int index) {
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
              ? _buildCardContent(plato)
              : _buildCardContent(plato).reversed.toList(),
        ),
      ),
    );
  }

  List<Widget> _buildCardContent(Plato plato) {
    return [
      ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: SizedBox(
          width: 100.w,
          height: 100.h,
          child: FadeInImage(
            placeholder: AssetImage("assets/no-image.jpg"),
            image: NetworkImage(plato.imagen!),
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/no-image.jpg",
                width: 50,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
      SizedBox(width: 16.w),
      Flexible(
        fit: FlexFit.loose,
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
