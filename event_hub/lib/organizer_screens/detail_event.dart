import 'package:flutter/material.dart';

class DetailEvent extends StatelessWidget {
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
          'Detalle del evento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 540,
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 75, 4, 97)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Datos del evento:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Aquí puedes agregar más contenido relacionado con los datos del evento
                    Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Aquí irán los datos del evento"),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 11, 85, 146), // Background color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      // Acción para editar el evento
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text('Editar evento'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 125, 23, 16), // Background color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      // Acción para borrar el evento
                    },
                    icon: Icon(Icons.delete, color: Colors.white),
                    label: Text('Borrar evento'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
