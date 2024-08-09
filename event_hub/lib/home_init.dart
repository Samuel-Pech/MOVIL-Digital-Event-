import 'login_type.dart';
import 'package:flutter/material.dart';

class HomeInit extends StatefulWidget {
  const HomeInit({super.key});

  @override
  State<HomeInit> createState() => _HomeInitState();
}

class _HomeInitState extends State<HomeInit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/image.jpg', // Asegúrate de tener la imagen en la carpeta 'assets'
              fit: BoxFit.cover,
            ),
          ),
          // Contenido en primer plano
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenido a Digital Event Hub',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Texto en blanco para mejor contraste
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Explora y participa en los eventos más emocionantes. Únete a nuestra comunidad y disfruta de una experiencia inolvidable.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black, // Texto en blanco semi-translúcido para contraste
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginType()), // Navega a la pantalla de inicio de sesión
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
                      backgroundColor: Color(0xFF6D3089),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Texto en blanco
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
