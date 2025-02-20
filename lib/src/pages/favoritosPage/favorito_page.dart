import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:vilaexplorer/service/favorito_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class FavoritosPage extends StatefulWidget {
  final ScrollController? scrollCOntroller;
  final BoxConstraints? boxConstraints;

  const FavoritosPage({super.key, this.scrollCOntroller, this.boxConstraints});

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();
  late Future<List<dynamic>> _favoritosDelUsuarioFuture;
  late List<dynamic> _favoritosDelUsuario;

  @override
  void initState() {
    super.initState();
    _favoritosDelUsuarioFuture = _fetchData();
  }

  Future<List<dynamic>> _fetchData() async {
    final userPreferences = UserPreferences();
    final service = Provider.of<FavoritoService>(context, listen: false);
    await service.getFavoritosByUsuario(await userPreferences.id);
    return service.favoritosDelUsuario;
  }


  @override
  Widget build(BuildContext context) {
    final favoritoService = Provider.of<FavoritoService>(context);
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
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('favorites'),
                            style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.w),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1.h,
                  indent: 25.w,
                  endIndent: 25.w,
                ),
                FutureBuilder(
                  future: _favoritosDelUsuarioFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      _favoritosDelUsuario =
                          favoritoService.favoritosDelUsuario;
                      return Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: widget.boxConstraints!.maxHeight * 0.76,
                          child: ListView(
                            padding: EdgeInsets.only(top: 10.h),
                            children: [
                              ExpansionTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .translate('monuments_place'),
                                  style: TextStyle(color: Colors.white),
                                ),
                                collapsedIconColor: Colors.white,
                                iconColor: Colors.white,
                                children: _favoritosDelUsuario
                                    .whereType<LugarDeInteres>()
                                    .map((favorito) {
                                  final lugar = favorito;
                                  return Dismissible(
                                    key: Key(lugar.idLugarInteres.toString()),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) async {
                                      await favoritoService.eliminarFavorito(
                                          favorito.idLugarInteres!,
                                          await UserPreferences().id);
                                    },
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      color: Colors.red,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      elevation: 3,
                                      child: ListTile(
                                        leading: FadeInImage(
                                          placeholder:
                                              AssetImage('assets/no-image.jpg'),
                                          image: NetworkImage(lugar.imagen!),
                                          width: 50,
                                          fit: BoxFit.contain,
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/no-image.jpg",
                                              width: 50,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                        title: Text(
                                          lugar.nombreLugar!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          lugar.descripcion!,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              ExpansionTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .translate('gastronomy'),
                                  style: TextStyle(color: Colors.white),
                                ),
                                collapsedIconColor: Colors.white,
                                iconColor: Colors.white,
                                children: _favoritosDelUsuario
                                    .whereType<Plato>()
                                    .map((favorito) {
                                  final plato = favorito;
                                  return Dismissible(
                                    key: Key(plato.platoId.toString()),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) async {
                                      await favoritoService.eliminarFavorito(
                                          favorito.platoId,
                                          await UserPreferences().id);
                                    },
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      color: Colors.red,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      elevation: 3,
                                      child: ListTile(
                                        leading: FadeInImage(
                                          placeholder:
                                              AssetImage('assets/no-image.jpg'),
                                          image: NetworkImage(plato.imagen!),
                                          width: 50,
                                          fit: BoxFit.contain,
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/no-image.jpg",
                                              width: 50,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                        title: Text(
                                          plato.nombre,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          plato.descripcion,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              ExpansionTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .translate('traditions'),
                                  style: TextStyle(color: Colors.white),
                                ),
                                collapsedIconColor: Colors.white,
                                iconColor: Colors.white,
                                children: _favoritosDelUsuario
                                    .whereType<Tradicion>()
                                    .map((favorito) {
                                  final lugar = favorito;
                                  return Dismissible(
                                    key:
                                        Key(lugar.idFiestaTradicion.toString()),
                                        background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      color: Colors.red,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) async {
                                      favoritoService.eliminarFavorito(
                                          favorito.idFiestaTradicion,
                                          await UserPreferences().id);
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      elevation: 3,
                                      child: ListTile(
                                        leading: FadeInImage(
                                          placeholder:
                                              AssetImage('assets/no-image.jpg'),
                                          image: NetworkImage(lugar.imagen),
                                          width: 50,
                                          fit: BoxFit.contain,
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/no-image.jpg",
                                              width: 50,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                        title: Text(
                                          lugar.nombre,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          lugar.descripcion,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
