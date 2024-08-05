import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:event_hub/config/conn_api.dart'; // Importar el archivo conn_api.dart

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Map<String, dynamic>? profileData;
  final _formKey = GlobalKey<FormState>();
  

  TextEditingController nombreController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController membershipController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController fotoPerfilController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    // Verificar si usuarioId no es null antes de continuar
    if (UserData.usuarioId == null) {
      print('Error: usuarioId es null');
      return;
    }

    final response = await http.get(Uri.parse('${Config.apiUrl}/users/${UserData.usuarioId}'));
    print('Usuario PROFILE ID: ${UserData.usuarioId}');

    if (response.statusCode == 200) {
      setState(() {
        profileData = json.decode(response.body);
        // Inicializar los controladores con los valores actuales del perfil
        nombreController.text = profileData!['nombre'] ?? '';
        lastNameController.text = profileData!['last_name'] ?? '';
        emailController.text = profileData!['email'] ?? '';
        telefonoController.text = profileData!['telefono']?.toString() ?? '';
        membershipController.text = profileData!['membresia_id']?.toString() ?? '';
        statusController.text = profileData!['activo'] == true ? 'Activo' : 'Inactivo';
        fotoPerfilController.text = profileData!['fotoPerfil'] ?? '';
      });
    } else {
      // Manejar el error
      print('Error al obtener los datos del perfil: ${response.statusCode}');
    }
  }

Future<void> updateProfileData() async {
  if (!_formKey.currentState!.validate()) return;

  final updatedProfileData = {
    'nombre': nombreController.text,
    'email': emailController.text,
    'telefono': telefonoController.text,
    "rol_id": profileData!['rol_id'],
    "membresia_id": profileData!['membresia_id'],
    "activo": profileData!['activo'],
    'last_name': lastNameController.text,
    "fotoPerfil": fotoPerfilController.text,
  };

  final response = await http.put(
    Uri.parse('${Config.apiUrl}/users/${UserData.usuarioId}'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(updatedProfileData),
  );

  if (response.statusCode == 200) {
    setState(() {
      profileData = json.decode(response.body);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Éxito'),
          content: Text('Perfil actualizado con éxito'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.pop(context); // Regresa a la ventana anterior
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Error al actualizar el perfil: ${response.statusCode}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


  String getRoleText(int? roleId) {
    switch (roleId) {
      case 1:
        return 'Administrador';
      case 2:
        return 'Usuario';
      case 3:
        return 'Organizador';
      default:
        return 'Sin rol';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    color: Color(0xFF6D3089), // Fondo azul claro
                  ),
                  Positioned(
                    top: 80,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: Image.network(
                          profileData != null
                              ? profileData!['fotoPerfil'] ?? 'https://w7.pngwing.com/pngs/916/294/png-transparent-tweety-gangster-looney-tunes-character-gangsta-gun-weapon-mafia-boss-smoking.png'
                              : 'https://w7.pngwing.com/pngs/916/294/png-transparent-tweety-gangster-looney-tunes-character-gangsta-gun-weapon-mafia-boss-smoking.png',
                          width: 400,
                          height: 400,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/user.png', // Imagen local en caso de error
                              width: 400,
                              height: 400,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(labelText: 'Apellido'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un apellido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: telefonoController,
                      decoration: InputDecoration(labelText: 'Teléfono'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un número de teléfono';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: fotoPerfilController,
                      decoration: InputDecoration(labelText: 'Foto de perfil'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un apellido';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: updateProfileData,
                  child: Text('Actualizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
