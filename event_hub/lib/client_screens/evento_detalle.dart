import 'dart:convert';
import 'package:event_hub/client_screens/comentarios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetalleEvento extends StatefulWidget {
  final dynamic event;

  DetalleEvento({required this.event});

  @override
  _DetalleEventoState createState() => _DetalleEventoState();
}

class _DetalleEventoState extends State<DetalleEvento> {
  bool _isLoading = false;
  bool _hasPaid = false;

  String _formatDate(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(dateTime);
    } catch (e) {
      return 'Fecha no disponible';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFF6D3089),
        title: Text(
          'Detalles del Evento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventImage(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildDetailsContainer(),
            ),
            if (_isLoading) _buildLoadingIndicator(),
            if (!_isLoading) ...[
              if (!_hasPaid) _buildPaymentButton(),
              if (_hasPaid) _buildCommentsButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0)),
        image: DecorationImage(
          image: NetworkImage(
              widget.event['imagen_url'] ?? 'https://via.placeholder.com/250'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              widget.event['evento_nombre']?.toString() ?? 'Nombre del Evento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem(Icons.calendar_today, 'Fecha',
              _formatDate(widget.event['fecha_inicio'])),
          _buildDetailItem(
              Icons.location_on, 'Ubicación', widget.event['ubicacion']),
          _buildDetailItem(
              Icons.category, 'Categoría', widget.event['categoria']),
          _buildDetailItem(Icons.attach_money, 'Costo', widget.event['monto']),
          _buildDetailItem(
              Icons.description, 'Descripción', widget.event['descripcion']),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF6D3089), size: 24.0),
          SizedBox(width: 16.0),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: '$label:\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  TextSpan(
                    text: label == 'Costo'
                        ? '${value?.toString() ?? 'No disponible'} MXN'
                        : value?.toString() ?? 'No disponible',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: ElevatedButton(
          onPressed: _handlePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6D3089),
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Colors.white, width: 2),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          child: Text(
            'Realizar Pago',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsButton() {
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
            elevation: 5,
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

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D3089)),
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    setState(() {
      _isLoading = true;
    });

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

      setState(() {
        _hasPaid = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pago realizado con éxito')),
      );
    } catch (e) {
      _showPaymentErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        return paymentIntentData['client_secret'] as String;
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (err) {
      throw Exception('Error al crear el intent de pago: $err');
    }
  }

  void _showPaymentErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pago Cancelado'),
        content:
            Text("No se pudo realizar el pago. Vuelva a intentarlo mas tarde."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
