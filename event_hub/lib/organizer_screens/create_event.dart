import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaTerminoController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('http://localhost:4000/api/event/post/img'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Evento registrado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar el evento')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      controller.text = selectedDate.toIso8601String().split('T').first;
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      controller.text = selectedTime.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                _buildTextField('Nombre del evento', 'nombre', TextInputType.text),
                _buildDateField('Fecha de inicio', 'fecha_inicio', _fechaInicioController),
                _buildDateField('Fecha de término', 'fecha_termino', _fechaTerminoController),
                _buildTextField('Hora', 'hora', TextInputType.text),
                _buildDropdownField('ID del tipo de evento', 'tipo_evento_id', [1, 2]),
                _buildDropdownField('ID del organizador', 'organizador_id', [1, 2]),
                _buildDropdownField('ID de la categoría', 'categoria_id', [1, 2]),
                _buildTextField('Ubicación', 'ubicacion', TextInputType.text),
                _buildTextField('Máximo de personas', 'max_per', TextInputType.number),
                _buildTextField('Estado', 'estado', TextInputType.text),
                _buildDropdownField('Autorizado por', 'autorizado_por', [1, 2]),
                _buildDateField('Fecha de autorización', 'fecha_autorizacion', TextEditingController()),
                _buildDropdownField('ID de validación', 'validacion_id', [1, 2]),
                _buildTextField('URL img', 'imagen_url', TextInputType.text),
                SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6D3089),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _submitForm,
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
      ),
    );
  }

  Widget _buildTextField(String label, String key, TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          TextFormField(
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese $label';
              }
              return null;
            },
            onSaved: (value) {
              if (keyboardType == TextInputType.number) {
                _formData[key] = int.tryParse(value!) ?? 0;
              } else {
                _formData[key] = value!;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, String key, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onTap: () => _selectDate(context, controller),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, seleccione $label';
              }
              return null;
            },
            onSaved: (value) {
              _formData[key] = value!;
            },
          ),
        ],
      ),
    );
  }

   Widget _buildTimeField(String label, String key, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onTap: () => _selectTime(context, controller),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, seleccione $label';
              }
              return null;
            },
            onSaved: (value) {
              _formData[key] = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String key, List<int> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: items.map((int value ) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return 'Por favor, seleccione $label';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _formData[key] = value!;
              });
            },
            onSaved: (value) {
              _formData[key] = value!;
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreateEvent(),
  ));
}
