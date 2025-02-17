import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'tarjetaFiestaTradicion.dart';

class TradicionesPage extends StatefulWidget {
  static const String route = 'TradicionesPage';

  final Function(String)? onFiestaSelected;

  const TradicionesPage({
    super.key,
    this.onFiestaSelected,
  });

  @override
  _TradicionesPageState createState() => _TradicionesPageState();
}

class _TradicionesPageState extends State<TradicionesPage> {
  Future<void>? fetchTradicionesFuture;
  String? selectedFiesta;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();
  int selectedFilter = 0;
  final sheet = GlobalKey();
  DraggableScrollableController controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onChanged);
    fetchTradicionesFuture =
        Provider.of<TradicionesService>(context, listen: false)
            .getAllTradiciones();
  }

  void onChanged() {
    final currentSize = controller.size;
    if (currentSize <= 0.05) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Cierra solo el modal
      }
    }
  }

  void collapse() => animateSheet(getSheet.snapSizes!.first);

  void anchor() => animateSheet(getSheet.snapSizes!.last);

  void expand() => animateSheet(getSheet.maxChildSize);

  void hide() => animateSheet(getSheet.minChildSize);

  @override
  void dispose() {
    controller.removeListener(onChanged);
    controller.dispose();
    super.dispose();
  }

  void animateSheet(double size) {
    controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  DraggableScrollableSheet get getSheet =>
      (sheet.currentWidget as DraggableScrollableSheet);

  void _toggleContainer(String nombreFiesta) {
    setState(() {
      selectedFiesta = nombreFiesta;
      widget.onFiestaSelected!(nombreFiesta);
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
    final tradicionesProvider =
        Provider.of<TradicionesService>(context, listen: false);

    return FutureBuilder(
      future: fetchTradicionesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TradicionesLoadingEffect();
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: TextStyle(color: Colors.red, fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          final tradiciones = tradicionesProvider.todasLasTradiciones;
          if (tradiciones == null || tradiciones.isEmpty) {
            return Center(
              child: Text(
                'No se encontraron tradiciones.',
                style: TextStyle(fontSize: 18.sp),
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              return DraggableScrollableSheet(
                key: sheet,
                initialChildSize: 0.5,
                maxChildSize: 0.95,
                minChildSize: 0,
                expand: false,
                snap: true,
                snapSizes: [
                  60 / constraints.maxHeight,
                  0.5,
                ],
                controller: controller,
                builder:
                    (BuildContext context, ScrollController scrollController) {
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
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: BarraDeslizamiento()),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate(
                                                    'holidays_traditions'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 21.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(
                                              isSearchActive
                                                  ? Icons.arrow_back
                                                  : Icons.search,
                                              color: Colors.white,
                                            ),
                                            onPressed: _toggleSearch,
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!isSearchActive)
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                      width: size.width - 40.w,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 55, 55, 55),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.r)),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child:
                                                  _buildFilterButton('all', 0)),
                                          Expanded(
                                              child: _buildFilterButton(
                                                  'popular', 1)),
                                          Expanded(
                                              child: _buildFilterButton(
                                                  'nearby', 2)),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: size.width - 40.w,
                                      child: TextField(
                                        controller: searchController,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(
                                                  context)!
                                              .translate('search_traditions'),
                                          hintStyle: const TextStyle(
                                              color: Colors.white54),
                                          fillColor: const Color.fromARGB(
                                              255, 47, 42, 42),
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
                                  ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  flex: 10,
                                  child: RefreshIndicator(
                                    displacement: 20,
                                    onRefresh: () async {
                                      setState(() {
                                        fetchTradicionesFuture =
                                            tradicionesProvider
                                                .getAllTradiciones();
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10.h),
                                      child: SizedBox(
                                        height: constraints.maxHeight * 0.8,
                                        child: ListView.builder(
                                          itemCount: tradiciones.length,
                                          itemBuilder: (context, index) {
                                            final tradicion =
                                                tradiciones[index];
                                            return FiestaCard(
                                              nombre: tradicion.nombre,
                                              fecha: tradicion.fecha,
                                              imagen: tradicionesProvider
                                                  .getImageForTradicion(
                                                      tradicion.imagen),
                                              detalleTap: () =>
                                                  _toggleContainer(
                                                      tradicion.nombre),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildFilterButton(String text, int index) {
    return FilterButton(
      onPressed: () => setState(
        () {
          selectedFilter = index;
          // Agregar lógica para filtrar las tradiciones según el botón seleccionado
        },
      ),
      style: BoxDecoration(
        color: selectedFilter == index
            ? Colors.grey[700]
            : const Color.fromARGB(255, 55, 55, 55),
        borderRadius: BorderRadius.circular(20.r),
      ),
      text: Text(
        textAlign: TextAlign.center,
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

//   return GestureDetector(
//     onTap: () {
//       setState(() {
//         selectedFilter = index;
//         // Agregar lógica para filtrar las tradiciones según el botón seleccionado
//       });
//     },
//     child: Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//       decoration: BoxDecoration(
//         color: selectedFilter == index
//             ? Colors.grey[700]
//             : const Color.fromARGB(255, 55, 55, 55),
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(color: Colors.white),
//       ),
//     ),
//   );
// }

class FilterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final BoxDecoration? style;
  final Text? text;

  const FilterButton({super.key, this.onPressed, this.style, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: style,
        child: text,
      ),
    );
  }
}

// class TradicionesLoadingEffect extends StatefulWidget {
//   const TradicionesLoadingEffect({super.key});

//   @override
//   State<TradicionesLoadingEffect> createState() =>
//       _TradicionesLoadingEffectState();
// }

// class _TradicionesLoadingEffectState extends State<TradicionesLoadingEffect> {
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: const Color.fromARGB(255, 0, 0, 0),
//       enabled: true,
//       child: BackgroundBoxDecoration(
//         child: Container(
//           height: 600.h,
//           child: Column(
//             children: [
//               BarraDeslizamiento(),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             left: 16.0
//                                 .r), // Ajusta el espacio que quieras a la izquierda
//                         child: Text(
//                           AppLocalizations.of(context)!
//                               .translate('holidays_traditions'),
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             fontSize: 21.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Icon(
//                       Icons.search,
//                       color: Colors.white,
//                     ),
//                     Icon(
//                       Icons.close,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 2.h),
//                 margin: EdgeInsets.only(bottom: 10.h),
//                 width: double.infinity - 40.w,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 55, 55, 55),
//                   borderRadius: BorderRadius.all(Radius.circular(20.r)),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     FilterButton(
//                       text: Text("Todo",
//                           style: const TextStyle(color: Colors.white)),
//                       style: BoxDecoration(
//                         color: Colors.grey[700],
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                     ),
//                     FilterButton(
//                       text: Text("Populares",
//                           style: const TextStyle(color: Colors.white)),
//                       style: BoxDecoration(
//                         color: Colors.grey[700],
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                     ),
//                     FilterButton(
//                       text: Text("Cercano",
//                           style: const TextStyle(color: Colors.white)),
//                       style: BoxDecoration(
//                         color: Colors.grey[700],
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   padding: EdgeInsets.all(0),
//                   itemCount: 4,
//                   itemBuilder: (context, index) {
//                     return FiestaCard();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class TradicionesLoadingEffect extends StatefulWidget {
  const TradicionesLoadingEffect({super.key});

  @override
  State<TradicionesLoadingEffect> createState() =>
      _TradicionesLoadingEffectState();
}

class _TradicionesLoadingEffectState extends State<TradicionesLoadingEffect> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BackgroundBoxDecoration(
      child: SizedBox(
        height: 600.h,
        child: Column(
          children: [
            Expanded(child: BarraDeslizamiento()),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
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
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: size.width - 40.w,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 55, 55, 55),
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FilterButton(
                        text: Text(
                          "Todo",
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        style: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FilterButton(
                        text: Text("Populares",
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center),
                        style: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FilterButton(
                        text: Text("Cercanos",
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center),
                        style: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return const FiestaCardShimmer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
