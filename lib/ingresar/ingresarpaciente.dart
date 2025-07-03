import 'package:flutter/material.dart';
import 'package:hospcalc/ingresar/widgets/calendario_widget.dart';
import 'package:hospcalc/ingresar/widgets/input_widgets.dart';
import 'package:intl/intl.dart';
import '../registro/registro.dart';
import 'date_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'laboratorios_section.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IngresarPacientes extends StatefulWidget {
  const IngresarPacientes({super.key});

  @override
  State<IngresarPacientes> createState() => _IngresarPacientesState();
}

class _IngresarPacientesState extends State<IngresarPacientes> {
  final fechaController = TextEditingController();
  final edadController = TextEditingController();
  final pesoController = TextEditingController();
  final tallaController = TextEditingController();
  final grasaController = TextEditingController();
  final masaMagraController = TextEditingController();
  final visceralController = TextEditingController();
  final masaOseaController = TextEditingController();
  final aguaController = TextEditingController();
  final edadMetabolicaController = TextEditingController();
  final nombreController = TextEditingController();
  final origenController = TextEditingController();
  final diagnosticoNutriController = TextEditingController();
  final diagnosticoMedicoController = TextEditingController();

  final camposLaboratorios = [{
    'estudio': TextEditingController(),
    'referencia': TextEditingController(),
    'resultado': TextEditingController(),
  }];

  final _scrollController = ScrollController();
  final _primaryColor = const Color(0xFF036666);
  final _secondaryColor = const Color(0xFF248277);

  @override
  void initState() {
    super.initState();
    _cargarDatosLaboratorio();
  }

  @override
  void dispose() {
    _disposeControllers();
    _scrollController.dispose();
    super.dispose();
  }

  void _disposeControllers() {
    fechaController.dispose();
    edadController.dispose();
    pesoController.dispose();
    tallaController.dispose();
    grasaController.dispose();
    masaMagraController.dispose();
    visceralController.dispose();
    masaOseaController.dispose();
    aguaController.dispose();
    edadMetabolicaController.dispose();
    nombreController.dispose();
    origenController.dispose();
    diagnosticoNutriController.dispose();
    diagnosticoMedicoController.dispose();
    for (var lab in camposLaboratorios) {
      lab['estudio']?.dispose();
      lab['referencia']?.dispose();
      lab['resultado']?.dispose();
    }
  }

  String _calcularEdad(DateTime fechaNacimiento) {
    final hoy = DateTime.now();
    int anios = hoy.year - fechaNacimiento.year;
    int meses = hoy.month - fechaNacimiento.month;

    if (meses < 0 || (meses == 0 && hoy.day < fechaNacimiento.day)) {
      anios--;
      meses += 12;
    }
    if (hoy.day < fechaNacimiento.day) meses--;

    return '${anios}a ${meses}m';
  }

  void _closeKeyboard() => FocusScope.of(context).unfocus();

  void _mostrarSnackBarGuardado() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Consulta guardada correctamente'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _guardarConsulta() async {
    _closeKeyboard();

    final prefs = await SharedPreferences.getInstance();
    final pacientes = prefs.getStringList('pacientes') ?? [];

    pacientes.add(jsonEncode({
      'nombrePaciente': nombreController.text,
      'fechaNacimiento': fechaController.text,
      'edad': edadController.text,
      'peso': pesoController.text,
      'talla': tallaController.text,
      'grasa': grasaController.text,
      'masaMagra': masaMagraController.text,
      'visceral': visceralController.text,
      'masaOsea': masaOseaController.text,
      'agua': aguaController.text,
      'edadMetabolica': edadMetabolicaController.text,
      'origen': origenController.text,
      'diagnosticoNutricional': diagnosticoNutriController.text,
      'diagnosticoMedico': diagnosticoMedicoController.text,
      'laboratorios': camposLaboratorios.map((mapa) => {
        'estudio': mapa['estudio']!.text,
        'referencia': mapa['referencia']!.text,
        'resultado': mapa['resultado']!.text,
      }).toList(),
    }));

    await prefs.setStringList('pacientes', pacientes);
    _limpiarCampos();
    _mostrarSnackBarGuardado();
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _limpiarCampos() {
    nombreController.clear();
    fechaController.clear();
    edadController.clear();
    pesoController.clear();
    tallaController.clear();
    grasaController.clear();
    masaMagraController.clear();
    visceralController.clear();
    masaOseaController.clear();
    aguaController.clear();
    edadMetabolicaController.clear();
    origenController.clear();
    diagnosticoNutriController.clear();
    diagnosticoMedicoController.clear();

    for (var lab in camposLaboratorios) {
      lab['resultado']?.clear();
    }
  }

