import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget {
  final Function() onMenuPressed;
  const AppBarCustom({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black87.withOpacity(0),
      foregroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
            color: Colors.black45.withOpacity(0.7),
            borderRadius: BorderRadius.circular(5)),
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
          child: IconButton(
            icon: const Icon(
              Icons.menu,
              size: 35,
            ),
            onPressed: onMenuPressed,
          )),
      const Padding(
        padding: EdgeInsets.only(right: 140),
        child: Text("Villajoyosa"),
      ),
      const Padding(
        padding: EdgeInsets.only(right: 7),
        child: Icon(Icons.cloud),
      ),
      const Padding(
        padding: EdgeInsets.only(right: 5),
        child: Text("+2"),
      )
    ];
  }
}
