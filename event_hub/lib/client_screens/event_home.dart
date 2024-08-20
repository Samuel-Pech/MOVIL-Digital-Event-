import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:event_hub/client_screens/evento_detalle.dart';

class EventHome extends StatefulWidget {
  @override
  _EventHomeState createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<dynamic> events = [];
  bool isLoading = true;
  bool isFirstLoad = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api-digitalevent.onrender.com/api/events/get/approved'));

      if (response.statusCode == 200) {
        final List<dynamic> fetchedEvents = json.decode(response.body);
        setState(() {
          events = fetchedEvents;
          isLoading = false;
          if (isFirstLoad) {
            _animationController
                .forward(); // Inicia la animación solo en la primera carga
            isFirstLoad = false;
          }
        });
        for (int i = 0; i < events.length; i++) {
          _listKey.currentState?.insertItem(i);
        }
      } else {
        print('Error al cargar eventos');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error al obtener eventos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Color de fondo sutil
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Muestra el indicador de carga
            )
          : AnimatedList(
              key: _listKey,
              initialItemCount: events.length,
              itemBuilder: (context, index, animation) {
                final event = events[index];
                final imageUrl = event['imagen_url'];

                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return ScaleTransition(
                      scale: _animation,
                      child: child,
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 6, // Elevación para sombras suaves
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
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
                                      return Container(
                                        height: 180.0,
                                        color: Colors.grey[
                                            300], // Fondo para imagen de error
                                        child: Icon(Icons.error,
                                            color: Colors.red, size: 50.0),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        'Evento',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                event['evento_nombre'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
                              child: Text(
                                'Ubicación: ${event['ubicacion'] ?? 'No especificada'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
