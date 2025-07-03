import 'package:flutter/material.dart';

class OpcionEstimarPT extends StatefulWidget {
  const OpcionEstimarPT({super.key});

  @override
  State<OpcionEstimarPT> createState() => _OpcionEstimarPTState();
}

class _OpcionEstimarPTState extends State<OpcionEstimarPT> {
  String? selectedSexo;
  final borderColor = const Color(0xFF036666);
  final ScrollController _scrollController = ScrollController();

  // Controladores para ajustes
  final TextEditingController _ajustePesoController = TextEditingController();
  final TextEditingController _ajusteTallaController = TextEditingController();

  // Variables base
  double _pesoBase = 0;
  double _tallaBase = 0;
  double _rangoPesoValor = 0;
  double _rangoTallaValor = 0;
  String _clasificacionImc = '';
  String _estadoNutricional = '';
  int _edad = 0;
  bool _isMasculino = false;
  double _cmb = 0;

  // Controladores para los campos de entrada
  final TextEditingController edadController = TextEditingController();
  final TextEditingController arController = TextEditingController();
  final TextEditingController cmbController = TextEditingController();

  // Variables para los resultados
  String pesoEstimado = '';
  String rangoPeso = '';
  String tallaEstimada = '';
  String rangoTalla = '';
  String imc = '';
  String porcentajeCmb = '';
  String resultadoFinal = '';

  @override
  void initState() {
    super.initState();
    _ajustePesoController.addListener(_actualizarPeso);
    _ajusteTallaController.addListener(_actualizarTalla);
  }

  void _actualizarPeso() {
    final ajuste = double.tryParse(_ajustePesoController.text) ?? 0;
    setState(() {
      pesoEstimado = (_pesoBase + ajuste).toStringAsFixed(2);
      _actualizarResultados();
    });
  }

  void _actualizarTalla() {
    final ajuste = double.tryParse(_ajusteTallaController.text) ?? 0;
    setState(() {
      tallaEstimada = (_tallaBase + ajuste).toStringAsFixed(2);
      _actualizarResultados();
    });
  }

  void _actualizarResultados() {
    // Recalcular IMC
    final peso = double.tryParse(pesoEstimado) ?? 0;
    final talla = double.tryParse(tallaEstimada) ?? 0;

    if (talla > 0) {
      final imcValor = peso / ((talla / 100) * (talla / 100));
      _clasificacionImc = _obtenerClasificacionIMC(_edad, imcValor);

      // Recalcular %CMB
      final cmbIdeal = obtenerCmbIdeal(_edad, _isMasculino);
      final porcentajeCmbValor = (_cmb / cmbIdeal) * 100;
      _estadoNutricional = _obtenerEstadoNutricional(porcentajeCmbValor);

      setState(() {
        imc = '${imcValor.toStringAsFixed(2)} ($_clasificacionImc)';
        porcentajeCmb = '${porcentajeCmbValor.toStringAsFixed(2)}% ($_estadoNutricional)';
        resultadoFinal = 'Paciente ${_isMasculino ? 'masculino' : 'femenino'} de $_edad años de edad '
            'con $_clasificacionImc según IMC de ${imcValor.toStringAsFixed(2)}Kg/m² '
            'con una $_estadoNutricional de ${porcentajeCmbValor.toStringAsFixed(2)}%.';
      });
    }
  }

  String _obtenerClasificacionIMC(int edad, double imcValor) {
    if (edad >= 60) {
      if (imcValor < 22) return 'Bajo peso';
      if (imcValor < 27.9) return 'Peso normal';
      if (imcValor < 31.9) return 'Sobrepeso';
      return 'Obesidad';
    } else {
      if (imcValor < 18.5) return 'Bajo peso';
      if (imcValor < 25) return 'Peso normal';
      if (imcValor < 30) return 'Sobrepeso';
      return 'Obesidad';
    }
  }

