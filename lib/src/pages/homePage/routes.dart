import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/src/widgets/loading.dart';

class RoutesPage extends StatefulWidget {
  static const String route = 'routesPage';

  final Function? onClose;

  const RoutesPage({super.key, this.onClose});

  @override
  _RoutesPageState createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> with TickerProviderStateMixin {
  List<String> rutasGuardadas = [
    "Ruta 1: Centro histórico",
    "Ruta 2: Sendero ecológico",
    "Ruta 3: Paseo gastronómico"
  ];

  List<String> rutasPredefinidas = [
    "Ruta A: Playa",
    "Ruta B: Montañas",
    "Ruta C: Parque natural"
  ];

  void _eliminarRuta(int index) {
    setState(() {
      rutasGuardadas.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ruta eliminada correctamente.')),
    );
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
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Rutas",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white, // Línea de selección blanca
            labelColor: Colors.white, // Color del texto seleccionado
            unselectedLabelColor:
                Colors.grey, // Color del texto no seleccionado
            tabs: const [
              Tab(text: "Rutas Predefinidas"),
              Tab(text: "Rutas Guardadas"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RutasPredefinidasTab(showLoadingLogo: _showLoadingLogo),
            RutasGuardadasTab(showLoadingLogo: _showLoadingLogo),
          ],
        ),
      ),
    );
  }
}

class RutasPredefinidasTab extends StatelessWidget {
  final List<String> rutasPredefinidas = [
    "Ruta A: Playa",
    "Ruta B: Montañas",
    "Ruta C: Parque natural"
  ];
  final VoidCallback showLoadingLogo;

  RutasPredefinidasTab({super.key, required this.showLoadingLogo});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(32, 29, 29, 1),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: ListView.builder(
        itemCount: rutasPredefinidas.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color.fromARGB(255, 47, 42, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              onTap: () {
                showLoadingLogo();
                // Redirigir a mapa y marcar ruta
              },
              title: Text(
                rutasPredefinidas[index],
                style: const TextStyle(color: Colors.white),
              ),
              leading: const Icon(
                Icons.route,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

class RutasGuardadasTab extends StatefulWidget {
  final VoidCallback showLoadingLogo;

  const RutasGuardadasTab({super.key, required this.showLoadingLogo});

  @override
  _RutasGuardadasTabState createState() => _RutasGuardadasTabState();
}

class _RutasGuardadasTabState extends State<RutasGuardadasTab> {
  List<String> rutasGuardadas = [
    "Ruta 1: Centro histórico",
    "Ruta 2: Sendero ecológico",
    "Ruta 3: Paseo gastronómico"
  ];

  void _eliminarRuta(int index) {
    setState(() {
      rutasGuardadas.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ruta eliminada correctamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(32, 29, 29, 1),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: rutasGuardadas.isEmpty
          ? const Center(
              child: Text(
                "No tienes rutas guardadas.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: rutasGuardadas.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(rutasGuardadas[index]),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) => _eliminarRuta(index),
                  child: Card(
                    color: const Color.fromARGB(255, 47, 42, 42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ListTile(
                      onTap: () {
                        widget.showLoadingLogo();
                        // Redirigir a mapa y marcar ruta
                      },
                      title: Text(
                        rutasGuardadas[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                      leading: const Icon(
                        Icons.route,
                        color: Colors.white,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarRuta(index),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
