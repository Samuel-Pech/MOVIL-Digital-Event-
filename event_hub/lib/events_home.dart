import 'package:event_hub/detalle_evento.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EventHome(),
    );
  }
}

class Event {
  final String imageUrl;
  final String name;
  final String date;
  final String startTime;
  final String endTime;

  Event(this.imageUrl, this.name, this.date, this.startTime, this.endTime);
}

class EventHome extends StatelessWidget {
  final List<Event> events = [
    Event(
      'https://th.bing.com/th/id/OIP.G4959HgFVFHseN1Fe26-ngAAAA?rs=1&pid=ImgDetMain',
      'Evento de Nieve',
      '12-12-2024',
      '10:00 AM',
      '12:00 PM',
    ),
    Event(
      'https://th.bing.com/th/id/OIP.sAtJ_g3i2aqgyTTQ0Seh1wHaGL?w=800&h=667&rs=1&pid=ImgDetMain',
      'Evento de Montaña',
      '15-12-2024',
      '02:00 PM',
      '05:00 PM',
    ),
    Event(
      'https://th.bing.com/th/id/R.b63d88f81c195528435fd0b8186f9d4c?rik=YOdph7bUCytuQw&riu=http%3a%2f%2fimagenes.4ever.eu%2fdata%2fdownload%2fanimales%2fsalvajes%2frenos%2c-nieve-220586.jpg&ehk=I%2fr%2fYyHsnjDHH%2frhFpA4iJatyb3eq7QqXYLkl%2fIUjKg%3d&risl=&pid=ImgRaw&r=0',
      'Evento de Animales',
      '20-12-2024',
      '09:00 AM',
      '11:00 AM',
    ),
    // Agrega más eventos aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 28.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
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
                          events[index].imageUrl,
                          height: 180.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(226, 0, 0, 0),
                                  Color.fromARGB(28, 0, 0, 0)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  ' ${events[index].startTime} - ${events[index].endTime}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Fecha: ${events[index].date}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            events[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.favorite,
                                    color: Color.fromARGB(255, 183, 20, 8)),
                                label: Text(
                                  'Like',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.comment,
                                    color: Color.fromARGB(255, 1, 64, 115)),
                                label: Text(
                                  'Comenta',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetalleEvento()),
                                  );
                                },
                                icon: Icon(Icons.info,
                                    color: Color.fromARGB(255, 1, 64, 115)),
                                label: Text(
                                  'Ver',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
