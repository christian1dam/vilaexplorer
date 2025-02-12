import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'tarjetaFiestaTradicion.dart';

class TradicionesPage extends StatefulWidget {
  final Function(String) onFiestaSelected;

  const TradicionesPage({
    super.key,
    required this.onFiestaSelected,
  });

  @override
  _TradicionesPageState createState() => _TradicionesPageState();
}

class _TradicionesPageState extends State<TradicionesPage> {
  String? selectedFiesta;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();
  int selectedFilter = 0; // Índice del filtro seleccionado

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TradicionesService>(context, listen: false)
          .getAllTradiciones();
    });
  }

  void _toggleContainer(String nombreFiesta) {
    setState(() {
      selectedFiesta = nombreFiesta;
      widget.onFiestaSelected(nombreFiesta);
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        searchController.clear();
        // Restablecer filtro a "Todo" si se cierra la búsqueda
        selectedFilter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pageProvider = Provider.of<PageProvider>(context, listen: false);

    return Consumer<TradicionesService>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Text(
              provider.error!,
              style: const TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        }

        final tradiciones = provider.todasLasTradiciones;

        if (tradiciones == null || tradiciones.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron tradiciones.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

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
              height: 600.h,
              child: Column(
                children: [
                  BarraDeslizamiento(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left:
                                    16.0), // Ajusta el espacio que quieras a la izquierda
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('holidays_traditions'),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isSearchActive ? Icons.arrow_back : Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: _toggleSearch,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => pageProvider.changePage('map'),
                        ),
                      ],
                    ),
                  ),
                  if (!isSearchActive)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      margin: EdgeInsets.only(bottom: 10.h),
                      width: size.width - 40.w,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 55, 55, 55),
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFilterButton('Todo', 0),
                          _buildFilterButton('Populares', 1),
                          _buildFilterButton('Cercanos', 2),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .translate('search_traditions'),
                          hintStyle: const TextStyle(color: Colors.white54),
                          fillColor: const Color.fromARGB(255, 47, 42, 42),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.r)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: tradiciones.length,
                      itemBuilder: (context, index) {
                        final tradicion = tradiciones[index];
                        return FiestaCard(
                          nombre: tradicion.nombre,
                          fecha: tradicion.fecha,
                          imagen:
                              provider.getImageForTradicion(tradicion.imagen),
                          detalleTap: () => _toggleContainer(tradicion.nombre),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
          // Agregar lógica para filtrar las tradiciones según el botón seleccionado
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
