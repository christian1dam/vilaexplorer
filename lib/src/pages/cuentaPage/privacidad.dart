import 'package:flutter/material.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/src/widgets/footer.dart'; // Si estás usando traducciones

class PrivacidadPage extends StatelessWidget {
  const PrivacidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 29, 29, 1), // Fondo oscuro
        title: Text(
          AppLocalizations.of(context)!.translate('privacy_policy'), // Título de la página
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
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
        color: const Color.fromRGBO(32, 29, 29, 1), // Fondo oscuro en toda la página
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('privacy_title'), // Título de la política de privacidad
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Título en blanco
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.translate('privacy_subtitle'), // Subtítulo
                      style: const TextStyle(fontSize: 16, color: Colors.white70), // Texto en gris claro
                    ),
                    const SizedBox(height: 20),
                    // Aquí puedes agregar el contenido de la política de privacidad
                    Text(
                      AppLocalizations.of(context)!.translate('privacy_content'), // Contenido de la política de privacidad
                      style: const TextStyle(fontSize: 16, color: Colors.white70), // Texto en gris claro
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica cuando el usuario acepta la política de privacidad
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
            const Footer(),
          ],
        ),
      ),
    );
  }
}
