import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/models/tipo_entidad.dart';
import 'package:vilaexplorer/service/favorito_service.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/service/puntuacion_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/src/widgets/loading.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

const kButtonBackgroundColorSelected = Color.fromRGBO(32, 29, 29, 0.9);
const kButtonBackgroundColorUnselected = Color.fromRGBO(45, 45, 45, 1);
const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w300,
  fontSize: 18,
  decoration: TextDecoration.none,
);
const kIngredientesTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.none,
);
const kTituloTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 22,
  decoration: TextDecoration.none,
);

class DetallePlatillo extends StatefulWidget {
  static const String route = 'DetallePlato';
  final int? platoID;

  const DetallePlatillo({
    super.key,
    this.platoID,
  });

  @override
  _DetallePlatilloState createState() => _DetallePlatilloState();
}

class _DetallePlatilloState extends State<DetallePlatillo> {
  bool showIngredientes = true;
  late Future<void> _plato;

  @override
  void initState() {
    super.initState();
    _plato = Provider.of<GastronomiaService>(context, listen: false)
        .fetchPlatoById(widget.platoID!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _plato,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(imagePath: 'assets/images/VilaExplorer.png');
          }
          return Consumer2<FavoritoService, GastronomiaService>(
            builder: (context, favoritoService, gastronomiaService,  child) {
              Plato plato = gastronomiaService.platoSeleccionado;
              final ingredientes = plato.ingredientes.split(',');
              final puntuacionService =
                  Provider.of<PuntuacionService>(context, listen: false);
              final userPreferences = UserPreferences();
              return Scaffold(
                backgroundColor: const Color.fromARGB(255, 24, 24, 24),
                appBar: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color.fromARGB(255, 24, 24, 24),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 24, 24, 24),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: favoritoService.esFavorito(
                              plato.platoId, TipoEntidad.PLATO)
                          ? MySvgWidget(path: 'lib/icon/favoriteTrue.svg')
                          : MySvgWidget(path: 'lib/icon/guardar_icon.svg'),
                      onPressed: () async {
                        await favoritoService.gestionarFavorito(
                          idUsuario: await userPreferences.id,
                          idEntidad: plato.platoId,
                          tipoEntidad: TipoEntidad.PLATO.name,
                        );
                      },
                    ),
                  ],
                ),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plato.nombre,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  plato.descripcion,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Spacer(),
                                RatingBar.builder(
                                  itemSize: 16.r,
                                  initialRating: plato.puntuacionMediaPlato,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  unratedColor: Colors.grey,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 1.0.w),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Color.fromARGB(230, 255, 255, 64),
                                  ),
                                  onRatingUpdate: (rating) async {
                                    await puntuacionService.gestionarPuntuacion(
                                      idUsuario: await userPreferences.id,
                                      idEntidad: plato.platoId,
                                      tipoEntidad: TipoEntidad.PLATO.name,
                                      puntuacion: rating.toInt(),
                                      context: context,
                                    );
                                    debugPrint("Nueva calificación: $rating \n $plato.puntuacionMediaLugar}");
                                    await gastronomiaService.fetchPlatoById(plato.platoId);
                                  },
                                ),
                                SizedBox(width: 7.w),
                                Text(
                                  plato.puntuacionMediaPlato.toStringAsFixed(2),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                plato.imagen!,
                                width: double.infinity,
                                height: constraints.maxWidth * 0.6,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/no-image.jpg",
                                    height: constraints.maxWidth * 0.6,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Text("Receta",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              plato.receta,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 16),
                            Text("Ingredientes:",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: ingredientes.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 70,
                                      width: double.infinity,
                                      child: ListTile(
                                        leading: SizedBox(
                                          child:
                                              Text("· ${ingredientes[index]}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  )),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                        color: Colors.white54, thickness: 0.5),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        });
  }
}
