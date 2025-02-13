import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/favorito_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

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
    final favoritoService =
        Provider.of<FavoritoService>(context, listen: false);
    final pageProvider = Provider.of<PageProvider>(context, listen: false);

    return FutureBuilder(
      future: _favoritosDelUsuarioFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.black,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("ERROR: ${snapshot.error}"),
          );
        } else {
          _favoritosDelUsuario = favoritoService.favoritosDelUsuario;
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
                height: 550.h,
                child: Column(
                  children: [
                    BarraDeslizamiento(),
              
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: _toggleSearch,
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate('favorites'),
                            style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.w),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            pageProvider.clearScreen();
                          },
                        ),
                      ],
                    ),
              
                    if (isSearchActive)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .translate('search_favorites'),
                            hintStyle: TextStyle(color: Colors.white54),
                            fillColor: Color.fromARGB(255, 47, 42, 42),
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
              
                    Divider(
                      color: Colors.white,
                      thickness: 1.h,
                      indent: 25.w,
                      endIndent: 25.w,
                    ),
              
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(top: 10.h),
                        children: [
                          // Primera lista desplegable
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
                              return ListTile(
                                title: Text(
                                  lugar.nombreLugar!,
                                  style: TextStyle(color: Colors.white),
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
                              return ListTile(
                                title: Text(
                                  plato.nombre,
                                  style: TextStyle(color: Colors.white),
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
                                .whereType<Tradiciones>()
                                .map((favorito) {
                              final lugar = favorito;
                              return Dismissible(
                                key: Key(lugar.idFiestaTradicion.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  // TODO #2
                                },
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 40.w,
                                    height: 50.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.r),
                                      child: FadeInImage(
                                        placeholder:
                                            AssetImage("assets/no-image.jpg"),
                                        image: NetworkImage(lugar.imagen),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    lugar.nombre,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
