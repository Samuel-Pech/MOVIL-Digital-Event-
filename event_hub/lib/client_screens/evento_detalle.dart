import 'dart:convert';
import 'package:event_hub/client_screens/comentarios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class DetalleEvento extends StatefulWidget {
  final dynamic event;

  DetalleEvento({required this.event});

  @override
  _DetalleEventoState createState() => _DetalleEventoState();
}

class _DetalleEventoState extends State<DetalleEvento> {
  bool _isLoading = false;
  bool _hasPaid = false;

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
            _isLoading
                ? _buildLoadingIndicator()
                : Column(
                    children: [
                      _buildParticipateButton(context),
                      _hasPaid
                          ? _buildCommentsButton(context)
                          : _buildPaymentRequiredBox(),
                    ],
                  ),
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
              image: NetworkImage(widget.event['imagen_url'] ??
                  'https://via.placeholder.com/250'),
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
              widget.event['evento_nombre']?.toString() ?? 'Nombre del Evento',
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
          _buildDetailItem('Nombre', widget.event['evento_nombre']),
          _buildDetailItem('Fecha de Inicio', widget.event['fecha_inicio']),
          _buildDetailItem('Fecha de Término', widget.event['fecha_termino']),
          _buildDetailItem('Hora', widget.event['hora']),
          _buildDetailItem('Tipo de Evento', widget.event['tipo_evento']),
          _buildDetailItem('Categoría', widget.event['categoria']),
          _buildDetailItem('Ubicación', widget.event['ubicacion']),
          _buildDetailItem('Máximo de Participantes', widget.event['max_per']),
          _buildDetailItem('Estado', widget.event['estado']),
          _buildDetailItem('Monto', widget.event['monto']),
          _buildDetailItem('Autorizado por', widget.event['autorizado_por']),
          _buildDetailItem(
              'Fecha de Autorización', widget.event['fecha_autorizacion']),
          _buildDetailItem('Validación ID', widget.event['validacion_id']),
          _buildDetailItem(
              'Forma de Escenario', widget.event['forma_escenario']),
          _buildDetailItem('Descripción', widget.event['descripcion']),
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

  Widget _buildParticipateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            try {
              await makePayment(context);
              setState(() {
                _hasPaid = true;
              });
            } catch (e) {
              _showPaymentErrorDialog(context, e.toString());
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
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

  Widget _buildCommentsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ComentariosPage(eventId: widget.event['evento_id']),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6D3089),
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            'Ver Comentarios',
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

  Widget _buildPaymentRequiredBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            _showPaymentRequiredDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6D3089),
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            'Ver Comentarios',
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

  void _showPaymentRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pago Requerido'),
          content:
              Text('Debe realizar el pago para acceder a los comentarios.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D3089)),
      ),
    );
  }

  Future<String> createPaymentIntent(int amount, String currency) async {
    try {
      final body = jsonEncode({
        'amount': amount,
        'currency': currency,
      });
      final response = await http.post(
        Uri.parse('https://api-digitalevent.onrender.com/api/pagos/pago'),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final paymentIntentData = jsonDecode(response.body);
        final clientSecret = paymentIntentData['client_secret'] as String;
        return clientSecret;
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      throw Exception('Failed to create payment intent');
    }
  }

  Future<void> makePayment(BuildContext context) async {
    try {
      double amount =
          double.tryParse(widget.event['monto']?.toString() ?? '0.0') ?? 0.0;
      if (amount <= 0) {
        throw Exception('Monto del evento no es válido.');
      }

      int amountInCents = (amount * 100).round();
      String currency = 'mxn';

      final clientSecret = await createPaymentIntent(amountInCents, currency);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'EventHub',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pago realizado con éxito')),
      );
    } catch (e) {
      throw Exception('Error en el proceso de pago: ${e.toString()}');
    }
  }

  void _showPaymentErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error en el Pago'),
          content: Text("error"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
