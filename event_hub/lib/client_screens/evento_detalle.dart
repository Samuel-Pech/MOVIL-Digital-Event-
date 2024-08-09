import 'package:flutter/material.dart';

class DetalleEvento extends StatelessWidget {
  final dynamic event;

  DetalleEvento({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF6D3089),
        title: Text(
          'Detalles del Evento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventImage(),
            _buildEventDetails(),
            _buildParticipateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage() {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            image: DecorationImage(
              image: NetworkImage(event['imagen_url'] ?? 'https://via.placeholder.com/250'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              event['evento_nombre']?.toString() ?? 'Nombre del Evento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailTitle('Detalles del Evento'),
          _buildDetailItem('Nombre', event['evento_nombre']),
          _buildDetailItem('Fecha de Inicio', event['fecha_inicio']),
          _buildDetailItem('Fecha de Término', event['fecha_termino']),
          _buildDetailItem('Hora', event['hora']),
          _buildDetailItem('Tipo de Evento', event['tipo_evento']),
          _buildDetailItem('Categoría', event['categoria']),
          _buildDetailItem('Ubicación', event['ubicacion']),
          _buildDetailItem('Máximo de Participantes', event['max_per']),
          _buildDetailItem('Estado', event['estado']),
          _buildDetailItem('Monto', event['monto']),
          _buildDetailItem('Autorizado por', event['autorizado_por']),
          _buildDetailItem('Fecha de Autorización', event['fecha_autorizacion']),
          _buildDetailItem('Validación ID', event['validacion_id']),
          _buildDetailItem('Forma de Escenario', event['forma_escenario']),
          _buildDetailItem('Descripción', event['descripcion']),
        ],
      ),
    );
  }

  Widget _buildDetailTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6D3089),
      ),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label: ${value?.toString() ?? 'No disponible'}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParticipateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            // Acción del botón
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6D3089),
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            'Participar',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
