import 'package:event_hub/organizer_screens/organizer_home.dart';
import 'package:flutter/material.dart';

class LoginOrganizer extends StatefulWidget {
  @override
  _LoginOrganizerState createState() => _LoginOrganizerState();
}

class _LoginOrganizerState extends State<LoginOrganizer> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Ingresar como organizador",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6D3089),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Color(
                                0xFF6D3089), // Color morado para la parte superior
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors
                                .white, // Color blanco para la parte inferior del contenedor superior
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipPath(
                        clipper: InvertedWaveClipper(),
                        child: Container(
                          color: const Color(0xFF6D3089),
                          height: 200,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20, // Ajusta según sea necesario
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo_2.png', // Reemplaza con la ruta de tu imagen
                          height: 80, 
                          width: 250,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white, // Color blanco para la parte inferior
                ),
              ),
            ],
          ),
          Center(
            child: SizedBox(
              width: 330,
              height:
                  450, // Ajusta la altura para acomodar los campos de entrada
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
                      SizedBox(height: 5),
                     Center(
                        child: Text(
                          'Te damos la bienvenida a Digital Event Hub',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Correo:',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6D3089)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6D3089)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Contraseña:',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextField(
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6D3089)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6D3089)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xFF6D3089),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 35),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Color(0xFF6D3089),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrganizerHome()),
                          );
                        },
                        child: Text(
                          'Continuar',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvertedWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var controlPoint =
        Offset(size.width / 2, size.height - 140); // Ajustar según necesidades
    var endPoint = Offset(size.width, size.height); // Ajustar según necesidades
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

