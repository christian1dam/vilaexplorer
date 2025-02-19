import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/src/pages/lugarInteresPage/detalle_lugar_interes.dart';
import 'lugar_interes_tarjeta.dart';

class LugarDeInteresPage extends StatefulWidget {
  final ScrollController? scrollController;
  final BoxConstraints? constraints;

  const LugarDeInteresPage(
      {super.key, this.scrollController, this.constraints});

  @override
  _LugarDeInteresPageState createState() => _LugarDeInteresPageState();
}

class _LugarDeInteresPageState extends State<LugarDeInteresPage> {
  Future<void>? _lugaresDeInteresFuture;
  String? selectedLugarInteres;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();
  int selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _lugaresDeInteresFuture =
        Provider.of<LugarDeInteresService>(context, listen: false)
            .fetchLugaresDeInteresActivos();
  }

  @override
  Widget build(BuildContext context) {
    final lugarDeInteresService =
        Provider.of<LugarDeInteresService>(context, listen: false);

    return BackgroundBoxDecoration(
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(fit: FlexFit.loose, child: BarraDeslizamiento()),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.all(8.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              height: 35.h,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('sights'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: FutureBuilder(
                    future: _lugaresDeInteresFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final lugaresDeInteres =
                            lugarDeInteresService.lugaresDeInteres;
                        if (lugaresDeInteres.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('no_poi_available'),
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return SizedBox(
                          height: widget.constraints!.maxHeight * 0.76,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: lugaresDeInteres.length,
                            itemBuilder: (context, index) {
                              final lugarDeInteres = lugaresDeInteres[index];
                              return LugarDeInteresTarjeta(
                                lugarDeInteres: lugarDeInteres,
                                onTap: () {
                                  Navigator.pop(context); 
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isDismissible: true,
                                    constraints: BoxConstraints(maxHeight: 500),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DetalleLugarInteres(
                                        lugarDeInteresID:
                                            lugarDeInteres.idLugarInteres!,
                                        context: context,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }

                      return SizedBox(
                        height: widget.constraints!.maxHeight * 0.76,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[700]!,
                              highlightColor: Colors.grey[500]!,
                              child: Card(
                                color: Colors.grey[850],
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(15)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 20,
                                            color: Colors.grey[700],
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            width: 100,
                                            height: 15,
                                            color: Colors.grey[700],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
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
