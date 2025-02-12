import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';

class HistoriaScreen extends StatefulWidget {
  final List<Map<String, String>> historias;
  final int initialIndex;

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
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  late int currentIndex;
  ValueNotifier<double> progressNotifier = ValueNotifier(0.0); // Usamos ValueNotifier

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _startProgress();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 5).animate(_controller);
  }

  void _startProgress() {
    const duration = Duration(milliseconds: 101);
    _timer = Timer.periodic(duration, (timer) {
      progressNotifier.value += 0.01;
      if (progressNotifier.value >= 1.0) {
        _timer.cancel();
        _showNextStory();
      }
    });
  }

  void _resetProgress() {
    progressNotifier.value = 0.0;
    _startProgress();
  }

  void _showNextStory() {
    setState(() {
      if (currentIndex < widget.historias.length - 1) {
        currentIndex++;
      } else {
        Navigator.of(context).pop();
      }
    });
    _resetProgress();
  }

  void _showPreviousStory() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _resetProgress();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    progressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historia = widget.historias[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _showNextStory();
          } else if (details.primaryVelocity! > 0) {
            _showPreviousStory();
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(historia["imageUrl"]!, fit: BoxFit.cover),
            ),
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: ValueListenableBuilder<double>(
                valueListenable: progressNotifier,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                },
              ),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 28, 28, 28), // Fondo circular en #FF414141
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFD3D3D3)), // X en gris claro
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Positioned(
              top: 50,
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
              bottom: 50,
              left: MediaQuery.sizeOf(context).width / 2 - 100,
              child: Column(
                children: [
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
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.translate('swipe_route'),
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
      ),
    );
  }
}
