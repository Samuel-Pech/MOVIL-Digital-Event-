import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Importa la librería intl

class Payment {
  final int pagoId;
  final String monto;
  final String fecha;
  final int tipoPagoId;
  final int eventoId;

  Payment({
    required this.pagoId,
    required this.monto,
    required this.fecha,
    required this.tipoPagoId,
    required this.eventoId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      pagoId: json['pago_id'] ?? 0,
      monto: json['monto'] ?? '0.0',
      fecha: json['fecha'] ?? '',
      tipoPagoId: json['tipo_pago_id'] ?? 0,
      eventoId: json['evento_id'] ?? 0,
    );
  }
}

class EventHistory extends StatefulWidget {
  @override
  _EventHistoryState createState() => _EventHistoryState();
}

class _EventHistoryState extends State<EventHistory> {
  List<Payment> payments = [];

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    final String url =
        'https://api-digitalevent.onrender.com/api/pagos/historialpagos';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> paymentsData = jsonDecode(response.body);

        setState(() {
          payments = paymentsData
              .map((paymentJson) => Payment.fromJson(paymentJson))
              .toList();
        });
      } else {
        throw Exception('Error al obtener los pagos');
      }
    } catch (e) {
      print('Ocurrió un error: $e');
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'Fecha no disponible';
    DateTime dateTime = DateTime.parse(dateStr);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6D3089),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16), // Espacio adicional al principio
            Expanded(
              child: payments.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final payment = payments[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Monto:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      '\$${payment.monto}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Divider(thickness: 1, color: Colors.grey[300]),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Fecha:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      _formatDate(payment.fecha),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tipo de Pago:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      '${payment.tipoPagoId}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Evento:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      '${payment.eventoId}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
