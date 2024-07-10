import 'package:event_hub/events_home.dart';
import 'package:flutter/material.dart';
import 'login_type.dart'; // Importa el archivo de la pantalla de cuenta

class DefaultHome extends StatefulWidget {
  @override
  _DefaultHomeState createState() => _DefaultHomeState();
}

class _DefaultHomeState extends State<DefaultHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6D3089),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_3.png', // Ruta de tu imagen
              fit: BoxFit.contain,
              height: 32, // Altura de la imagen
            ),
            SizedBox(width: 8), // Espacio entre la imagen y el texto
            Text(
              'Digital Event Hub',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),

      body: _selectedIndex == 0 
        ? EventHome() 

        : LoginType(), // Usa la pantalla de cuenta aquí

        
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cuenta',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
