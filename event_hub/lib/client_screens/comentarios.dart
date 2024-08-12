import 'package:event_hub/config/conn_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Comentario {
  final int comentarioId;
  final int usuarioId;
  final int eventoId;
  final String comentario;
  final String fecha;
  final String usuarioNombre;

  Comentario({
    required this.comentarioId,
    required this.usuarioId,
    required this.eventoId,
    required this.comentario,
    required this.fecha,
    required this.usuarioNombre,
    this.fotoPerfil, // Añadido en el constructor
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['fecha']);
    String formattedDate = DateFormat('d/M/yyyy').format(parsedDate);

    return Comentario(
      comentarioId: json['comentario_id'],
      usuarioId: json['usuario_id'],
      eventoId: json['evento_id'],
      comentario: json['comentario'],
      fecha: formattedDate,
      usuarioNombre: json['usuario_nombre'],
      fotoPerfil: json['foto_perfil'], // Añadido para la foto de perfil
    );
  }
}

class ComentariosPage extends StatefulWidget {
  final int eventId;

  ComentariosPage({required this.eventId});

  @override
  _ComentariosPageState createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  List<Comentario> comentarios = [];
  final TextEditingController _commentController = TextEditingController();
  bool hasMore = true;
  bool isLoading = false;
  int currentPage = 1;
  Map<int, String?> userPhotos = {}; // Cache para fotos de perfil

  @override
  void initState() {
    super.initState();
    fetchComentarios();
  }

  Future<void> fetchComentarios({int page = 1}) async {
    final String url =
        'https://api-digitalevent.onrender.com/api/comentario/list/${widget.eventId}?page=$page&limit=10';

    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> comentariosData = jsonDecode(response.body);
        print('Comentarios recibidos: $comentariosData');

        setState(() {
          if (comentariosData.isEmpty) {
            hasMore = false;
          } else {
            comentarios.addAll(
              comentariosData
                  .map((comentarioJson) => Comentario.fromJson(comentarioJson))
                  .toList(),
            );
            currentPage++;
          }
        });

        // Cargar las fotos de perfil de los usuarios
        await loadUserPhotos(); // Asegúrate de esperar esta llamada
      } else {
        throw Exception('Error al obtener los comentarios: ${response.body}');
      }
    } catch (e) {
      print('Ocurrió un error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadUserPhotos() async {
    final List<int> userIds =
        comentarios.map((c) => c.usuarioId).toSet().toList();

    for (int userId in userIds) {
      final String url =
          'https://api-digitalevent.onrender.com/api/users/$userId';

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final Map<String, dynamic> userData = jsonDecode(response.body);
          print(
              'Datos del usuario $userId: $userData'); // Agregado para depuración
          setState(() {
            userPhotos[userId] = userData['foto_perfil'];
          });
        } else {
          throw Exception(
              'Error al obtener la foto de perfil del usuario $userId: ${response.body}');
        }
      } catch (e) {
        print('Ocurrió un error al obtener la foto de perfil: $e');
      }
    }
  }

  Future<void> sendComment(String commentText) async {
    final String url =
        'https://api-digitalevent.onrender.com/api/comentario/create';

    if (UserData.usuarioId == null) {
      print('Error: No se ha establecido el ID del usuario.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'evento_id': widget.eventId,
          'usuario_id': int.parse(UserData.usuarioId!),
          'comentario': commentText,
          'fecha': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        }),
      );

      print('Respuesta del servidor: ${response.body}');

      if (response.statusCode == 201) {
        fetchComentarios();
        _commentController.clear();
      } else {
        print('Error al enviar el comentario: ${response.body}');
        throw Exception('Error al enviar el comentario');
      }
    } catch (e) {
      print('Ocurrió un error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6D3089),
        title: Text(
          'Comentarios',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: comentarios.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == comentarios.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (hasMore) {
                            fetchComentarios(page: currentPage);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF6D3089),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                hasMore
                                    ? 'Cargar más'
                                    : 'No hay más comentarios',
                                style: TextStyle(fontSize: 16.0),
                              ),
                      ),
                    ),
                  );
                } else {
                  return Card(
                    elevation: 2.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userPhotos[comentarios[index].usuarioId] != null
                              ? CircleAvatar(
                                  radius: 24.0,
                                  backgroundImage: NetworkImage(userPhotos[
                                      comentarios[index].usuarioId]!),
                                )
                              : CircleAvatar(
                                  radius: 24.0,
                                  backgroundColor:
                                      Color(0xFF6D3089).withOpacity(0.2),
                                  child: Text(
                                    comentarios[index]
                                        .usuarioNombre[0]
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  ),
                                ),
                          SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comentarios[index].usuarioNombre,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  comentarios[index].comentario,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  comentarios[index].fecha,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Escribe tu comentario...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    sendComment(_commentController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6D3089),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: Text(
                    'Enviar',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
