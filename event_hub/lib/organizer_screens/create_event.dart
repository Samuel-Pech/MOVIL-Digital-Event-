import 'package:flutter/material.dart';

class CreateEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Añadido
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15),
              Center( 
                child: Text(
                  'Registrar datos del evento:',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 32),
              Text(
                'Nombre del evento:',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.purple[50],
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),
              Text(
                'Descripción:',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.purple[50],
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),
              Text(
                'Fecha del evento:',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.purple[50],
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),
              Text(
                'URL de la imágen:',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.purple[50],
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),
              Text(
                'Hora de inicio:',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.purple[50],
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),
              Text(
                'Hora de término:',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.purple[50],
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6D3089), // Background color
                      padding: EdgeInsets.symmetric(vertical: 20), // Padding inside the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      // Define what happens when the button is pressed
                    },
                    child: Text(
                      'Registrar este evento',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
