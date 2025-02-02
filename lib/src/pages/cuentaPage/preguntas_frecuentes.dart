import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/src/widgets/footer.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';
import 'cuenta_page.dart';

class PreguntasFrecuentesPage extends StatelessWidget {
  PreguntasFrecuentesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = UserPreferences();
    final preguntasFrecuentes = [
      {
        "pregunta": AppLocalizations.of(context)!.translate('how_to_recover_password'),
        "respuesta": AppLocalizations.of(context)!.translate('htrp_text'),
      },
      {
        "pregunta": AppLocalizations.of(context)!.translate('contact_support'),
        "respuesta": AppLocalizations.of(context)!.translate('cs_text'),
      },
      {
        "pregunta": AppLocalizations.of(context)!.translate('change_personal_data'),
        "respuesta": AppLocalizations.of(context)!.translate('cpd_text'),
      },
      {
        "pregunta": AppLocalizations.of(context)!.translate('use_without_internet'),
        "respuesta": AppLocalizations.of(context)!.translate('uwi_text'),
      },
      {
        "pregunta": AppLocalizations.of(context)!.translate('how_to_delete_account'),
        "respuesta": AppLocalizations.of(context)!.translate('htda_text'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CuentaPage()),
            );
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.translate('frequent_questions'),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: const Color.fromRGBO(32, 29, 29, 1),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal:16.w, vertical:16.h),
              itemCount: preguntasFrecuentes.length,
              itemBuilder: (context, index) {
                final pregunta = preguntasFrecuentes[index]["pregunta"];
                final respuesta = preguntasFrecuentes[index]["respuesta"];
                return Card(
                  color: const Color.fromARGB(255, 47, 42, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      pregunta!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal:16.w, vertical:16.h),
                        child: Text(
                          respuesta!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
