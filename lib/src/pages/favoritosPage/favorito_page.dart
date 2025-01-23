import 'package:flutter/material.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';

class FavoritosPage extends StatefulWidget {
  final Function onClose;

  const FavoritosPage({super.key, required this.onClose});

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              if (isSearchActive) {
                setState(() {
                  isSearchActive = false;
                  searchController.clear();
                });
              }
            },
            child: Container(
              height: size.height * 0.65,
              width: size.width,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(32, 29, 29, 0.9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Barra de estilo iOS
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: 100,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: _toggleSearch,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          width: size.width * 0.50,
                          height: 35,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate('favorites'),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            widget.onClose();
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isSearchActive)
                  
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.translate('search_favorites'),
                          hintStyle: TextStyle(color: Colors.white54),
                          fillColor: Color.fromARGB(255, 47, 42, 42),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        ),
                      ),
                    ),
                    
                  if (isSearchActive)
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 10),
                      children: [
                        // Primera lista desplegable
                        ExpansionTile(
                          title: Text(
                            AppLocalizations.of(context)!.translate('monuments_place'),
                            style: TextStyle(color: Colors.white),
                          ),
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          children: const [
                            ListTile(
                              title: Text(
                                'Lugar 1',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Lugar 2',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Lugar 3',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            AppLocalizations.of(context)!.translate('gastronomy'),
                            style: TextStyle(color: Colors.white),
                          ),
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          children: const [
                            ListTile(
                              title: Text(
                                'Restaurante 1',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Restaurante 2',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Restaurante 3',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            AppLocalizations.of(context)!.translate('traditions'),
                            style: TextStyle(color: Colors.white),
                          ),
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          children: const [
                            ListTile(
                              title: Text(
                                'Tradición 1',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Tradición 2',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Tradición 3',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    setState(() {
      MyApp.setLocale(context, locale);
    });
  }

  SizedBox MyBotonText(String texto) {
    return SizedBox(
      width: 117,
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            const Color.fromRGBO(45, 45, 45, 1),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
