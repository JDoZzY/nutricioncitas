import 'package:flutter/material.dart';
import 'macronutrientes_table.dart';
import 'datos_formulario.dart';

class OpcionEnteral extends StatefulWidget {
  const OpcionEnteral({super.key});

  @override
  State<OpcionEnteral> createState() => _OpcionEnteralState();
}

class _OpcionEnteralState extends State<OpcionEnteral> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _kcalController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final borderColor = const Color(0xFF036666);
  final ValueNotifier<Map<String, double>> macronutrientesNotifier = ValueNotifier({
    'kcalTotal': 0,
    'carbohidratosRef': 0,
    'proteinasRef': 0,
    'grasasRef': 0,
  });

  double carbohidratosPorc = 0;
  double proteinasPorc = 0;
  double grasasPorc = 0;

  double carbohidratosKcal = 0;
  double proteinasKcal = 0;
  double grasasKcal = 0;
  double carbohidratosG = 0;
  double proteinasG = 0;
  double grasasG = 0;
  double carbohidratosGkg = 0;
  double proteinasGkg = 0;
  double grasasGkg = 0;

  @override
  void initState() {
    super.initState();
    _pesoController.addListener(_calcularTodo);
    _kcalController.addListener(_calcularTodo);
    _totalController.addListener(_calcularMacronutrientes);
  }

  void _calcularTodo() {
    if (_pesoController.text.isNotEmpty && _kcalController.text.isNotEmpty) {
      final peso = double.tryParse(_pesoController.text) ?? 0;
      final kcal = double.tryParse(_kcalController.text) ?? 0;
      final total = peso * kcal;
      _totalController.text = total.toStringAsFixed(2);
      _calcularMacronutrientes();
    } else {
      _totalController.clear();
      _limpiarResultados();
    }
  }

  void _calcularMacronutrientes() {
    if (_totalController.text.isNotEmpty && _pesoController.text.isNotEmpty) {
      final totalKcal = double.tryParse(_totalController.text) ?? 0;
      final peso = double.tryParse(_pesoController.text) ?? 1;

      setState(() {
        carbohidratosKcal = totalKcal * carbohidratosPorc / 100;
        proteinasKcal = totalKcal * proteinasPorc / 100;
        grasasKcal = totalKcal * grasasPorc / 100;

        carbohidratosG = carbohidratosKcal / 4;
        proteinasG = proteinasKcal / 4;
        grasasG = grasasKcal / 9;

        carbohidratosGkg = carbohidratosG / peso;
        proteinasGkg = proteinasG / peso;
        grasasGkg = grasasG / peso;
      });

      macronutrientesNotifier.value = {
        'kcalTotal': totalKcal,
        'carbohidratosRef': carbohidratosG,
        'proteinasRef': proteinasG,
        'grasasRef': grasasG,
      };
    } else {
      _limpiarResultados();
      macronutrientesNotifier.value = {
        'kcalTotal': 0,
        'carbohidratosRef': 0,
        'proteinasRef': 0,
        'grasasRef': 0,
      };
    }
  }

  void _limpiarResultados() {
    setState(() {
      carbohidratosKcal = 0;
      proteinasKcal = 0;
      grasasKcal = 0;
      carbohidratosG = 0;
      proteinasG = 0;
      grasasG = 0;
      carbohidratosGkg = 0;
      proteinasGkg = 0;
      grasasGkg = 0;
    });
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _kcalController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DatosFormulario(
              pesoController: _pesoController,
              kcalController: _kcalController,
              totalController: _totalController,
              borderColor: borderColor,
            ),
            const SizedBox(height: 10),
            MacronutrientesTable(
              carbohidratosPorc: carbohidratosPorc,
              proteinasPorc: proteinasPorc,
              grasasPorc: grasasPorc,
              carbohidratosKcal: carbohidratosKcal,
              proteinasKcal: proteinasKcal,
              grasasKcal: grasasKcal,
              carbohidratosG: carbohidratosG,
              proteinasG: proteinasG,
              grasasG: grasasG,
              carbohidratosGkg: carbohidratosGkg,
              proteinasGkg: proteinasGkg,
              grasasGkg: grasasGkg,
              onCarbohidratosChanged: (value) {
                setState(() {
                  carbohidratosPorc = value;
                  _calcularMacronutrientes();
                });
              },
              onProteinasChanged: (value) {
                setState(() {
                  proteinasPorc = value;
                  _calcularMacronutrientes();
                });
              },
              onGrasasChanged: (value) {
                setState(() {
                  grasasPorc = value;
                  _calcularMacronutrientes();
                });
              },
              borderColor: borderColor,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
