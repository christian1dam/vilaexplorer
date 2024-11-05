import 'dart:async';
import 'package:flutter/material.dart';

class HistoriaScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const HistoriaScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  _HistoriaScreenState createState() => _HistoriaScreenState();
}

class _HistoriaScreenState extends State<HistoriaScreen>
    with SingleTickerProviderStateMixin {
  double progress = 0.0;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _startProgress();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 10).animate(_controller);
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(widget.imageUrl, fit: BoxFit.cover),
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
          // Título y subtítulo en la parte superior izquierda
          Positioned(
            top: 50, // Ajuste de espacio debajo de la barra de progreso
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 3),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Flecha y texto en la parte baja
          Positioned(
            bottom: 50, // Ajusta esta posición según sea necesario
            left: MediaQuery.of(context).size.width / 2 - 100, // Centrar horizontalmente
            child: Column(
              children: [
                // Flecha animada
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 40,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8), // Espacio entre la flecha y el texto
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
      ),
    );
  }
}