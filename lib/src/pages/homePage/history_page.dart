import 'dart:async';
import 'package:flutter/material.dart';

class HistoriaScreen extends StatefulWidget {
  final List<Map<String, String>> historias; // Cambiamos a una lista de historias
  final int initialIndex; // Índice inicial

  const HistoriaScreen({
    super.key,
    required this.historias,
    required this.initialIndex,
  });

  @override
  _HistoriaScreenState createState() => _HistoriaScreenState();
}

class _HistoriaScreenState extends State<HistoriaScreen>
    with SingleTickerProviderStateMixin {
  double progress = 0.0;
  late Timer _timer;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _startProgress();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _startProgress() {
    const duration = Duration(milliseconds: 100);
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        progress += 0.01;
        if (progress >= 1.0) {
          _timer.cancel();
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            // Swipe a la derecha
            if (widget.initialIndex > 0) {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            }
          } else if (details.delta.dx < 0) {
            // Swipe a la izquierda
            if (widget.initialIndex < widget.historias.length - 1) {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            }
          }
        },
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0) {
            // Swipe hacia abajo
            Navigator.of(context).pop();
          }
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.historias.length,
          itemBuilder: (context, index) {
            final historia = widget.historias[index];
            return _buildHistoriaPage(historia);
          },
        ),
      ),
    );
  }

  Widget _buildHistoriaPage(Map<String, String> historia) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(historia["imageUrl"]!, fit: BoxFit.cover),
        ),
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
        Positioned(
          top: 40,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: 50, // Ajuste de espacio debajo de la barra de progreso
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                historia["title"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                historia["subtitle"]!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 50, // Ajusta esta posición según sea necesario
          left: MediaQuery.of(context).size.width / 2 - 100, // Centrar horizontalmente
          child: Column(
            children: [
              const Text(
                "Deslizar para conocer la ruta",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
