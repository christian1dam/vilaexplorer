import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/providers/map_state_provider.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';

class LugarDeInteresDelegate extends SearchDelegate {
  String get searchFieldLabel => 'Buscar lugar de interés';

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return ThemeData(
      applyElevationOverlayColor: true,
      textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 24.0, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
      color: const Color.fromARGB(255, 32, 31, 31),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white)
      ),
      inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none, 
      
      hintStyle: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 69, 69, 69)
    );
  }


 @override
 TextStyle? get searchFieldStyle => TextStyle(color: Colors.white, fontSize: 18);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
/*icon: AnimatedIcon(
icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),*/
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return EmptyContainer();
    }
    final lugarDeInteresService =
        Provider.of<LugarDeInteresService>(context, listen: false);
    lugarDeInteresService.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: lugarDeInteresService.suggestionStream,
      builder: (_, AsyncSnapshot<List<LugarDeInteres>> snapshot) {
        if (snapshot.hasData) {
          final lugaresDeInteres = snapshot.data!;
          return ListView.builder(
            itemCount: lugaresDeInteres.length,
            itemBuilder: ((context, index) =>
                _LugarDeInteresItem(lugaresDeInteres[index])),
          );
        } else {
          return EmptyContainer();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return EmptyContainer();
    }
    final lugarDeInteresService =
        Provider.of<LugarDeInteresService>(context, listen: false);
    lugarDeInteresService.getSuggestionsByQuery(query);

    return StreamBuilder(
        stream: lugarDeInteresService.suggestionStream,
        builder: (_, AsyncSnapshot<List<LugarDeInteres>> snapshot) {
          if (snapshot.hasData) {
            final lugaresDeInteres = snapshot.data!;
            return ListView.builder(
              itemCount: lugaresDeInteres.length,
              itemBuilder: ((context, index) =>
                  _LugarDeInteresItem(lugaresDeInteres[index])),
            );
          } else {
            return EmptyContainer();
          }
        });
  }
}

class _LugarDeInteresItem extends StatelessWidget {
  final LugarDeInteres lugarDeInteres;
  const _LugarDeInteresItem(this.lugarDeInteres);
  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapStateProvider>(context, listen: false);
    lugarDeInteres.uniqueId = '${lugarDeInteres.idLugarInteres}-search';
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r), 
      ),
      elevation: 3,
      child: ListTile(
        leading: Hero(
          tag: lugarDeInteres.uniqueId!,
          child: FadeInImage(
            placeholder: AssetImage('assets/no-image.jpg'),
            image: NetworkImage(lugarDeInteres.imagen!),
            width: 50,
            fit: BoxFit.contain,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/no-image.jpg",
                width: 50,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        title: Text(
          lugarDeInteres.nombreLugar!,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          lugarDeInteres.descripcion!,
          style: TextStyle(color: Colors.black54),
        ),
        onTap: () {
          debugPrint(lugarDeInteres.toString());
          Navigator.pop(context);
          mapProvider.lugarDeInteres = lugarDeInteres;
          mapProvider.focusPOI = true;
        },
      ),
    );
  }
}

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.place_outlined,
        color: const Color.fromARGB(96, 226, 226, 226),
        size: 130,
      ),
    );
  }
}
