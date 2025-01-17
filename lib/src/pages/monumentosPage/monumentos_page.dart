import 'package:flutter/material.dart';
import 'package:vilaexplorer/service/monumentos_service.dart';
import 'package:provider/provider.dart';

class MonumentosPage extends StatefulWidget {
  final VoidCallback onClose;

  const MonumentosPage({super.key, required this.onClose});

  @override
  _MonumentosPageState createState() => _MonumentosPageState();
}

class _MonumentosPageState extends State<MonumentosPage> {
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Llamar a getAllMonumentos para cargar los monumentos inicialmente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MonumentosService>().getAllMonumentos();
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearchActive = !isSearchActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final monumentosService = context.watch<MonumentosService>(); // Usamos el servicio directamente

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.80,
                width: MediaQuery.of(context).size.width,
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
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: _toggleSearch,
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(30, 30, 30, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                margin: const EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 35,
                                child: Center(
                                  child: Text(
                                    'Monumentos',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: widget.onClose,
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                      indent: 25,
                      endIndent: 25,
                    ),
                    if (isSearchActive)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (query) {
                            monumentosService.searchMonumentos(query);
                          },
                          decoration: InputDecoration(
                            hintText: 'Buscar monumentos...',
                            hintStyle: const TextStyle(color: Colors.white54),
                            fillColor: const Color.fromARGB(255, 47, 42, 42),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          ),
                        ),
                      ),
                    Expanded(
                      child: monumentosService.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : monumentosService.error != null
                              ? Center(child: Text(monumentosService.error!, style: const TextStyle(color: Colors.white)))
                              : monumentosService.todosLosMonumentos == null ||
                                      monumentosService.todosLosMonumentos!.isEmpty
                                  ? const Center(
                                      child: Text(
                                        "No se encontraron monumentos",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: monumentosService.todosLosMonumentos?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        final monumento = monumentosService.todosLosMonumentos?[index];
                                        return ListTile(
                                          title: Text(
                                            monumento?.nombreLugar ?? '',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            // Aquí puedes agregar la lógica para ver los detalles de un monumento si lo deseas
                                          },
                                        );
                                      },
                                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
