import 'package:event_hub/client_screens/count_client.dart';
import 'package:event_hub/client_screens/notifications_page.dart';
import 'package:event_hub/client_screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:event_hub/config/conn_api.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  Map<String, dynamic>? profileData;
  int _selectedIndex = 0;

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


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Elimina el icono de "regresar"
        backgroundColor: Color(0xFF6D3089),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_3.png', // Ruta de tu imagen
              fit: BoxFit.contain,
              height: 32, // Altura de la imagen
            ),
            SizedBox(width: 8), // Espacio entre la imagen y el texto
            Text(
              'Digital Event Hub',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Align(
        alignment:
            Alignment.topRight, // Alinea el Drawer a la parte superior derecha
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.75, // Ajusta el ancho según sea necesario
          height: MediaQuery.of(context).size.height *
              0.75, // Ajusta la altura según sea necesario
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  child: Container(
                    height: 250.0, // Ajusta esta altura según sea necesario
                    color: Color(0xFF6D3089),
                    child: DrawerHeader(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors
                            .transparent, // Para que no sobreescriba el color del contenedor
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 95.0,
                          ),
                          SizedBox(height: 10.0),
                        Text(
                      profileData != null ? '${profileData!['nombre']} ${profileData!['last_name']}'  : 'Cargando...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                          SizedBox(height: 5.0),
                          Text(
                            'Cliente de Digital Event Hub',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil'),
                  onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Historial de compras'),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemTapped(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notificaciones'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text('Eventos próximos'),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemTapped(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Acerca de'),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemTapped(0);
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: _selectedIndex == 0
          ? Center(child: Text('Home Cliente'))
          : CountClient(), // Usa la pantalla de cuenta aquí
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cuenta',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

