import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'home_init.dart'; // Asegúrate de importar el archivo correcto

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51PXQwjRvOexYqm868BaEds2SOFXYVM32nhnnBCKNUvDiyf14mBpHoFETJYJ7kdLPrQ2VuXHLp5hwgJsHMlYCl6x400OGvYJj9h";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Event Hub',
      home: HomeInit(), // Cambia aquí a HomeInit
    );
  }
}
