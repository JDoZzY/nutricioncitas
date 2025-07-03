import 'package:flutter/material.dart';

class OpcionEstimarPeso extends StatefulWidget {
  const OpcionEstimarPeso({super.key});

  @override
  State<OpcionEstimarPeso> createState() => _OpcionEstimarPesoState();
}

class _OpcionEstimarPesoState extends State<OpcionEstimarPeso> {
  String? selectedSexo;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF036666);

    Widget sexoButton(String label, Color color) {
      final isSelected = selectedSexo == label;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedSexo = label;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isSelected ? 1.0 : 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: isSelected ? 1 : 1),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }

    BoxDecoration inputBoxDecoration() {
      return BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFF9AD0C2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(2, 4),
                  blurRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Estimar Peso',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Selecciona los datos para realizar la estimación.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Datos',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Selecciona el Sexo',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              sexoButton('Masculino', const Color(0xFF70d6ff)),
              const SizedBox(width: 8),
              sexoButton('Femenino', const Color(0xFFff70a6)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Edad',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: inputBoxDecoration(),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ingresa la edad',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Altura de Rodilla',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: inputBoxDecoration(),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ingresa en Cm',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Talla Real',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: inputBoxDecoration(),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ingresa en Cm',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF036666),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {
              },
              child: const Text(
                'Calcular',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
