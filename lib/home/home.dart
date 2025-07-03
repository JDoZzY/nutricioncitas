import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hospcalc/registro/registro.dart';
import '../calcularformula/calcularformula.dart';
import '../ingresar/ingresarpaciente.dart';
import '../antropometria/antropometria.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentImageIndex = 0;
  late Timer _timer;

  final List<String> _images = [
    'assets/banner/banner1.jpg',
    'assets/banner/banner2.jpg',
    'assets/banner/banner3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
                Container(
                  height: MediaQuery.of(context).padding.top,
                  color: const Color(0xFF036666),
                ),
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF248277), Color(0xFF036666)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: const Text(
                    'Inicio',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 220,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(
                              children: List.generate(_images.length, (index) {
                                return AnimatedOpacity(
                                  opacity: index == _currentImageIndex ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.easeInOut,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      _images[index],
                                      width: double.infinity,
                                      height: 220,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFffd819),
                                Color(0xFFffaa00),
                                Color(0xFFffaa00),
                                Color(0xFFffd819)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Text(
                            'Conocer más',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                            const SizedBox(height: 8),

                            GridView.count(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: [
                              CuadroOpcion(
                                icon: Icons.person_add,
                                texto: 'Ingresar paciente',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const IngresarPacientes()),
                                  );
                                },
                              ),
                              CuadroOpcion(
                                icon: Icons.monitor_weight,
                                texto: 'Antropometría',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const AntropometriaPage()),
                                  );
                                },
                              ),
                              CuadroOpcion(
                                icon: Icons.calculate,
                                texto: 'Macronutrientes',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Calcularformula()),
                                  );
                                },
                              ),
                              CuadroOpcion(
                                icon: Icons.folder,
                                texto: 'Base de datos',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Registro()),
                                  );
                                },
                              ),
                            ],
                          ),
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

class CuadroOpcion extends StatelessWidget {
  final IconData icon;
  final String texto;
  final VoidCallback? onTap;

  const CuadroOpcion({
    super.key,
    required this.icon,
    required this.texto,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF036666), width: 1),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withAlpha(200),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF248277), size: 60),
            const SizedBox(height: 0),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
