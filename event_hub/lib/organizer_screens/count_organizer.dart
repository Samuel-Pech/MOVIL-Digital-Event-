import 'package:flutter/material.dart';

class CountOrganizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.5q5jb3VzIHsa8xgJGGHPlQHaHa?rs=1&pid=ImgDetMain'), // Reemplaza con la URL de tu imagen
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Brayan Canul Tamay',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 73, 21, 97),
                    ),
                  ),
                  Text(
                    'Ver perfil',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 73, 21, 97),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Configuración',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 73, 21, 97),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text(
              'Membresía',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Visibilidad del perfil',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
        
          ListTile(
            title: Text(
              'Cuentas conectadas',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Permisos sociales',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Notificaciones',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Privacidad y datos',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Centro para denuncias e infracciones',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text(
              'Seguridad',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Cerrar sesión',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Borrar mi cuenta',
              style: TextStyle(color: Color.fromARGB(255, 73, 21, 97),),
            ),
            trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 73, 21, 97),),
            onTap: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white, // Color de fondo negro
    );
  }
}
