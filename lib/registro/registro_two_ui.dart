import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RegistroTwoUI extends StatelessWidget {
  final Map<String, dynamic>? datos;
  final Map<String, dynamic> currentData;
  final List<Map<String, dynamic>> allRecords;
  final List<Map<String, dynamic>> followUps;
  final int currentFollowUpIndex;
  final VoidCallback onBackPressed;
  final VoidCallback onAddRecord;
  final ValueChanged<int> onFollowUpSelected;
  final VoidCallback onInitialSelected;
  final VoidCallback onShowDialog;
  final ValueChanged<int> onDeleteFollowUp;

  const RegistroTwoUI({
    super.key,
    required this.datos,
    required this.currentData,
    required this.allRecords,
    required this.followUps,
    required this.currentFollowUpIndex,
    required this.onBackPressed,
    required this.onAddRecord,
    required this.onFollowUpSelected,
    required this.onInitialSelected,
    required this.onShowDialog,
    required this.onDeleteFollowUp,
  });

  String _calcularIMC(dynamic peso, dynamic talla) {
    try {
      final pesoDouble = double.tryParse(peso?.toString() ?? '0') ?? 0;
      final tallaDouble = double.tryParse(talla?.toString() ?? '0') ?? 0;
      if (tallaDouble == 0) return '0.00';
      final imc = pesoDouble / ((tallaDouble / 100) * (tallaDouble / 100));
      return imc.toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top,
                color: const Color(0xFF036666),
              ),
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
                        onPressed: onBackPressed,
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Registro de Datos',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            datos?['nombrePaciente']?.toString() ?? 'Nombre no disponible',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF036666),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: GestureDetector(
                            onTap: onShowDialog,
                            child: const Icon(Icons.visibility, color: Color(0xFF036666)),
                          ),
                        ),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Seguimiento',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildMetricCharts(),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: onAddRecord,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF248277),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text('Agregar Registro', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 6),
                            ...followUps.asMap().entries.map((entry) {
                              final index = entry.key;
                              final numeroSeguimiento = followUps.length - index;
                              return Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: GestureDetector(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Eliminar Registro'),
                                          content: Text(
                                              '¿Estás seguro de que deseas eliminar el Registro $numeroSeguimiento?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Eliminar'),
                                              onPressed: () {
                                                onDeleteFollowUp(index);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: ElevatedButton(
                                    onPressed: () => onFollowUpSelected(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      currentFollowUpIndex == index
                                          ? const Color(0xFF036666)
                                          : const Color(0xFF248277),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                    ),
                                    child: Text(
                                      '$numeroSeguimiento',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ElevatedButton(
                                onPressed: onInitialSelected,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentFollowUpIndex == -1
                                      ? const Color(0xFF036666)
                                      : const Color(0xFF248277),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                child: const Text(
                                  'RI',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildCard('Antropometría', [
                      _buildDato('Peso', '${double.tryParse(currentData['peso']?.toString() ?? '0')?.toStringAsFixed(2)} Kg'),
                      _buildDato('Talla', '${double.tryParse(currentData['talla']?.toString() ?? '0')?.toStringAsFixed(2)} Cm'),
                      _buildDato('IMC', _calcularIMC(currentData['peso'], currentData['talla'])),
                      _buildDato('% Grasa', '${currentData['grasa']?.toString() ?? '0'} %'),
                      _buildDato('% Masa Magra', '${currentData['masaMagra']?.toString() ?? '0'} %'),
                      _buildDato('% Visceral', '${currentData['visceral']?.toString() ?? '0'} %'),
                      _buildDato('% Masa Ósea', '${currentData['masaOsea']?.toString() ?? '0'} %'),
                      _buildDato('% Agua', '${currentData['agua']?.toString() ?? '0'} %'),
                      _buildDato('Edad Metabólica', '${currentData['edadMetabolica']?.toString() ?? '0'} años'),
                    ]),
                    _buildCard('Diagnósticos', [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Diagnóstico Médico', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                                Text(currentData['diagnosticoMedico']?.toString() ?? 'No especificado', style: const TextStyle(color: Colors.black54)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Diagnóstico Nutricional', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                                Text(currentData['diagnosticoNutricional']?.toString() ?? 'No especificado', style: const TextStyle(color: Colors.black54)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                    _buildCard('Laboratorios', [
                      if (currentData['laboratorios'] != null)
                        ..._buildLaboratorios(currentData['laboratorios'] as List<dynamic>)
                      else
                        const Text('No se ingresaron laboratorios', style: TextStyle(color: Colors.grey)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCharts() {
    final validRecords = allRecords.where((record) =>
    record['peso'] != null ||
        record['talla'] != null ||
        record['grasa'] != null).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF248277), width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          DefaultTabController(
            length: 8,
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF248277).withValues(alpha: 0.1),
                  child: TabBar(
                    isScrollable: true,
                    labelColor: const Color(0xFF036666),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF036666),
                    tabs: const [
                      Tab(text: 'Peso'),
                      Tab(text: 'Talla'),
                      Tab(text: 'IMC'),
                      Tab(text: '% Grasa'),
                      Tab(text: '% Masa Magra'),
                      Tab(text: '% Visceral'),
                      Tab(text: '% Masa Ósea'),
                      Tab(text: '% Agua'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    children: [
                      _buildChart('Peso (Kg)', validRecords, 'peso', 'Kg'),
                      _buildChart('Talla (Cm)', validRecords, 'talla', 'Cm'),
                      _buildIMCChart(validRecords),
                      _buildChart('% Grasa', validRecords, 'grasa', '%'),
                      _buildChart('% Masa Magra', validRecords, 'masaMagra', '%'),
                      _buildChart('% Visceral', validRecords, 'visceral', '%'),
                      _buildChart('% Masa Ósea', validRecords, 'masaOsea', '%'),
                      _buildChart('% Agua', validRecords, 'agua', '%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(String title, List<Map<String, dynamic>> records, String metric, String unit) {
    final patientRecords = records.where((r) => r['pacienteId'] == datos?['id']).toList();
    final data = patientRecords
        .where((r) => r[metric] != null && double.tryParse(r[metric].toString()) != null)
        .map((r) => ChartData(
      r['esInicial'] == true ? 'Registro Inicial' : 'Seguimiento ${records.indexOf(r)}',
      double.parse(r[metric].toString()),
      getColorForMetric(metric),
    ))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
        title: ChartTitle(text: title),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: unit),
        ),
        series: <CartesianSeries<dynamic, dynamic>>[
          LineSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            pointColorMapper: (ChartData data, _) => data.color,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              width: 6,
              height: 6,
              borderWidth: 2,
            ),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
            ),
          )
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : point.y $unit',
        ),
      ),
    );
  }

  Widget _buildIMCChart(List<Map<String, dynamic>> records) {
    final data = records
        .where((r) => r['peso'] != null && r['talla'] != null)
        .map((r) {
      final peso = double.tryParse(r['peso'].toString()) ?? 0;
      final talla = double.tryParse(r['talla'].toString()) ?? 0;
      final imc = talla == 0
          ? 0.0
          : double.parse((peso / ((talla / 100) * (talla / 100))).toStringAsFixed(2));
      return ChartData(
        r['esInicial'] == true
            ? 'Registro Inicial'
            : 'Seguimiento ${records.indexOf(r)}',
        imc,
        const Color(0xFF4CAF50),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
        title: const ChartTitle(text: 'Índice de Masa Corporal'),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(title: AxisTitle(text: 'IMC')),
        series: <CartesianSeries<dynamic, dynamic>>[
          LineSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            pointColorMapper: (ChartData data, _) => data.color,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.diamond,
              width: 6,
              height: 6,
              borderWidth: 2,
            ),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
            ),
          )
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : point.y',
        ),
      ),
    );
  }

  Color getColorForMetric(String metric) {
    switch (metric) {
      case 'peso': return const Color(0xFF2196F3);
      case 'talla': return const Color(0xFF673AB7);
      case 'grasa': return const Color(0xFFF44336);
      case 'masaMagra': return const Color(0xFFFF9800);
      case 'visceral': return const Color(0xFF9C27B0);
      case 'masaOsea': return const Color(0xFF795548);
      case 'agua': return const Color(0xFF00BCD4);
      default: return const Color(0xFF4CAF50);
    }
  }

  Widget _buildCard(String titulo, List<Widget> contenido) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF248277), width: 1),
      ),
      color: Colors.white.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF036666),
                ),
              ),
            ),
            ...contenido,
          ],
        ),
      ),
    );
  }

  Widget _buildDato(String titulo, dynamic valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              valor?.toString() ?? 'No especificado',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLaboratorios(List<dynamic> labs) {
    if (labs.isEmpty) {
      return [
        const Text(
          'No se ingresaron laboratorios',
          style: TextStyle(color: Colors.grey),
        ),
      ];
    }

    List<TableRow> tableRows = [
      TableRow(
        decoration: BoxDecoration(
          color: const Color(0xFF036666),
        ),
        children: [
          _buildHeaderCell('Estudio'),
          _buildHeaderCell('Referencia'),
          _buildHeaderCell('Resultado'),
        ],
      ),
    ];

    for (var lab in labs) {
      tableRows.add(
        TableRow(
          children: [
            _buildDataCell(lab['estudio']?.toString() ?? 'N/A'),
            _buildDataCell(lab['referencia']?.toString() ?? 'N/A'),
            _buildDataCell(lab['resultado']?.toString() ?? 'N/A'),
          ],
        ),
      );
    }

    return [
      const SizedBox(height: 4),
      Table(
        border: TableBorder.all(color: Colors.grey),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
        },
        children: tableRows,
      ),
    ];
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  static void mostrarDialogo(BuildContext context, Map<String, dynamic>? datos) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF248277), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    datos?['nombrePaciente']?.toString() ??
                        'Nombre no disponible',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF036666),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _filaDoble(
                        'F. Nacimiento',
                        datos?['fechaNacimiento']?.toString(),
                        'Edad',
                        datos?['edad']?.toString(),
                      ),
                      const SizedBox(height: 8),
                      _filaSimple('Lugar de Origen', datos?['origen']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _filaDoble(
      String titulo1,
      dynamic valor1,
      String titulo2,
      dynamic valor2,
      ) {
    return Row(
      children: [
        Expanded(child: _datoTexto(titulo1, valor1)),
        const SizedBox(width: 12),
        Expanded(child: _datoTexto(titulo2, valor2)),
      ],
    );
  }

  static Widget _filaSimple(String titulo, dynamic valor) {
    return _datoTexto(titulo, valor);
  }

  static Widget _datoTexto(String titulo, dynamic valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF036666),
          ),
        ),
        Text(
          valor?.toString() ?? 'No disponible',
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    );
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}
