import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homePage/home_page.dart';

import 'package:vilaexplorer/pages/gastronomia/categoria_platos.dart';
import 'package:vilaexplorer/pages/gastronomia/detalle_platillo.dart';
import 'package:vilaexplorer/pages/gastronomia/gastronomia_main.dart';


Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => MyHomePage(),

    '/gastronomiaMain': (BuildContext context) => GastronomiaMain(),
    '/categoriaPlatos': (BuildContext context) => CategoriaPlatos(),
    '/detallePlatillo': (BuildContext context) => DetallePlatillo(),
  };
}