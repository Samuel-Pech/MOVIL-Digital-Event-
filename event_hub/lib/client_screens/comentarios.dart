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

  final List<String> _prohibitedWords = [
    'idiota',
    'idiotas',
    'imbécil',
    'estúpido',
    'maleducado',
    'pendejo',
    'zorra',
    'maricón',
    'puta',
    'hijo de puta',
    'cabron',
    'coño',
    'mierda',
    'polla',
    'chingar',
    'verga',
    'pito',
    'eres un estúpido',
    'no vales nada',
    'eres una mierda',
    'vete al carajo',
    'eres un inútil',
    'no sirves para nada',
    'eres un maldito',
    'te odio',
    'eres un desastre'
  ];

  @override
  void initState() {
    super.initState();
    fetchComentarios();
  }

  Future<void> fetchComentarios({int page = 1, bool reset = false}) async {
    final String url =
        'https://api-digitalevent.onrender.com/api/comentario/list/${widget.eventId}?page=$page&limit=10';

    if (isLoading || (!hasMore && !reset)) return;

    setState(() {
      isLoading = true;
      if (reset) {
        comentarios.clear();
        currentPage = 1;
        hasMore = true;
      }
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

  String _censurarComentario(String comentario) {
    final commentWords = comentario.toLowerCase().split(RegExp(r'\s+'));
    final censoredWords = commentWords.map((word) {
      return _prohibitedWords.contains(word) ? '*' * word.length : word;
    }).join(' ');

    return censoredWords;
  }

  Future<void> sendComment(String commentText) async {
    final String url =
        'https://api-digitalevent.onrender.com/api/comentario/create';

    if (UserData.usuarioId == null) {
      print('Error: No se ha establecido el ID del usuario.');
      return;
    }

    final censoredComment = _censurarComentario(commentText);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'evento_id': widget.eventId,
          'usuario_id': int.parse(UserData.usuarioId!),
          'comentario': censoredComment,
          'fecha': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        }),
      );

      print('Respuesta del servidor: ${response.body}');

      if (response.statusCode == 201) {
        _commentController.clear();
        fetchComentarios(reset: true);
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
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  final comentario = comentarios[index];
                  return Card(
                    elevation: 5.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Text(
                                  comentario.usuarioNombre[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.0),
                              Text(
                                comentario.usuarioNombre,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _censurarComentario(comentario.comentario),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            comentario.fecha,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600],
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un comentario...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      sendComment(_commentController.text);
                    }
                  },
                  color: Color(0xFF6D3089),
                  iconSize: 30.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
