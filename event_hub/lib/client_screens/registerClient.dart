import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterClient extends StatefulWidget {
  @override
  _RegisterClientState createState() => _RegisterClientState();
}

class _RegisterClientState extends State<RegisterClient> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _resetPasswordExpireController =
      TextEditingController();
  final TextEditingController _resetPasswordTokenController =
      TextEditingController();
  final TextEditingController _fotoPerfilController = TextEditingController();
  final TextEditingController _membresiaIdController =
      TextEditingController(); // Controlador para membresía

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Imprime los valores para depuración
      print("Nombre: ${_nombreController.text}");
      print("Email: ${_emailController.text}");
      print("Contraseña: ${_contrasenaController.text}");
      print("Teléfono: ${_telefonoController.text}");
      print("Apellido: ${_lastNameController.text}");
      print("Membresía ID: ${_membresiaIdController.text}");
      print(
          "Expiración de Restablecimiento de Contraseña: ${_resetPasswordExpireController.text}");
      print(
          "Token de Restablecimiento de Contraseña: ${_resetPasswordTokenController.text}");
      print("Foto de Perfil: ${_fotoPerfilController.text}");

      // Crear el cuerpo de la solicitud con los datos del formulario y valores por defecto
      final Map<String, dynamic> requestBody = {
        'nombre': _nombreController.text,
        'email': _emailController.text,
        'contrasena': _contrasenaController.text,
        'telefono': _telefonoController.text,
        'rol_id': 2, // Valor por defecto
        'membresia_id': _membresiaIdController.text, // Añadir membresía
        'activo': 1, // Valor por defecto
        'last_name': _lastNameController.text,
        'resetPasswordExpire': _resetPasswordExpireController.text,
        'resetPasswordToken': _resetPasswordTokenController.text,
        'fotoPerfil': _fotoPerfilController.text,
      };

      try {
        // Realizar la solicitud POST a la API
        final response = await http.post(
          Uri.parse('https://api-digitalevent.onrender.com/api/users/register'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Manejar la respuesta exitosa
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registro exitoso')),
          );
        } else {
          // Manejar errores en la respuesta
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error en el registro: ${response.body}')),
          );
        }
      } catch (error) {
        // Manejar errores en la solicitud
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $error')),
        );
      }
    }
  }

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
          "Registrar como cliente",
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
              width: 350,
              height:
                  600, // Ajusta la altura para acomodar los campos de entrada y textos adicionales
              child: Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    Center(
                      child: Text(
                        'Rellena los datos de tu cuenta:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTextField("Nombre", _nombreController),
                                SizedBox(height: 15),
                                _buildTextField("Email", _emailController),
                                SizedBox(height: 15),
                                _buildTextField(
                                    "Contraseña", _contrasenaController,
                                    obscureText: _obscureText),
                                SizedBox(height: 15),
                                _buildTextField(
                                    "Teléfono", _telefonoController),
                                SizedBox(height: 15),
                                _buildTextField(
                                    "Apellido", _lastNameController),
                                SizedBox(height: 15),
                                _buildTextField("Membresía ID",
                                    _membresiaIdController), // Campo de membresía
                                SizedBox(height: 15),
                                _buildTextField(
                                    "Expiración de Restablecimiento de Contraseña",
                                    _resetPasswordExpireController),
                                SizedBox(height: 15),
                                _buildTextField(
                                    "Token de Restablecimiento de Contraseña",
                                    _resetPasswordTokenController),
                                SizedBox(height: 15),
                                _buildTextField(
                                    "Foto de Perfil", _fotoPerfilController),
                                SizedBox(height: 35),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: Color(0xFF6D3089),
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  onPressed:
                                      _registerUser, // Llama al método _registerUser cuando se presiona el botón
                                  child: Text(
                                    'Registrarse',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6D3089)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6D3089)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Color(0xFF6D3089),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
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
