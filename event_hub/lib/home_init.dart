import 'package:flutter/material.dart';
import 'login_type.dart';

class HomeInit extends StatefulWidget {
  const HomeInit({super.key});

  @override
  State<HomeInit> createState() => _HomeInitState();
}

class _HomeInitState extends State<HomeInit> {
  double _opacityWelcome = 1.0;
  double _opacityLogo = 0.0;
  double _opacitySubtitle = 0.0;
  double _opacityButton = 0.0;

  Offset _offsetLogo = Offset(0, 0.3);
  Offset _offsetSubtitle = Offset(0, 0.3);

  @override
  void initState() {
    super.initState();

    // Animación del texto de bienvenida
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacityWelcome = 0.0;
      });
    });

    // Animación para mostrar el logo después de que el texto de bienvenida desaparece
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _opacityLogo = 1.0;
      });
    });

    // Animación para mover el logo hacia arriba
    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        _offsetLogo = Offset(0, -0.2); // Mueve el logo un poco hacia arriba
        _opacitySubtitle = 1.0;
      });
    });

    // Animación del subtítulo
    Future.delayed(Duration(milliseconds: 3500), () {
      setState(() {
        _offsetSubtitle =
            Offset(0, 0); // Mueve el subtítulo a su posición original
      });
    });

    // Animación del botón (sin desplazamiento)
    Future.delayed(Duration(milliseconds: 4000), () {
      setState(() {
        _opacityButton = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Texto de bienvenida animado con posición ajustable
          Align(
            alignment: Alignment.center, // Posición del texto de bienvenida
            child: AnimatedOpacity(
              opacity: _opacityWelcome,
              duration: Duration(seconds: 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bienvenido a',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8), // Espacio entre las líneas de texto
                  Text(
                    'Digital Event Hub',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Logo animado
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),

                  // Logo animado
                  AnimatedOpacity(
                    opacity: _opacityLogo,
                    duration: Duration(milliseconds: 800),
                    child: AnimatedSlide(
                      offset: _offsetLogo,
                      duration: Duration(milliseconds: 800),
                      child: Image.asset(
                        'assets/images/logo_1.png',
                        height:
                            150, // Ajusta el tamaño del logo según sea necesario
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Subtítulo animado
                  AnimatedOpacity(
                    opacity: _opacitySubtitle,
                    duration: Duration(milliseconds: 800),
                    child: AnimatedSlide(
                      offset: _offsetSubtitle,
                      duration: Duration(milliseconds: 800),
                      child: Text(
                        'Explora y participa en los eventos más emocionantes. Únete a nuestra comunidad y disfruta de una experiencia inolvidable.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Botón animado (solo opacidad)
                  AnimatedOpacity(
                    opacity: _opacityButton,
                    duration: Duration(milliseconds: 800),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginType(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 40.0),
                        backgroundColor: Color(0xFF6D3089),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
