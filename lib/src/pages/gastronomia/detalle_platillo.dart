import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/models/tipo_entidad.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';
import 'package:vilaexplorer/service/puntuacion_service.dart';
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

  const DetallePlatillo({
    super.key,
  });

  @override
  _DetallePlatilloState createState() => _DetallePlatilloState();
}

class _DetallePlatilloState extends State<DetallePlatillo> {
  bool showIngredientes = true;
  late Plato _plato;

  @override
  Widget build(BuildContext context) {
    _plato = ModalRoute.of(context)!.settings.arguments as Plato;
    final ingredientes = _plato.ingredientes.split(',');
    final puntuacionService =
        Provider.of<PuntuacionService>(context, listen: false);
    final userPreferences = UserPreferences();
    final gastronomiaService =
        Provider.of<GastronomiaService>(context, listen: false);

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
          IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _plato.nombre,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _plato.descripcion,
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      RatingBar.builder(
                        itemSize: 16.r,
                        initialRating: _plato.puntuacionMediaPlato,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        unratedColor: Colors.grey,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0.w),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Color.fromARGB(230, 255, 255, 64),
                        ),
                        onRatingUpdate: (rating) async {
                          await puntuacionService.gestionarPuntuacion(
                            idUsuario: await userPreferences.id,
                            idEntidad: _plato.platoId,
                            tipoEntidad: TipoEntidad.PLATO.name,
                            puntuacion: rating.toInt(),
                            context: context,
                          );
                          debugPrint("Nueva calificación: $rating \n $_plato.puntuacionMediaLugar}");
                          await gastronomiaService.fetchPlatoById(_plato.platoId);
                          setState(
                            () {
                              _plato = gastronomiaService.platoSeleccionado;
                            },
                          );
                        },
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        _plato.puntuacionMediaPlato.toStringAsFixed(2),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _plato.imagen!,
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
                    _plato.receta,
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
                                child: Text("· ${ingredientes[index]}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    )),
                              ),
                            ),
                          ),
                          Divider(color: Colors.white54, thickness: 0.5),
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
  }
}
