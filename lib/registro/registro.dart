import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registro_two.dart';
import 'package:intl/intl.dart';

class Registro extends StatefulWidget {
  final Map<String, dynamic>? datos;

  const Registro({super.key, this.datos});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  List<Map<String, dynamic>> listaPacientes = [];

  @override
  void initState() {
    super.initState();
    _cargarPacientes();
  }

  String _formatearFecha(String? fechaIso) {
    if (fechaIso == null) return 'Fecha no disponible';
    try {
      final fecha = DateTime.parse(fechaIso);
      return DateFormat('dd/MM/yyyy').format(fecha);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  Future<void> _cargarPacientes() async {
    final prefs = await SharedPreferences.getInstance();
    final pacientesJson = prefs.getStringList('pacientes') ?? [];

    setState(() {
      listaPacientes = pacientesJson.map((json) {
        try {
          final paciente = Map<String, dynamic>.from(jsonDecode(json));
          if (paciente['fechaRegistro'] == null) {
            paciente['fechaRegistro'] = DateTime.now().toIso8601String();
            _actualizarPaciente(paciente);
          }
          return paciente;
        } catch (e) {
          return <String, dynamic>{};
        }
      }).toList();
    });
  }

  Future<void> _actualizarPaciente(Map<String, dynamic> paciente) async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = listaPacientes.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('pacientes', listaJson);
  }

  Future<void> cargarPacientes() async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = prefs.getStringList('pacientes') ?? [];
    setState(() {
      listaPacientes = listaJson.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  Future<void> agregarPaciente(Map<String, dynamic> nuevoPaciente) async {
    final prefs = await SharedPreferences.getInstance();
    nuevoPaciente['fechaRegistro'] = DateTime.now().toIso8601String();
    listaPacientes.add(Map<String, dynamic>.from(nuevoPaciente)); // Asegúrate de añadir una copia
    final listaJson = listaPacientes.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('pacientes', listaJson);
    _cargarPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                        'Base de Datos',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: listaPacientes.length,
                  itemBuilder: (context, index) {
                    final datos = listaPacientes[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white, size: 30),
                      ),
                      onDismissed: (direction) async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        setState(() {
                          listaPacientes.removeAt(index);
                        });

                        final prefs = await SharedPreferences.getInstance();
                        final listaJson = listaPacientes.map((e) => jsonEncode(e)).toList();
                        await prefs.setStringList('pacientes', listaJson);

                        if (!mounted) return;

                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text('Paciente ${datos['nombrePaciente']} eliminado'),
                            action: SnackBarAction(
                              label: 'Deshacer',
                              onPressed: () async {
                                setState(() {
                                  listaPacientes.insert(index, datos);
                                });
                                final listaJson = listaPacientes.map((e) => jsonEncode(e)).toList();
                                await prefs.setStringList('pacientes', listaJson);
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF248277), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            datos['nombrePaciente'] ?? 'Sin nombre',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Fecha de Registro: ${_formatearFecha(datos['fechaRegistro'])}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF248277)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegistroTwo(datos: datos),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
