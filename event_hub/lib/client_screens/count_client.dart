import 'package:event_hub/client_screens/profile_page.dart';
import 'package:event_hub/login_client.dart';
import 'package:flutter/material.dart';
import 'package:event_hub/config/conn_api.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;

class CountClient extends StatefulWidget {
  @override
  _CountClientState createState() => _CountClientState();
}

class _CountClientState extends State<CountClient> {
  Map<String, dynamic>? profileData;

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
      });
    } else {
      // Manejar el error
      print('Error al obtener los datos del perfil: ${response.statusCode}');
    }
  }

  Future<void> fetchDeleteProfile() async {
    // Verificar si usuarioId no es null antes de continuar
    if (UserData.usuarioId == null) {
      print('Error: usuarioId es null');
      return;
    }

    final response = await http.delete(Uri.parse('${Config.apiUrl}/users/${UserData.usuarioId}'));

    if (response.statusCode == 200) {
      setState(() {
        profileData = null;
      });
      print('Cuenta borrada con éxito');
    } else {
      // Manejar el error
      print('Error al borrar la cuenta: ${response.statusCode}');
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar borrado de cuenta'),
          content: Text('¿Estás seguro de que deseas borrar tu cuenta? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo
                await fetchDeleteProfile(); // Llama a la función para borrar la cuenta
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      'https://th.bing.com/th/id/OIP.5q5jb3VzIHsa8xgJGGHPlQHaHa?rs=1&pid=ImgDetMain'), // Reemplaza con la URL de tu imagen
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profileData != null ? '${profileData!['nombre']} ${profileData!['last_name']}' : 'Cargando...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 73, 21, 97),
                      ),
                    ),
                    Text(
                      'Ver perfil',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 73, 21, 97),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Configuración',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text(
              'Membresía',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Visibilidad del perfil',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Cuentas conectadas',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Permisos sociales',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Notificaciones',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Privacidad y datos',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Centro para denuncias e infracciones',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: () {},
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text(
              'Seguridad',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginClient(),
                        )
                      );
            },
          ),
          ListTile(
            title: Text(
              'Borrar mi cuenta',
              style: TextStyle(
                color: Color.fromARGB(255, 73, 21, 97),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
            onTap: _confirmDeleteAccount,
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
