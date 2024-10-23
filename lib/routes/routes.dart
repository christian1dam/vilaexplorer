import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homePage/home_page.dart';
import 'package:vilaexplorer/pages/gastronomia/gastronomia_main.dart';
import 'package:vilaexplorer/pages/gastronomia/categoria_platos.dart';
import 'package:vilaexplorer/pages/gastronomia/detalle_platillo.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => MyHomePage(),
    '/gastronomia_main': (BuildContext context) => GastronomiaMain(),
    '/categoria_platos': (BuildContext context) => CategoriaPlatos(category: 'defaultCategory'),
    '/detalle_platillo': (BuildContext context) => DetallePlatillo(platillo: 'defaultPlatillo'),
  };
}