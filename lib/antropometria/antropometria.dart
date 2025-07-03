import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'puntajez/opcion_zscore.dart';
import 'estimarpeso/opcion_estimar_peso.dart';
import 'estimarpesotalla/opcion_estimar_pt.dart';

class AntropometriaPage extends StatefulWidget {
  const AntropometriaPage({super.key});

  @override
  State<AntropometriaPage> createState() => _AntropometriaPageState();
}

class _AntropometriaPageState extends State<AntropometriaPage> {
  Widget? contenidoActual;

  @override
  void initState() {
    super.initState();
    contenidoActual = const OpcionEstimarPT();
  }

  void cambiarContenido(Widget nuevoContenido) {
    setState(() {
      contenidoActual = nuevoContenido;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF036666),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
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
                Container(
                  height: MediaQuery.of(context).padding.top,
                  color: const Color(0xFF036666),
                ),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Antropometría',
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.34,
                          children: [
                            CuadroOpcion(
                              texto: 'Estimar P/T',
                              iconos: [Icons.boy],
                              colorFondo: const Color(0xFFFFC971),
                              onTap: () => cambiarContenido(const OpcionEstimarPT()),
                            ),
                            CuadroOpcion(
                              texto: 'Estimar peso',
                              iconos: [Icons.monitor_weight],
                              colorFondo: const Color(0xFF9AD0C2),
                              onTap: () => cambiarContenido(const OpcionEstimarPeso()),
                            ),
                            CuadroOpcion(
                              texto: 'Puntaje Z',
                              iconos: [Icons.baby_changing_station],
                              colorFondo: const Color(0xFFFF9AA2),
                              onTap: () => cambiarContenido(const OpcionZScore()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (contenidoActual != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: contenidoActual!,
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
  final String texto;
  final List<IconData> iconos;
  final Color colorFondo;
  final VoidCallback? onTap;

  const CuadroOpcion({
    super.key,
    required this.texto,
    required this.iconos,
    required this.colorFondo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: colorFondo,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: iconos
                    .map((icono) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Icon(icono, size: 50, color: Colors.white),
                ))
                    .toList(),
              ),
              Text(
                texto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
