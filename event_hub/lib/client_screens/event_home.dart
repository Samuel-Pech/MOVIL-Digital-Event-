import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:event_hub/client_screens/evento_detalle.dart'; // Asegúrate de importar la pantalla de detalles

class EventHome extends StatefulWidget {
  @override
  _EventHomeState createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  List<dynamic> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final response = await http.get(Uri.parse(
        'https://api-digitalevent.onrender.com/api/events/get/approved'));

    if (response.statusCode == 200) {
      setState(() {
        events = json.decode(response.body);
      });
    } else {
      print('Error al cargar eventos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final imageUrl = event['imagen_url'];

          return Container(
            margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 28.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleEvento(event: event),
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                            imageUrl != null && imageUrl.isNotEmpty
                                ? imageUrl
                                : 'https://via.placeholder.com/150', // Imagen por defecto
                            height: 180.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error,
                                  color: Colors.red, size: 50.0);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          event[
                              'evento_nombre'], // Mostramos solo el nombre del evento
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
