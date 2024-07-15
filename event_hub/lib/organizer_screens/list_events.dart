import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_hub/config/conn_api.dart'; // Asegúrate de que este archivo exista y tenga la URL de la API

class ListEvents extends StatefulWidget {
  const ListEvents({Key? key}) : super(key: key);

  @override
  State<ListEvents> createState() => _ListEventsState();
}

class _ListEventsState extends State<ListEvents> {
  int _selectedIndex = 0;
  List<dynamic> _events = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final response = await http.get(
      Uri.parse('${Config.apiUrl}/event/get/img'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _events = jsonDecode(response.body);
      });
    } else {
      // Manejo de errores
      print('Error en la solicitud: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            'Brayan Canul Tamay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
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
                      MaterialPageRoute(builder: (context) => ListEvents()),
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
      body: _getBodyEvents(),
    );
  }

  Widget _getBodyEvents() {
    if (_events.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _events[index]['nombre'] ?? '',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Fecha: ${_events[index]['fecha_inicio']} - ${_events[index]['fecha_termino']}',
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Hora: ${_events[index]['hora']}',
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Ubicación: ${_events[index]['ubicacion']}',
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Estado: ${_events[index]['estado']}',
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  SizedBox(height: 8.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      _events[index]['imagen_url'] ?? '',
                      width: double.infinity,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      _deleteEvent(_events[index]['evento_id'].toString()); // Convertir a String si es necesario
                    },
                    child: Text('Eliminar'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    final url = Uri.parse('${Config.apiUrl}/event/delete'); // Actualiza la URL DELETE según tu API

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'evento_id': eventId}),
    );

    if (response.statusCode == 200) {
      // Eliminación exitosa, actualiza la lista de eventos
      _fetchEvents();
    } else {
      // Manejo de errores
      print('Error al eliminar el evento: ${response.statusCode}');
    }
  }
}
