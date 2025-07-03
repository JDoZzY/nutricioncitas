import 'package:flutter/material.dart';

class MacronutrientesTable extends StatelessWidget {
  final double carbohidratosPorc;
  final double proteinasPorc;
  final double grasasPorc;
  final double carbohidratosKcal;
  final double proteinasKcal;
  final double grasasKcal;
  final double carbohidratosG;
  final double proteinasG;
  final double grasasG;
  final double carbohidratosGkg;
  final double proteinasGkg;
  final double grasasGkg;
  final Function(double) onCarbohidratosChanged;
  final Function(double) onProteinasChanged;
  final Function(double) onGrasasChanged;
  final Color borderColor;

  const MacronutrientesTable({
    super.key,
    required this.carbohidratosPorc,
    required this.proteinasPorc,
    required this.grasasPorc,
    required this.carbohidratosKcal,
    required this.proteinasKcal,
    required this.grasasKcal,
    required this.carbohidratosG,
    required this.proteinasG,
    required this.grasasG,
    required this.carbohidratosGkg,
    required this.proteinasGkg,
    required this.grasasGkg,
    required this.onCarbohidratosChanged,
    required this.onProteinasChanged,
    required this.onGrasasChanged,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final totalPorcentaje = carbohidratosPorc + proteinasPorc + grasasPorc;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Distribución de Macronutrientes',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Table(
            border: TableBorder.all(color: Colors.black),
            columnWidths: const {
              0: FlexColumnWidth(1.8),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1.3),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: Color(0xFF036666)),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Macros',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '%',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Kcal',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'g',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'g/kg/día',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              _buildMacronutrienteRow(
                'Carbohidratos',
                carbohidratosPorc,
                carbohidratosKcal,
                carbohidratosG,
                carbohidratosGkg,
                onCarbohidratosChanged,
              ),
              _buildMacronutrienteRow(
                'Proteínas',
                proteinasPorc,
                proteinasKcal,
                proteinasG,
                proteinasGkg,
                onProteinasChanged,
              ),
              _buildMacronutrienteRow(
                'Grasas',
                grasasPorc,
                grasasKcal,
                grasasG,
                grasasGkg,
                onGrasasChanged,
              ),
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '${totalPorcentaje.toStringAsFixed(0)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      (carbohidratosKcal + proteinasKcal + grasasKcal).toStringAsFixed(2),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('', textAlign: TextAlign.center),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('', textAlign: TextAlign.center),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  TableRow _buildMacronutrienteRow(
      String nombre,
      double porcentaje,
      double kcal,
      double gramos,
      double gramosKg,
      Function(double) onChanged,
      ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(nombre, textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextFormField(
            initialValue: porcentaje == 0 ? '' : porcentaje.toStringAsFixed(0),
            decoration: const InputDecoration(
              hintText: '0%',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            ),
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final newValue = double.tryParse(value) ?? 0;
              onChanged(newValue);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(kcal.toStringAsFixed(2), textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(gramos.toStringAsFixed(2), textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(gramosKg.toStringAsFixed(2), textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
