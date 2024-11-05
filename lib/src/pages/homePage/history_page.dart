import 'dart:async';
import 'package:flutter/material.dart';

class HistoriaScreen extends StatefulWidget {
  final String imageUrl;

  const HistoriaScreen({super.key, required this.imageUrl});

  @override
  _HistoriaScreenState createState() => _HistoriaScreenState();
}

class _HistoriaScreenState extends State<HistoriaScreen> {
  double progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    const duration = Duration(milliseconds: 100); // Actualiza cada 100 ms
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        progress += 0.01;
        if (progress >= 1.0) {
          _timer.cancel();
          Navigator.of(context).pop(); // Cierra la historia cuando se completa
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),
          // Barra de progreso en la parte superior
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          // Botón para cerrar
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
