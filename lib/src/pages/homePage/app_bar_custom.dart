import 'package:flutter/material.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';  // Asegúrate de importar el archivo main.dart
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';

class AppBarCustom extends StatelessWidget {
  final Function() onMenuPressed;
  const AppBarCustom({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87.withOpacity(0),
      foregroundColor: Colors.white,
      title: Row(
        children: _contentAppBar(context), // Pasa el context a la función para poder usarlo
      ),
    );
  }

  List<Widget> _contentAppBar(BuildContext context) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 5, right: 10),
        child: Container(
          padding: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(36, 36, 36, 1),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: GestureDetector(
            onTap: onMenuPressed,
            child: Container(
              height: 54,
              width: 50,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(36, 36, 36, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Icon(
                Icons.menu,
                size: 30,
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(36, 36, 36, 1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: MySvgWidget(path: 'lib/icon/location.svg'),
                ),
                Text(
                  AppLocalizations.of(context)!.translate('villajoyosa'),
                  style: const TextStyle(
                    fontFamily: 'assets/fonts/Poppins-ExtraLight.ttf',
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Spacer(), // Para separar el tiempo del menú y ubicación
      // Contenedor redondeado para el tiempo
      Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(36, 36, 36, 1),
          borderRadius: BorderRadius.all(Radius.circular(20)),  // Redondear el borde
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: MySvgWidget(path: "lib/icon/sol_icon.svg", height: 20),
            ),
            Text(AppLocalizations.of(context)!.translate('weather_number')),
            // Aquí eliminamos el IconButton para el idioma
          ],
        ),
      ),
    ];
  }

  // Método para cambiar el idioma
  void _changeLanguage(BuildContext context, Locale locale) {
    // Llamar al método estático para cambiar el idioma sin usar setState
    MyApp.setLocale(context, locale);
  }
}
