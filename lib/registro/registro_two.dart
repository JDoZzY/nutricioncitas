import 'dart:developer';
import 'package:flutter/material.dart';
import 'seguimiento.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'registro_two_ui.dart'; // Nuevo archivo de UI

class RegistroTwo extends StatefulWidget {
  final Map<String, dynamic>? datos;
  const RegistroTwo({super.key, this.datos});

  @override
  State<RegistroTwo> createState() => _RegistroTwoState();
}

class _RegistroTwoState extends State<RegistroTwo> {
  List<Map<String, dynamic>> _followUps = [];
  int _currentFollowUpIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> allRecords = [];
    if (widget.datos != null) {
      allRecords.add({
        ...widget.datos!,
        'esInicial': true,
      });
    }
    allRecords.addAll(
      _followUps.reversed.map((followUp) => {
        ...followUp,
        'esInicial': false,
      }),
    );

    Map<String, dynamic> currentData;
    if (_currentFollowUpIndex == -1) {
      currentData = widget.datos ?? {};
    } else {
      final displayIndex = _followUps.isEmpty
          ? -1
          : (_currentFollowUpIndex >= _followUps.length
          ? _followUps.length - 1
          : _currentFollowUpIndex);
      currentData = displayIndex == -1 ? widget.datos ?? {} : _followUps[displayIndex];
    }

    return RegistroTwoUI(
      datos: widget.datos,
      currentData: currentData,
      allRecords: allRecords,
      followUps: _followUps,
      currentFollowUpIndex: _currentFollowUpIndex,
      onBackPressed: () => Navigator.pop(context),
      onAddRecord: _agregarNuevoRegistro,
      onFollowUpSelected: (index) => setState(() => _currentFollowUpIndex = index),
      onInitialSelected: () => setState(() => _currentFollowUpIndex = -1),
      onShowDialog: () => RegistroTwoUI.mostrarDialogo(context, widget.datos),
      onDeleteFollowUp: _deleteFollowUp,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFollowUps().then((_) {
      if (_followUps.isNotEmpty) {
        setState(() {
          _currentFollowUpIndex = 0;
        });
      }
    });
  }

  Future<void> _loadFollowUps() async {
    if (widget.datos == null) return;

    final prefs = await SharedPreferences.getInstance();
    final pacientes = prefs.getStringList('pacientes') ?? [];

    for (var pacienteJson in pacientes) {
      try {
        final paciente = jsonDecode(pacienteJson);
        if (paciente['nombrePaciente'] == widget.datos!['nombrePaciente']) {
          setState(() {
            _followUps = List<Map<String, dynamic>>.from(
              paciente['seguimientos'] ?? [],
            );
            _followUps.sort(
                  (a, b) => (b['id_unico'] ?? 0).compareTo(a['id_unico'] ?? 0),
            );
          });
          return;
        }
      } catch (e, stackTrace) {
        log('Error procesando paciente: $e', stackTrace: stackTrace);
      }
    }
  }

  void _agregarNuevoRegistro() async {
    Map<String, dynamic> datosCompletos = {
      ...widget.datos!,
      if (_followUps.isNotEmpty) ..._followUps.first,
    };
    final newFollowUpData = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => SeguimientoScreen(initialData: datosCompletos),
      ),
    );
    if (newFollowUpData != null) {
      setState(() {
        _followUps.insert(0, {
          ...newFollowUpData,
          'id_unico': DateTime.now().millisecondsSinceEpoch,
        });
        _currentFollowUpIndex = 0;
      });
      await _saveFollowUps();
    }
  }

  Future<void> _saveFollowUps() async {
    if (widget.datos == null) return;

    final prefs = await SharedPreferences.getInstance();
    final pacientes = prefs.getStringList('pacientes') ?? [];

    bool pacienteEncontrado = false;
    final nuevosPacientes = pacientes.map((json) {
      final paciente = jsonDecode(json);
      if (paciente['nombrePaciente'] == widget.datos!['nombrePaciente']) {
        pacienteEncontrado = true;
        return jsonEncode({...widget.datos!, 'seguimientos': _followUps});
      }
      return json;
    }).toList();

    if (!pacienteEncontrado) {
      nuevosPacientes.add(
        jsonEncode({...widget.datos!, 'seguimientos': _followUps}),
      );
    }
    await prefs.setStringList('pacientes', nuevosPacientes);
  }

  Future<void> _deleteFollowUp(int index) async {
    if (index >= 0 && index < _followUps.length) {
      setState(() {
        _followUps.removeAt(index);
        // Adjust the current index if necessary
        if (_currentFollowUpIndex >= _followUps.length) {
          _currentFollowUpIndex = _followUps.isEmpty ? -1 : _followUps.length - 1;
        }});
      await _saveFollowUps();
    }}
}
