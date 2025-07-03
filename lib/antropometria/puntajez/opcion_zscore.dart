import 'package:flutter/material.dart';

class OpcionZScore extends StatelessWidget {
  const OpcionZScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 6),
          child: Center(
            child: Text(
              'Puntaje Z',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        Text(
          'Ingrese los datos para calcular el puntaje Z.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
