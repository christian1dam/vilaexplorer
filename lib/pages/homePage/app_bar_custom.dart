import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homePage/menu_principal.dart';

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
        children: _contentAppBar(),
      ),
    );
  }

  List<Widget> _contentAppBar() {
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
          padding: const EdgeInsets.all(12),
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
