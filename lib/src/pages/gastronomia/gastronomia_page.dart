import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/src/pages/gastronomia/addPlato.dart';
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
  String? selectedCategory;
  String? selectedDishType;
  bool isSearchActive = false;
  bool isGridView = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<GastronomiaService>(context, listen: false).fetchAllPlatos();
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

  @override
  Widget build(BuildContext context) {
    final gastronomiaService = Provider.of<GastronomiaService>(context);
    final pageProvider = Provider.of<PageProvider>(context);
    final size = MediaQuery.of(context).size;

    // Lógica para mostrar la pantalla de carga o los datos
    final isLoading = gastronomiaService.isLoading;
    final platos = gastronomiaService.platos;

    return GestureDetector(
      onTap: () {
        if (isSearchActive) {
          setState(() {
            isSearchActive = false;
            searchController.clear();
          });
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: size.height * 0.65,
          decoration: BoxDecoration(
            color: Color.fromRGBO(32, 29, 29, 0.9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: GestureDetector(
            onTap: () {},
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0.h),
                        child: BarraDeslizamiento()
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Colors.white),
                                  onPressed: _toggleSearch,
                                ),
                                IconButton(
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
                                SizedBox(width: 17.w),
                                Container(
                                  width: size.width * 0.45,
                                  height: 35.h,
                                  alignment: Alignment.center,
                                    child: Text(
                                    AppLocalizations.of(context)!.translate('gastronomy'),
                                    style: TextStyle(
                                      fontSize: 23.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),                                  
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add,
                                          color: Colors.white),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddPlato(),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                        onPressed: () {pageProvider.changePage('map');},
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      if (isSearchActive)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .translate('search_recipe'),
                              hintStyle: const TextStyle(color: Colors.white54),
                              fillColor: const Color.fromARGB(255, 47, 42, 42),
                              filled: true,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 10.w),
                            ),
                          ),
                        ),

                      // New button spans entire width
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 16.w),
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
                              backgroundColor: const Color.fromARGB(
                                  255, 47, 42, 42), // Button color
                              foregroundColor: const Color.fromARGB(
                                  255, 255, 255, 255), // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('own_recipe'),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                        ),
                      ),
                      // Reduced space below button
                      SizedBox(height: 5.h),
                      Expanded(
                        child: platos == null
                            ? const Center(
                                child: Text(
                                  "No hay platos disponibles",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : isGridView
                                ? GridView.builder(
                                    padding: EdgeInsets.all(8.0.h),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                    ),
                                    itemCount: platos.length,
                                    itemBuilder: (context, index) {
                                      final plato = platos[index];
                                      final gastronomiaService =
                                          Provider.of<GastronomiaService>(
                                              context,
                                              listen: false);

                                      return Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: FutureBuilder<Widget>(
                                                future: gastronomiaService
                                                    .getImageForPlato(
                                                  plato.imagenBase64,
                                                  plato.imagen,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Icon(
                                                      Icons.broken_image,
                                                      size: 50.r,
                                                      color: Colors.grey,
                                                    );
                                                  } else if (snapshot.hasData) {
                                                    return Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: (snapshot.data
                                                                  as Image)
                                                              .image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Icon(
                                                      Icons.image_not_supported,
                                                      size: 50.r,
                                                      color: Colors.grey,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 8.h),
                                              child: Text(
                                                plato.nombre,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 8.h),
                                    itemCount: platos.length,
                                    itemBuilder: (context, index) {
                                      final plato = platos[index];
                                      final gastronomiaService =
                                          Provider.of<GastronomiaService>(
                                              context,
                                              listen: false);

                                      return Card(
                                        color: const Color.fromARGB(
                                            255, 47, 42, 42),
                                        child: ListTile(
                                          leading: FutureBuilder<Widget>(
                                            future: gastronomiaService
                                                .getImageForPlato(
                                                    plato.imagenBase64,
                                                    plato.imagen),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return SizedBox(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Icon(
                                                  Icons.broken_image,
                                                  size: 50.r,
                                                  color: Colors.grey,
                                                );
                                              } else if (snapshot.hasData) {
                                                return snapshot.data!;
                                              } else {
                                                return Icon(
                                                  Icons.image_not_supported,
                                                  size: 50.r,
                                                  color: Colors.grey,
                                                );
                                              }
                                            },
                                          ),
                                          title: Text(
                                            plato.nombre,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp),
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
