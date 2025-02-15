import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/src/widgets/loading.dart';

class RoutesPage extends StatefulWidget {
  static const String route = 'routesPage';

  final Function? onClose;

  const RoutesPage({super.key, this.onClose});

  @override
  _RoutesPageState createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> with TickerProviderStateMixin {
  final List<String> rutasPredefinidas = [
    "Ruta A: Playa",
    "Ruta B: Montañas",
    "Ruta C: Parque natural"
  ];

  final Set<String> rutasGuardadas = {}; // Control dinámico de rutas guardadas

  void _toggleGuardarRuta(String ruta) {
    setState(() {
      if (rutasGuardadas.contains(ruta)) {
        rutasGuardadas.remove(ruta);
      } else {
        rutasGuardadas.add(ruta);
      }
    });
  }

  void _showLoadingLogo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Loading(imagePath: 'assets/images/VilaExplorer.png'),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.translate('routes'),
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.translate('predefined_route')),
              Tab(text: AppLocalizations.of(context)!.translate('saved_routes')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RutasPredefinidasTab(
              rutasPredefinidas: rutasPredefinidas,
              rutasGuardadas: rutasGuardadas,
              onToggleGuardar: _toggleGuardarRuta,
              showLoadingLogo: _showLoadingLogo,
            ),
            RutasGuardadasTab(
              rutasGuardadas: rutasGuardadas,
              onToggleGuardar: _toggleGuardarRuta,
              showLoadingLogo: _showLoadingLogo,
            ),
          ],
        ),
      ),
    );
  }
}

class RutasPredefinidasTab extends StatelessWidget {
  final List<String> rutasPredefinidas;
  final Set<String> rutasGuardadas;
  final Function(String) onToggleGuardar;
  final VoidCallback showLoadingLogo;

  const RutasPredefinidasTab({
    super.key,
    required this.rutasPredefinidas,
    required this.rutasGuardadas,
    required this.onToggleGuardar,
    required this.showLoadingLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(32, 29, 29, 1),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: ListView.builder(
        itemCount: rutasPredefinidas.length,
        itemBuilder: (context, index) {
          final ruta = rutasPredefinidas[index];
          final isGuardada = rutasGuardadas.contains(ruta);

          return Card(
            color: const Color.fromARGB(255, 47, 42, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              onTap: () {
                showLoadingLogo();
              },
              title: Text(
                ruta,
                style: const TextStyle(color: Colors.white),
              ),
              leading: const Icon(
                Icons.route,
                color: Colors.white,
              ),
              trailing: IconButton(
                icon: Icon(
                  isGuardada ? Icons.bookmark : Icons.bookmark_outline,
                  color: isGuardada ? Colors.white : Colors.grey,
                ),
                onPressed: () => onToggleGuardar(ruta),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RutasGuardadasTab extends StatelessWidget {
  final Set<String> rutasGuardadas;
  final Function(String) onToggleGuardar;
  final VoidCallback showLoadingLogo;

  const RutasGuardadasTab({
    super.key,
    required this.rutasGuardadas,
    required this.onToggleGuardar,
    required this.showLoadingLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(32, 29, 29, 1),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: rutasGuardadas.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.translate('no_saved_route'),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: rutasGuardadas.length,
              itemBuilder: (context, index) {
                final ruta = rutasGuardadas.elementAt(index);

                return Card(
                  color: const Color.fromARGB(255, 47, 42, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ListTile(
                    onTap: () {
                      showLoadingLogo();
                    },
                    title: Text(
                      ruta,
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(
                      Icons.route,
                      color: Colors.white,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark, color: Colors.white),
                      onPressed: () => onToggleGuardar(ruta),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
