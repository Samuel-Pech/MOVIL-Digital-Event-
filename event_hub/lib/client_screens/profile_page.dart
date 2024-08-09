import 'dart:convert';
import 'package:event_hub/client_screens/editProfile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:event_hub/config/conn_api.dart'; // Importar el archivo conn_api.dart

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

   void updateProfile() {
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
      });
    } else {
      // Manejar el error
      print('Error al obtener los datos del perfil: ${response.statusCode}');
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
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  color: Color(0xFF6D3089), // Fondo azul claro
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage(),
                        )
                      );
                    },
                  ),
                ),
               Positioned(
              top: 30,
              left: MediaQuery.of(context).size.width / 2 - 75, // Ajuste del desplazamiento horizontal
              child: CircleAvatar(
                radius: 75, // Aumentar el radio para hacerlo más grande
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.network(
                        profileData?['fotoPerfil'] ??
                                    'https://th.bing.com/th/id/OIP.5q5jb3VzIHsa8xgJGGHPlQHaHa?rs=1&pid=ImgDetMain',
                    width: 600, // Aumentar el ancho de la imagen
                    height: 600, // Aumentar la altura de la imagen
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/user.png', // Imagen local en caso de error
                        width: 600, // Aumentar el ancho de la imagen local
                        height: 600, // Aumentar la altura de la imagen local
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
             Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, color: Colors.yellow, size: 16),
                      SizedBox(width: 5),
                      Text(
                        'Verificado',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
            SizedBox(height: 10),
            Text(
              profileData != null
                  ? '${profileData!['nombre'] ?? ''} ${profileData!['last_name'] ?? ''}'
                  : 'Nombre del Usuario',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              profileData != null
                  ? profileData!['email'] ?? 'Email del Usuario'
                  : 'Email del Usuario',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            ProfileInfoRow(
              leftTitle: 'Phone',
              leftValue: profileData != null
                  ? profileData!['telefono']?.toString() ?? 'No phone number'
                  : 'No phone number',
              rightTitle: 'Role',
              rightValue: profileData != null
                  ? getRoleText(profileData!['rol_id'])
                  : 'Sin rol',
            ),
            ProfileInfoRow(
              leftTitle: 'Membership ID',
              leftValue: profileData != null
                  ? profileData!['membresia_id']?.toString() ?? 'No membership ID'
                  : 'No membership ID',
              rightTitle: 'Status',
              rightValue: profileData != null && profileData!['activo'] == true
                  ? 'Activo'
                  : 'Inactivo',
            ),
            ProfileInfoRow(
              leftTitle: 'Password Reset Token',
              leftValue: profileData != null
                  ? profileData!['resetPasswordToken'] ?? 'No reset token'
                  : 'No reset token',
              rightTitle: 'Reset Expire',
              rightValue: profileData != null
                  ? profileData!['resetPasswordExpire'] ?? 'No expiration date'
                  : 'No expiration date',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String leftTitle;
  final String leftValue;
  final String rightTitle;
  final String rightValue;

  ProfileInfoRow({
    required this.leftTitle,
    required this.leftValue,
    required this.rightTitle,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileInfoCard(title: leftTitle, value: leftValue),
          ProfileInfoCard(title: rightTitle, value: rightValue),
        ],
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final String value;

  ProfileInfoCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


