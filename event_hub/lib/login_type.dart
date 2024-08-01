import 'package:flutter/material.dart';
import 'package:event_hub/login_client.dart';


class LoginType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color:
                      Colors.white, // Ejemplo de color para la parte inferior
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 100, // Altura ajustada según necesidades
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Container(
                              color: Color(
                                  0xFF6D3089), // Ejemplo de color para la parte inferior
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: ClipPath(
                          clipper: WaveClipper(),
                          child: Container(
                            color: Colors
                                .white, // Ejemplo de color para la parte inferior
                            height: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: SizedBox(
              width: 330,
              height: 400, // Ancho y altura del Card
              child: Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 55),
                      Text(
                        'Iniciar sesión como:',
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 35),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Color(0xFF6D3089),
                          minimumSize: Size(double.infinity, 55),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginClient()),
                          );
                        },
                        child: Text(
                          'Cliente',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 105, // Ajusta la posición vertical del avatar según necesites
            left: MediaQuery.of(context).size.width / 2 -
                40, // Centrar horizontalmente
            child: Container(
              width: 80, // Ancho del contenedor
              height: 80, // Alto del contenedor
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Forma circular del contenedor
                border: Border.all(
                  color: Color.fromARGB(255, 141, 141, 141), // Color del borde
                  width: 2, // Ancho del borde
                ),
              ),
              child: CircleAvatar(
                radius: 35, // Radio del avatar
                backgroundColor:
                    Colors.grey.shade200, // Color de fondo del avatar
                child: Icon(Icons.person,
                    size: 55, color: Colors.black), // Icono del avatar
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 80); // Ajustar según necesidades
    var controlPoint =
        Offset(size.width / 2, size.height + 60); // Ajustar según necesidades
    var endPoint =
        Offset(size.width, size.height - 80); // Ajustar según necesidades
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height - 90); // Ajustar según necesidades
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
