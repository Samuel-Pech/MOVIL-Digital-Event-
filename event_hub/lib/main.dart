
import 'package:event_hub/client_screens/profile_page.dart';
import 'package:event_hub/login_client.dart';
import 'package:flutter/material.dart';
import 'package:event_hub/default_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Event Hub',
      home: LoginClient(),
    );
  }
}