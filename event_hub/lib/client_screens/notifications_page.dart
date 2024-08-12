import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_hub/config/conn_api.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex = 0;
  Map<String, dynamic>? profileData;
  List<dynamic> _notifications = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    if (UserData.usuarioId == null) {
      print('Error: usuarioId es null');
      return;
    }

    final response = await http
        .get(Uri.parse('${Config.apiUrl}/users/${UserData.usuarioId}'));
    print('Usuario PROFILE ID: ${UserData.usuarioId}');

    if (response.statusCode == 200) {
      setState(() {
        profileData = json.decode(response.body);
      });
    } else {
      print('Error al obtener los datos del perfil: ${response.statusCode}');
    }
  }

  Future<void> _fetchNotifications() async {
    final response =
        await http.get(Uri.parse('${Config.apiUrl}/notification/getAll'));

    if (response.statusCode == 200) {
      setState(() {
        _notifications = jsonDecode(response.body);
      });
    } else {
      print('Error en la solicitud: ${response.statusCode}');
    }
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
        alignment: Alignment.topRight,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.75,
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
                    height: 250.0,
                    color: Color(0xFF6D3089),
                    child: DrawerHeader(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
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
                            profileData != null
                                ? '${profileData!['nombre']} ${profileData!['last_name']}'
                                : 'Cargando...',
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
                    Navigator.pop(context);
                    _onItemTapped(1);
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
      body: _getBodyNotifications(),
    );
  }

  Widget _getBodyNotifications() {
    if (_notifications.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(15.0),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_notifications[index]
                          ['avatarUrl'] ??
                      'https://via.placeholder.com/150'),
                  radius: 25.0,
                ),
                title: Text(
                  _notifications[index]['titulo'] ?? 'Notificación',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.0),
                    Text(
                      _notifications[index]['mensaje'] ?? '',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      _notifications[index]['fecha_envio'] ?? '',
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
