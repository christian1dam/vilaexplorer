import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/detalle_fiesta_tradicion.dart';
import 'tarjetaFiestaTradicion.dart';

class TradicionesPage extends StatefulWidget {
  static const String route = 'TradicionesPage';

  final ScrollController? scrollCOntroller;
  final BoxConstraints? boxConstraints;

  const TradicionesPage({
    super.key,
    this.scrollCOntroller,
    this.boxConstraints,
  });

  @override
  _TradicionesPageState createState() => _TradicionesPageState();
}

class _TradicionesPageState extends State<TradicionesPage> {
  Future<void>? fetchTradicionesFuture;

  @override
  void initState() {
    super.initState();
    fetchTradicionesFuture =
        Provider.of<TradicionesService>(context, listen: false)
            .getAllTradiciones();
  }

  @override
  Widget build(BuildContext context) {
    final tradicionesProvider =
        Provider.of<TradicionesService>(context, listen: false);
    return BackgroundBoxDecoration(
      child: CustomScrollView(
        controller: widget.scrollCOntroller,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(fit: FlexFit.loose, child: BarraDeslizamiento()),
                Flexible(
                  fit: FlexFit.loose,
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
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                  future: fetchTradicionesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final tradiciones =
                          tradicionesProvider.todasLasTradiciones;
                      if (tradiciones == null || tradiciones.isEmpty) {
                        return Center(
                          child: Text(
                            'No se encontraron tradiciones.',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        );
                      }
                      return Flexible(
                        fit: FlexFit.loose,
                        flex: 10,
                        child: RefreshIndicator(
                          displacement: 20,
                          onRefresh: () async {
                            setState(() {
                              fetchTradicionesFuture =
                                  tradicionesProvider.getAllTradiciones();
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: SizedBox(
                              height: widget.boxConstraints!.maxHeight * 0.9,
                              child: ListView.builder(
                                itemCount: tradiciones.length,
                                itemBuilder: (context, index) {
                                  final tradicion = tradiciones[index];
                                  return FiestaCard(
                                    detalleTap: () {
                                      Navigator.pop(context);
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          isDismissible: true,
                                          enableDrag: true,
                                          constraints: BoxConstraints(
                                            maxHeight:
                                                MediaQuery.sizeOf(context)
                                                        .height *
                                                    0.70,
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return DetalleFiestaTradicion(
                                                id: tradicion
                                                    .idFiestaTradicion);
                                          });
                                    },
                                    nombre: tradicion.nombre,
                                    fecha: tradicion.fecha,
                                    imagen: Image.network(
                                      tradicion.imagen,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image(
                                          image:
                                              AssetImage("assets/no-image.jpg"),
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      flex: 10,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: SizedBox(
                          height: widget.boxConstraints!.maxHeight * 0.9,
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return const FiestaCardShimmer();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

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