  Future<void> _guardarDatosLaboratorio() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lab_datos', jsonEncode(
        camposLaboratorios.map((mapa) => {
          'estudio': mapa['estudio']!.text,
          'referencia': mapa['referencia']!.text,
        }).toList()
    ));
  }

  Future<void> _cargarDatosLaboratorio() async {
    final prefs = await SharedPreferences.getInstance();
    final datosGuardados = prefs.getString('lab_datos');

    if (datosGuardados != null) {
      camposLaboratorios.clear();
      for (var elemento in (jsonDecode(datosGuardados) as List)) {
        camposLaboratorios.add({
          'estudio': TextEditingController(text: elemento['estudio']),
          'referencia': TextEditingController(text: elemento['referencia']),
          'resultado': TextEditingController(),
        });
      }
      setState(() {});
    }
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_secondaryColor, _primaryColor],
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
              'Ingresar Paciente',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.folder, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Registro()),
              ),
            ),
          ),
        ],
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

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
      ),
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

  Widget _buildDateInput() {
    return Stack(
      children: [
        TextField(
          controller: fechaController,
          keyboardType: TextInputType.datetime,
          inputFormatters: [DateInputFormatter()],
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.teal),
              onPressed: () async {
                final selectedDate = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CalendarioWidget(
                    fechaActual: fechaController.text.isNotEmpty
                        ? DateFormat('dd-MM-yyyy').parse(fechaController.text)
                        : DateTime.now(),
                    onFechaSeleccionada: (fecha) => Navigator.of(context).pop(fecha),
                  ),
                );
                if (selectedDate != null) {
                  setState(() {
                    fechaController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
                    edadController.text = _calcularEdad(selectedDate);
                  });
                }
              },
            ),
            contentPadding: const EdgeInsets.all(8),
            filled: true,
            fillColor: Colors.white.withAlpha(200),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: _secondaryColor),
                borderRadius: BorderRadius.circular(8)),
            hintText: 'dd-mm-aaaa',
          ),
          onChanged: (value) {
            if (value.length == 10) {
              try {
                final date = DateFormat('dd-MM-yyyy').parseStrict(value);
                setState(() => edadController.text = _calcularEdad(date));
              } catch (e) {
                setState(() => edadController.text = '');
              }
            } else {
              setState(() => edadController.text = '');
            }
          },
        ),
      ],
    );
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
                Container(height: MediaQuery.of(context).padding.top, color: _primaryColor),
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Datos Personales'),
                        const SizedBox(height: 8),
                        _buildLabelInput(
                          'Nombre del Paciente',
                          InputWidgets.buildInputField(nombreController, Icons.person),
                        ),
                        const SizedBox(height: 8),
                        _buildInputRow(
                          label1: 'Fecha de Nacimiento',
                          label2: 'Edad',
                          child1: _buildDateInput(),
                          child2: InputWidgets.buildNumericInput(edadController, Icons.cake, readOnly: true),
                        ),
                        const SizedBox(height: 8),
                        _buildLabelInput(
                          'Lugar de Origen',
                          InputWidgets.buildInputField(origenController, Icons.location_on),
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
                          label1: '% Grasa',
                          label2: '% Masa Magra',
                          child1: InputWidgets.buildNumericInput(grasaController, Icons.pie_chart),
                          child2: InputWidgets.buildNumericInput(masaMagraController, Icons.accessibility_new),
                        ),
                        const SizedBox(height: 8),
                        _buildInputRow(
                          label1: '% Visceral',
                          label2: '% Masa Ósea',
                          child1: InputWidgets.buildNumericInput(visceralController, Icons.insights),
                          child2: InputWidgets.buildNumericInput(masaOseaController, FontAwesomeIcons.bone),
                        ),
                        const SizedBox(height: 8),
                        _buildInputRow(
                          label1: '% Agua',
                          label2: 'Edad Metabólica',
                          child1: InputWidgets.buildNumericInput(aguaController, Icons.water_drop),
                          child2: InputWidgets.buildNumericInput(edadMetabolicaController, Icons.timeline),
                        ),
                        const SizedBox(height: 8),
                        _buildSectionTitle('Diagnosticos'),
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
                          onSave: _guardarDatosLaboratorio,
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: ElevatedButton(
                            onPressed: _guardarConsulta,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _secondaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Guardar Consulta', style: TextStyle(color: Colors.white)),
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
}