import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';

class LugarDeInteresDelegate extends SearchDelegate {
  String get searchFieldLabel => 'Buscar lugar de interés';
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
    print("ERROR AQUIIII");
    lugarDeInteres.uniqueId = '${lugarDeInteres.idLugarInteres}-search';
    return SizedBox(
      height: 70,
      width: 100,
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
        title: Text(lugarDeInteres.nombreLugar!),
        subtitle: Text(lugarDeInteres.descripcion!),
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: lugarDeInteres);
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
        Icons.movie_creation_outlined,
        color: Colors.black38,
        size: 130,
      ),
    );
  }
}
