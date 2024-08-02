import 'dart:convert';
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

  Future<void> fetchProfileData() async {
    final response = await http.get(Uri.parse('${Config.apiUrl}/users/1'));

    if (response.statusCode == 200) {
      setState(() {
        profileData = json.decode(response.body);
      });
    } else {
      // Manejar el error
      print('Error al obtener los datos del perfil: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              color: Color(0xFF6D3089),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(profileData != null ? profileData!['fotoPerfil'] : 'URL_DE_TU_IMAGEN_DE_PERFIL'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    profileData != null ? profileData!['nombre'] : 'Nombre del Usuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profileData != null ? profileData!['email'] : 'Email del Usuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, color: Colors.yellow, size: 16),
                      SizedBox(width: 5),
                      Text(
                        'Verified',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GENERAL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  MenuCard(
                    icon: Icons.settings,
                    title: 'Profile Settings',
                    subtitle: 'Update and modify your profile',
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: Icons.lock,
                    title: 'Privacy',
                    subtitle: 'Change your password',
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Change your notification settings',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Color(0xFF6D3089)),
        title: Text(title, style: TextStyle(fontSize: 18)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
