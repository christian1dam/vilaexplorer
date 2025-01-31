import 'package:flutter/material.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'VILA ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  TextSpan(
                    text: 'Explorer',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // Espacio entre los dos textos
            Text(
              '© 2025 ${AppLocalizations.of(context)!.translate('all_rights_reserved')}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7), // Color de texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
