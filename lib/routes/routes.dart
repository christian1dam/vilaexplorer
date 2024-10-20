import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homePage/home_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => MyHomePage()
  };
}