import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Función para obtener los detalles del escenario por ID
Future<Map<String, dynamic>> fetchEscenario(int escenarioId) async {
  final response = await http.get(Uri.parse(
      'https://api-digitalevent.onrender.com/api/escenarios/$escenarioId'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load escenario');
  }
}

// Función para reservar un asiento
Future<void> reservarAsiento(
    int asientoId, String numeroAsiento, int usuarioId) async {
  final response = await http.put(
    Uri.parse('https://api-digitalevent.onrender.com/api/asientos/$asientoId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'numero_asiento': numeroAsiento,
      'estado': 'Reservado',
      'usuario_id': usuarioId,
    }),
  );

  if (response.statusCode == 200) {
    print('Asiento reservado con éxito');
  } else {
    throw Exception('Failed to reserve seat');
  }
}

// Página para reservar asientos
class ReservarAsientoPage extends StatefulWidget {
  final int escenarioId; // ID del escenario a mostrar

  ReservarAsientoPage({required this.escenarioId, required event});

  @override
  _ReservarAsientoPageState createState() => _ReservarAsientoPageState();
}

class _ReservarAsientoPageState extends State<ReservarAsientoPage> {
  late Future<Map<String, dynamic>> _escenario;
  late List<Map<String, dynamic>> _asientosDisponibles;
  final int _usuarioId = 1; // Reemplaza con el ID real del usuario

  @override
  void initState() {
    super.initState();
    _escenario = fetchEscenario(
        widget.escenarioId); // Usar el ID del escenario proporcionado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Asiento'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _escenario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            final escenario = snapshot.data!;
            final asientos = (escenario['asientos'] as List<dynamic>?) ?? [];

            // Asegúrate de que la conversión se realiza correctamente
            _asientosDisponibles = asientos.map((asiento) {
              final asientoMap = asiento as Map<String, dynamic>;
              return {
                'id': asientoMap['id'],
                'numero_asiento': asientoMap['numero_asiento'] ?? 'Desconocido',
                'estado': asientoMap['estado'] ?? 'Disponible'
              };
            }).toList();

            return _buildAsientosGrid();
          }
        },
      ),
    );
  }

  Widget _buildAsientosGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // Número de columnas
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _asientosDisponibles.length,
      itemBuilder: (context, index) {
        final asiento = _asientosDisponibles[index];
        final asientoId = asiento['id'];
        final numeroAsiento = asiento['numero_asiento'];
        final estado = asiento['estado'];

        Color color;
        if (estado == 'Reservado') {
          color = Colors.red;
        } else if (estado == 'Seleccionado') {
          color = Colors.yellow;
        } else {
          color = Colors.green;
        }

        return GestureDetector(
          onTap: () async {
            if (estado == 'Disponible') {
              try {
                await reservarAsiento(
                  asientoId,
                  numeroAsiento,
                  _usuarioId,
                );
                setState(() {
                  // Actualiza el estado del asiento después de la reserva
                  _asientosDisponibles[index]['estado'] = 'Reservado';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Asiento reservado con éxito')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al reservar asiento')),
                );
              }
            }
          },
          child: Container(
            color: color,
            child: Center(
              child: Text(
                numeroAsiento,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Navegación a la página ReservarAsientoPage
void navigateToReservarAsientoPage(BuildContext context, int escenarioId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ReservarAsientoPage(
        escenarioId: escenarioId,
        event: "",
      ),
    ),
  );
}
