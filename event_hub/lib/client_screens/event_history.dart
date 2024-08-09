import 'package:flutter/material.dart';

class EventHistory extends StatefulWidget {
  const EventHistory({super.key});

  @override
  State<EventHistory> createState() => _EventHistoryState();
}

class _EventHistoryState extends State<EventHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historial de Compras',
          style: TextStyle(
            fontSize: 20, // Tamaño de la fuente
            fontWeight: FontWeight.bold, // Negrita
            color: Colors.white, // Color del texto
          ),
        ),
        backgroundColor: Color(0xFF6D3089),
        iconTheme: IconThemeData(
          color: Colors.white, // Cambia el color de la flechita para regresar
        ),
      ),
      body: Center(
        child: Text(
          'Aquí se mostrará el historial de compras.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
