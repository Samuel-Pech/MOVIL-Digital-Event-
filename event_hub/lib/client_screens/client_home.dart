import 'package:event_hub/client_screens/count_client.dart';
import 'package:event_hub/client_screens/notifications_page.dart';
import 'package:event_hub/client_screens/profile_page.dart';
import 'package:event_hub/client_screens/event_history.dart';
import 'package:flutter/material.dart';
import 'package:event_hub/config/conn_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'event_home.dart'; // Importa el nuevo archivo

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
    if (UserData.usuarioId == null) {
      print('Error: usuarioId es null');
      return;
    }

    final response = await http
        .get(Uri.parse('${Config.apiUrl}/users/${UserData.usuarioId}'));

    if (response.statusCode == 200) {
      setState(() {
        profileData = json.decode(response.body);
      });
    } else {
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
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF6D3089),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_3.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            SizedBox(width: 8),
            Text(
              'Digital Event Hub',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6D3089),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              accountName: Text(
                profileData != null
                    ? '${profileData!['nombre']} ${profileData!['last_name']}'
                    : 'Cargando...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                'Cliente de Digital Event Hub',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              currentAccountPicture: profileData != null &&
                      profileData!['fotoPerfil'] != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(profileData!['fotoPerfil']),
                    )
                  : Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 60.0,
                    ),
            ),
            _createDrawerItem(
              icon: Icons.account_circle,
              text: 'Perfil',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage())),
            ),
            _createDrawerItem(
              icon: Icons.history,
              text: 'Historial de compras',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventHistory(
                            userId: '',
                          ))),
            ),
            _createDrawerItem(
              icon: Icons.notifications,
              text: 'Notificaciones',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationsPage())),
            ),
            _createDrawerItem(
              icon: Icons.calendar_month,
              text: 'Eventos próximos',
              onTap: () => _onItemTapped(0),
            ),
            _createDrawerItem(
              icon: Icons.info,
              text: 'Acerca de',
              onTap: () => _onItemTapped(0),
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0 ? EventHome() : CountClient(),
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
        selectedItemColor: Color(0xFF6D3089),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  ListTile _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF6D3089)),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
