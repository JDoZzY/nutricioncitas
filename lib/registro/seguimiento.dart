import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../ingresar/widgets/input_widgets.dart';
import 'laboratorios_section2.dart';

class SeguimientoScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const SeguimientoScreen({super.key, this.initialData});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreen();
}

class _SeguimientoScreen extends State<SeguimientoScreen> {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController tallaController = TextEditingController();
  final TextEditingController grasaController = TextEditingController();
  final TextEditingController masaMagraController = TextEditingController();
  final TextEditingController visceralController = TextEditingController();
  final TextEditingController masaOseaController = TextEditingController();
  final TextEditingController aguaController = TextEditingController();
  final TextEditingController edadMetabolicaController = TextEditingController();
  final TextEditingController diagnosticoNutriController = TextEditingController();
  final TextEditingController diagnosticoMedicoController = TextEditingController();

  final List<Map<String, TextEditingController>> camposLaboratorios = [
    {
      'estudio': TextEditingController(),
      'referencia': TextEditingController(),
      'resultado': TextEditingController(),
    },
  ];

  final ScrollController _scrollController = ScrollController();

  String _calcularIMC() {
    try {
      final peso = double.tryParse(pesoController.text) ?? 0;
      final talla = double.tryParse(tallaController.text) ?? 0;
      if (talla == 0) return '0';
      return (peso / ((talla / 100) * (talla / 100))).toStringAsFixed(2);
    } catch (e) {
      return '0';
    }
  }

  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _guardarConsulta() {
    _closeKeyboard();

    if (pesoController.text.isEmpty || tallaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peso y talla son campos requeridos')),
      );
      return;
    }

    final nuevoSeguimiento = {
      'peso': pesoController.text,
      'talla': tallaController.text,
      'grasa': grasaController.text,
      'masaMagra': masaMagraController.text,
      'visceral': visceralController.text,
      'masaOsea': masaOseaController.text,
      'agua': aguaController.text,
      'edadMetabolica': edadMetabolicaController.text,
      'diagnosticoNutricional': diagnosticoNutriController.text,
      'diagnosticoMedico': diagnosticoMedicoController.text,
      'laboratorios': camposLaboratorios.map((mapa) {
        return {
          'estudio': mapa['estudio']!.text,
          'referencia': mapa['referencia']!.text,
          'resultado': mapa['resultado']!.text,
        };
      }).toList(),
      'fecha': DateTime.now().toString(),
    };

    Navigator.of(context).pop(nuevoSeguimiento);
  }

  @override
  void initState() {
    super.initState();
    _cargarInitialData();
  }

  void _cargarInitialData() {
    if (widget.initialData != null) {
      pesoController.text = widget.initialData!['peso']?.toString() ?? '';
      tallaController.text = widget.initialData!['talla']?.toString() ?? '';
      grasaController.text = widget.initialData!['grasa']?.toString() ?? '';
      masaMagraController.text = widget.initialData!['masaMagra']?.toString() ?? '';
      visceralController.text = widget.initialData!['visceral']?.toString() ?? '';
      masaOseaController.text = widget.initialData!['masaOsea']?.toString() ?? '';
      aguaController.text = widget.initialData!['agua']?.toString() ?? '';
      edadMetabolicaController.text = widget.initialData!['edadMetabolica']?.toString() ?? '';
      diagnosticoNutriController.text = widget.initialData!['diagnosticoNutricional']?.toString() ?? '';
      diagnosticoMedicoController.text = widget.initialData!['diagnosticoMedico']?.toString() ?? '';

      if (widget.initialData!['laboratorios'] != null) {
        final List<dynamic> labs = widget.initialData!['laboratorios'] as List;
        camposLaboratorios.clear();

        for (var lab in labs) {
          camposLaboratorios.add({
            'estudio': TextEditingController(text: lab['estudio']?.toString() ?? ''),
            'referencia': TextEditingController(text: lab['referencia']?.toString() ?? ''),
            'resultado': TextEditingController(text: lab['resultado']?.toString() ?? ''),
          });
        }
      }

      if (camposLaboratorios.isEmpty) {
        camposLaboratorios.add({
          'estudio': TextEditingController(),
          'referencia': TextEditingController(),
          'resultado': TextEditingController(),
        });
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _closeKeyboard,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Container(height: MediaQuery.of(context).padding.top, color: const Color(0xFF036666)),
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF248277), Color(0xFF036666)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 4,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Agregar Registro',
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Datos Antropométricos',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInputRow(
                          label1: 'Peso (Kg)',
                          label2: 'Talla (Cm)',
                          child1: InputWidgets.buildNumericInput(pesoController, Icons.monitor_weight),
                          child2: InputWidgets.buildNumericInput(tallaController, Icons.height),
                        ),
                        const SizedBox(height: 8),
                        _buildInputRow(
                          label1: 'IMC',
                          label2: '% Grasa',
                          child1: InputWidgets.buildNumericInput(
                            TextEditingController(text: _calcularIMC()),
                            Icons.calculate,
                            readOnly: true,
                          ),
                          child2: InputWidgets.buildNumericInput(grasaController, Icons.pie_chart),
                        ),
                        const SizedBox(height: 8),
                        _buildInputRow(
                          label1: '% Masa Magra',
                          label2: '% Visceral',
                          child1: InputWidgets.buildNumericInput(masaMagraController, Icons.fitness_center),
                          child2: InputWidgets.buildNumericInput(visceralController, Icons.insights),
                        ),
                        const SizedBox(height: 8),
                        _buildInputRow(
                          label1: '% Masa Ósea',
                          label2: '% Agua',
                          child1: InputWidgets.buildNumericInput(masaOseaController, FontAwesomeIcons.bone),
                          child2: InputWidgets.buildNumericInput(aguaController, Icons.water_drop),
                        ),
                        const SizedBox(height: 8),
                        _buildLabelInput(
                          'Edad Metabólica',
                          InputWidgets.buildNumericInput(edadMetabolicaController, Icons.timeline),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Diagnósticos',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildLabelInput(
                          'Diagnóstico Nutricional',
                          InputWidgets.buildInputField(diagnosticoNutriController, Icons.apple),
                        ),
                        const SizedBox(height: 8),
                        _buildLabelInput(
                          'Diagnóstico Médico',
                          InputWidgets.buildInputField(diagnosticoMedicoController, Icons.healing),
                        ),
                        const SizedBox(height: 8),
                        LaboratoriosSection(
                          campos: camposLaboratorios,
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: ElevatedButton(
                            onPressed: _guardarConsulta,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF248277),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Guardar Registro', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required String label1,
    required String label2,
    required Widget child1,
    required Widget child2,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Expanded(child: Text(label1)), SizedBox(width: 16), Expanded(child: Text(label2))]),
        const SizedBox(height: 4),
        Row(children: [Expanded(child: child1), const SizedBox(width: 16), Expanded(child: child2)]),
      ],
    );
  }

  Widget _buildLabelInput(String label, Widget input) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        input,
      ],
    );
  }
}