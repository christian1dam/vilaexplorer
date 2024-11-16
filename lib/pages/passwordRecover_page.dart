import 'package:flutter/material.dart';
import 'dart:async'; // Importar para el temporizador

class PasswordRecoverPage extends StatefulWidget {
  const PasswordRecoverPage({Key? key}) : super(key: key);

  @override
  _PasswordRecoverPageState createState() => _PasswordRecoverPageState();
}

class _PasswordRecoverPageState extends State<PasswordRecoverPage> {
  bool _isButtonEnabled = true; // Estado del botón
  int _counter = 60; // Contador inicial
  Timer? _timer; // Temporizador

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el temporizador si la página se cierra
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isButtonEnabled = false; // Deshabilitar el botón al iniciar el temporizador
    });
    _counter = 60; // Reiniciar el contador

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer!.cancel();
        setState(() {
          _isButtonEnabled = true; // Habilitar el botón después de 60 segundos
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54, // Fondo semitransparente
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Cerrar la página si se toca fuera del cuadro
            Navigator.of(context).pop();
          },
          child: Stack(
            alignment: Alignment.topRight, // Alinear contenido en la parte superior derecha
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 28, 28, 28),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40), // Espacio superior para la X
                      const Text(
                        'Introduce tu correo electrónico',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Correo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isButtonEnabled
                            ? () {
                                // Aquí puedes agregar lógica para enviar el correo
                                _startTimer(); // Iniciar el temporizador
                              }
                            : null, // Deshabilitar el botón si no se puede enviar
                        child: const Text('Enviar'),
                      ),
                      const SizedBox(height: 20),
                      if (!_isButtonEnabled) // Mostrar el contador solo si el botón está deshabilitado
                        Text(
                          'Por favor, espera $_counter segundos.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 40,
                top: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar la página
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
