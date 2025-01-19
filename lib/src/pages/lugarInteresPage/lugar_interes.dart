import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'lugar_interes_tarjeta.dart';

class LugarDeInteresPage extends StatefulWidget {
  const LugarDeInteresPage({Key? key}) : super(key: key);

  @override
  _LugarDeInteresPageState createState() => _LugarDeInteresPageState();
}

class _LugarDeInteresPageState extends State<LugarDeInteresPage> {
  String? selectedLugarInteres;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();
  int selectedFilter =
      0; // Índice del botón seleccionado, 0 para 'Todo' por defecto

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LugarDeInteresService>().fetchLugaresDeInteresActivos();
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        // Limpiamos el texto de búsqueda cuando se desactiva
        searchController.clear();
        // Aquí podrías agregar lógica para resetear el filtro a 'Todo' si es necesario
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lugarDeInteresService =
        Provider.of<LugarDeInteresService>(context, listen: false);
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
    final lugaresDeInteres = lugarDeInteresService.lugaresDeInteres;

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(32, 29, 29, 0.9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  BarraDeslizamiento(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                              ),
                              margin: const EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 35.h,
                              child: const Center(
                                child: Text(
                                  'Lugares de Interés',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => pageProvider.changePage('map'),
                        ),
                      ],
                    ),
                  ),
                  // Botones para filtros y barra de búsqueda
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                  isSearchActive
                                      ? Icons.arrow_back
                                      : Icons.search,
                                  color: Colors.white),
                              onPressed: _toggleSearch,
                            ),
                            if (!isSearchActive) ...[
                              // Envolvemos los botones en un Container para el estilo de fondo
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          2.h), // Reducimos el padding vertical
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 55, 55,
                                        55), // Fondo oscuro similar al de la imagen
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildFilterButton('Todo', 0),
                                      _buildFilterButton('Populares', 1),
                                      _buildFilterButton('Cercanos', 2),
                                    ],
                                  ),
                                ),
                              ),
                            ] else
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  style: const TextStyle(color: Colors.white),
                                  onChanged: (query) {
                                    lugarDeInteresService
                                        .searchLugarDeInteres(query);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Buscar lugares de interés...',
                                    hintStyle:
                                        const TextStyle(color: Colors.white54),
                                    fillColor:
                                        const Color.fromARGB(255, 47, 42, 42),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.r)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 10.w),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (lugarDeInteresService.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (lugarDeInteresService.errorMessage != null) {
                          return Center(
                            child: Text(
                              lugarDeInteresService.errorMessage!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        if (lugaresDeInteres.isEmpty) {
                          return const Center(
                            child: Text(
                              "No se encontraron monumentos",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: lugaresDeInteres.length,
                          itemBuilder: (context, index) {
                            final lugarDeInteres = lugaresDeInteres[index];
                            return LugarDeInteresTarjeta(
                              lugarDeInteres: lugarDeInteres,
                              abrirTarjeta: () =>
                                  pageProvider.setLugarDeInteres(
                                lugarDeInteres.nombreLugar!,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
          // Aquí puedes agregar la lógica para cambiar el filtro según el botón seleccionado
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selectedFilter == index
              ? Colors.grey[700]
              : const Color.fromARGB(255, 55, 55, 55),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
