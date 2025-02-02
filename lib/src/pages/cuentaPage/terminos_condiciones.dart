import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/src/widgets/footer.dart';

class TerminosCondicionesPage extends StatelessWidget {
  const TerminosCondicionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 29, 29, 1), // Fondo oscuro
        title: Text(
          AppLocalizations.of(context)!.translate('terms_conditions'), // Título de la página
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Título en blanco
            
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Flecha blanca
          onPressed: () {
            Navigator.of(context).pop(); // Regresar a la pantalla anterior
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(32, 29, 29, 1), // Fondo oscuro en la página
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:16.w, vertical:16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('terms_title'), // Título de los términos
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Título en blanco
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.translate('terms_subtitle'), // Subtítulo
                        style: const TextStyle(fontSize: 16, color: Colors.white70), // Texto en gris claro
                      ),
                      const SizedBox(height: 20),
                      // Aquí puedes agregar el contenido de los términos y condiciones
                      Text(
                        AppLocalizations.of(context)!.translate('terms_content'), // Contenido de los términos
                        style: const TextStyle(fontSize: 16, color: Colors.white70), // Texto en gris claro
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            // Lógica cuando el usuario acepta los términos
                            Navigator.of(context).pop(); // Cierra la página y regresa a la anterior
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.translate('accept'), // Texto del botón
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Aquí llamamos al Footer() para que esté al final de la página
            const Footer(),
          ],
        ),
      ),
    );
  }
}


