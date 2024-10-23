import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homePage/menu_principal.dart';

class AppBarCustom extends StatelessWidget {
  final Function() onMenuPressed;
  const AppBarCustom({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black87.withOpacity(0),
      foregroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: _contentAppBar(),
        ),
      ),
    );
  }

  List<Widget> _contentAppBar() {
    return <Widget>[
      Padding(
          padding: const EdgeInsets.only(left: 5, right: 10),
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(36, 36, 36, 1),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                size: 35,
              ),
              onPressed: onMenuPressed,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(right: 80),
        child: Container(
            padding: EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(36, 36, 36, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: MySvgWidget(path: 'lib/icon/location.svg'),
                  ),
                  Text("Villajoyosa"),
                ],
              ),
            )),
      ),
      Container(
        padding: EdgeInsets.all(7),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(36, 36, 36, 1),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: MySvgWidget(path: "lib/icon/sol_icon.svg", height: 20),
              ),
              Text("+2"),
            ],
          )),
    ];
  }
}
