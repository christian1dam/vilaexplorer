import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/models/tipo_entidad.dart';
import 'package:vilaexplorer/service/favorito_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class LugarDeInteresTarjeta extends StatelessWidget {
  final LugarDeInteres lugarDeInteres;
  final Function() onTap;

  const LugarDeInteresTarjeta({
    super.key,
    required this.lugarDeInteres,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final favoritoService = Provider.of<FavoritoService>(context);

    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: FadeInImage(
                      placeholder: AssetImage("assets/no-image.jpg"),
                      image: NetworkImage(lugarDeInteres.imagen!),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/no-image.jpg",
                          width: 50,
                          fit: BoxFit.cover,
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.7),
                        Color.fromRGBO(0, 0, 0, 0.0),
                      ],
                    ),
                  ),
                  child: Text(
                    lugarDeInteres.nombreLugar ??
                        'Nombre no disponible', // Nombre del lugar
                    style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lugarDeInteres.fechaAlta != null
                          ? lugarDeInteres.fechaAlta.toString()
                          : 'Fecha no disponible', 
                      style: const TextStyle(
                          color: Color.fromRGBO(224, 120, 62, 1), fontSize: 16),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                        shadowColor: WidgetStatePropertyAll(Colors.transparent),
                        overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      ),
                        child: favoritoService.esFavorito(
                                lugarDeInteres.idLugarInteres!,
                                TipoEntidad.LUGAR_INTERES)
                            ? MySvgWidget(path: 'lib/icon/favoriteTrue.svg')
                            : MySvgWidget(path: 'lib/icon/guardar_icon.svg'),
                        onPressed: () async {
                          await favoritoService.gestionarFavorito(
                            idUsuario: await UserPreferences().id,
                            idEntidad: lugarDeInteres.idLugarInteres!,
                            tipoEntidad: TipoEntidad.LUGAR_INTERES.name,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