  String _obtenerEstadoNutricional(double porcentajeCmbValor) {
    if (porcentajeCmbValor > 90) return 'Normal';
    if (porcentajeCmbValor >= 81) return 'Depleción leve de CHON somática';
    if (porcentajeCmbValor >= 70) return 'Depleción moderada de CHON somática';
    return 'Depleción severa de CHON somática';
  }


  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFFFC971),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(2, 4),
            blurRadius: 2,
          )
        ],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Estimar Peso & Talla',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Ingrese los datos para realizar la estimación.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSexoButton(String label, Color color) {
    final isSelected = selectedSexo == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedSexo = label),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
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

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildResultField(String label, String value, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableRangeField(String label, String value, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              const Text('', style: TextStyle(fontSize: 16)),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: value.isEmpty ? hint : value,
                  ),
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, {double width = 120, VoidCallback? onPressed}) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: borderColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontSize: 14),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildDataCard() {
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
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSexoButton('Masculino', const Color(0xFF70d6ff)),
              const SizedBox(width: 8),
              _buildSexoButton('Femenino', const Color(0xFFff70a6)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildInputField('Edad', edadController)),
              const SizedBox(width: 8),
              Expanded(child: _buildInputField('AR (Cm)', arController)),
              const SizedBox(width: 8),
              Expanded(child: _buildInputField('CMB (Cm)', cmbController)),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: _buildActionButton(
              'Resultados',
              width: double.infinity,
              onPressed: () {
                FocusScope.of(context).unfocus();
                calcularResultados();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
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
            'Resultados',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildResultField('Peso Estimado', pesoEstimado, 'Kg')),
              const SizedBox(width: 8),
              Expanded(child: _buildEditableRangeField('Rango', rangoPeso, 'Kg', _ajustePesoController)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildResultField('Talla Estimada', tallaEstimada, 'Cm')),
              const SizedBox(width: 8),
              Expanded(child: _buildEditableRangeField('Rango', rangoTalla, 'Cm', _ajusteTallaController)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildResultField('IMC', imc, 'Kg/m²')),
              const SizedBox(width: 8),
              Expanded(child: _buildResultField('%CMB', porcentajeCmb, '%')),
            ],
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Resultados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: TextEditingController(text: resultadoFinal),
              decoration: const InputDecoration(border: InputBorder.none),
              readOnly: true,
              maxLines: null,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton('Guardar', onPressed: guardarResultados),
              const SizedBox(width: 10),
              _buildActionButton('Nuevo', onPressed: () {
                limpiarFormulario();
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void calcularResultados() {
    if (selectedSexo == null ||
        edadController.text.isEmpty ||
        arController.text.isEmpty ||
        cmbController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    try {
      final edad = int.parse(edadController.text);
      final ar = double.parse(arController.text);
      final cmb = double.parse(cmbController.text);
      final isMasculino = selectedSexo == 'Masculino';

      setState(() {
        _edad = edad;
        _isMasculino = isMasculino;
        _cmb = cmb;
      });

      double talla = 0;
      _rangoTallaValor = 0;

      if (isMasculino) {
        if (edad >= 6 && edad <= 18) {
          talla = (ar * 2.22) + 40.54;
          _rangoTallaValor = 8.42;
        } else if (edad >= 19 && edad <= 59) {
          talla = (ar * 1.88) + 71.85;
          _rangoTallaValor = 7.94;
        } else if (edad >= 60) {
          talla = (ar * 2.08) + 59.01;
          _rangoTallaValor = 7.84;
        }
      } else {
        if (edad >= 6 && edad <= 18) {
          talla = (ar * 2.15) + 43.21;
          _rangoTallaValor = 7.79;
        } else if (edad >= 19 && edad <= 59) {
          talla = (ar * 1.86) - (edad * 0.05) + 70.25;
          _rangoTallaValor = 7.20;
        } else if (edad >= 60) {
          talla = (ar * 1.91) - (edad * 0.17) + 75.00;
          _rangoTallaValor = 8.82;
        }
      }

      double peso = 0;
      _rangoPesoValor = 0;

      if (isMasculino) {
        if (edad >= 6 && edad <= 18) {
          peso = (ar * 0.68) + (cmb * 2.64) - 50.08;
          _rangoPesoValor = 7.82;
        } else if (edad >= 19 && edad <= 59) {
          peso = (ar * 1.19) + (cmb * 3.21) - 86.82;
          _rangoPesoValor = 11.42;
        } else if (edad >= 60) {
          peso = (ar * 1.10) + (cmb * 3.07) - 75.81;
          _rangoPesoValor = 11.48;
        }
      } else {
        if (edad >= 6 && edad <= 18) {
          peso = (ar * 0.77) + (cmb * 2.47) - 50.16;
          _rangoPesoValor = 7.20;
        } else if (edad >= 19 && edad <= 59) {
          peso = (ar * 1.01) + (cmb * 2.81) - 66.04;
          _rangoPesoValor = 10.60;
        } else if (edad >= 60) {
          peso = (ar * 1.09) + (cmb * 2.68) - 65.51;
          _rangoPesoValor = 11.42;
        }
      }

      double imcValor = 0;
      if (talla > 0) {
        imcValor = peso / ((talla / 100) * (talla / 100));
      }

      double cmbIdeal = obtenerCmbIdeal(edad, isMasculino);
      double porcentajeCmbValor = (cmb / cmbIdeal) * 100;
      String estadoNutricional = _obtenerEstadoNutricional(porcentajeCmbValor);

      String clasificacionImc = '';
      if (edad >= 60) {
        if (imcValor < 22) {
          clasificacionImc = 'Bajo peso';
        } else if (imcValor >= 22 && imcValor < 27.9) {
          clasificacionImc = 'Peso normal';
        } else if (imcValor >= 27.9 && imcValor < 31.9) {
          clasificacionImc = 'Sobrepeso';
        } else if (imcValor >= 31.9) {
          clasificacionImc = 'Obesidad';
        }
      } else {
        if (imcValor < 18.5) {
          clasificacionImc = 'Bajo peso';
        } else if (imcValor >= 18.5 && imcValor < 25) {
          clasificacionImc = 'Peso normal';
        } else if (imcValor >= 25 && imcValor < 30) {
          clasificacionImc = 'Sobrepeso';
        } else if (imcValor >= 30) {
          clasificacionImc = 'Obesidad';
        }
      }

      setState(() {
        _pesoBase = peso;
        _tallaBase = talla;
        pesoEstimado = peso.toStringAsFixed(2);
        tallaEstimada = talla.toStringAsFixed(2);
        rangoPeso = '± ${_rangoPesoValor.toStringAsFixed(2)}';
        rangoTalla = '± ${_rangoTallaValor.toStringAsFixed(2)}';
        imc = '${imcValor.toStringAsFixed(2)} ($clasificacionImc)';
        porcentajeCmb = '${porcentajeCmbValor.toStringAsFixed(2)}% ($estadoNutricional)';
        resultadoFinal = 'Paciente ${isMasculino ? 'masculino' : 'femenino'} de $edad años de edad '
            'con $clasificacionImc según IMC de ${imcValor.toStringAsFixed(2)}Kg/m² '
            'con una $estadoNutricional de ${porcentajeCmbValor.toStringAsFixed(2)}%.';
        _ajustePesoController.clear();
        _ajusteTallaController.clear();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error en los datos ingresados')),
      );
    }
  }

  double obtenerCmbIdeal(int edad, bool isMasculino) {
    if (isMasculino) {
      if (edad >= 12 && edad < 13) return 23.2;
      if (edad >= 13 && edad < 14) return 24.7;
      if (edad >= 14 && edad < 15) return 25.3;
      if (edad >= 15 && edad < 16) return 26.4;
      if (edad >= 16 && edad < 17) return 27.8;
      if (edad >= 17 && edad < 18) return 28.5;
      if (edad >= 18 && edad < 19) return 29.7;
      if (edad >= 19 && edad < 25) return 30.8;
      if (edad >= 25 && edad < 35) return 31.9;
      if (edad >= 35 && edad < 45) return 32.6;
      if (edad >= 45 && edad < 55) return 32.2;
      if (edad >= 55 && edad < 65) return 31.7;
      if (edad >= 65 && edad < 75) return 30.7;
    } else {
      if (edad >= 12 && edad < 13) return 23.7;
      if (edad >= 13 && edad < 14) return 24.3;
      if (edad >= 14 && edad < 15) return 25.2;
      if (edad >= 15 && edad < 16) return 25.4;
      if (edad >= 16 && edad < 17) return 25.8;
      if (edad >= 17 && edad < 18) return 26.4;
      if (edad >= 18 && edad < 19) return 25.8;
      if (edad >= 19 && edad < 25) return 26.5;
      if (edad >= 25 && edad < 35) return 27.7;
      if (edad >= 35 && edad < 45) return 29.0;
      if (edad >= 45 && edad < 55) return 29.9;
      if (edad >= 55 && edad < 65) return 30.3;
      if (edad >= 65 && edad < 75) return 29.9;
    }
    return 25.0;
  }

  void limpiarFormulario() {
    setState(() {
      selectedSexo = null;
      edadController.clear();
      arController.clear();
      cmbController.clear();
      pesoEstimado = '';
      rangoPeso = '';
      tallaEstimada = '';
      rangoTalla = '';
      imc = '';
      porcentajeCmb = '';
      resultadoFinal = '';
    });
  }

  void guardarResultados() {
    if (resultadoFinal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay resultados para guardar')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resultados guardados correctamente')),
    );
  }

  @override
  void dispose() {
    edadController.dispose();
    arController.dispose();
    cmbController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoCard(),
          const SizedBox(height: 10),
          _buildDataCard(),
          const SizedBox(height: 10),
          _buildResultsCard(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
