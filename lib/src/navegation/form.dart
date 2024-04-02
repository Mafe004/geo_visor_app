import 'package:flutter/material.dart';

void main() {
  runApp(FormExampleApp());
}

class FormExampleApp extends StatelessWidget {
  const FormExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Información',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormularioInformacion(),
    );
  }
}

class FormData {
  String ubicacion = '';
  String tipoLugar = '';
  String estadoCarreteras = '';
  String serviciosBasicos = '';
  String estadoEdificaciones = '';
  String calidadAgua = '';
  String fuentesAgua = '';
  String problemasAgua = '';
  String tipoSuministroAgua = '';
  String estadoTratamientoAgua = '';
  String cortesAgua = '';
  String tipoAlcantarillado = '';
  String estadoTratamientoAlcantarillado = '';
  String problemasEspecificos = '';
  String comentariosAdicionales = '';
}

class FormularioInformacion extends StatefulWidget {
  @override
  _FormularioInformacionState createState() => _FormularioInformacionState();
}

class _FormularioInformacionState extends State<FormularioInformacion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormData _formData = FormData();

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Información'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_formKey.currentState != null &&
              _formKey.currentState!.validate()) {
            setState(() {
              _currentStep += 1;
            });
            _saveFormData(); // Guardar datos al avanzar
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Información general del lugar'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Ubicación (solo en Cundinamarca)'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Por favor ingresa la ubicación';
                    } else if (value != null &&
                        !value.toLowerCase().contains('cundinamarca')) {
                      return 'La ubicación debe estar dentro de Cundinamarca';
                    }
                    return null;
                  },
                  onChanged: (value) => _formData.ubicacion = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Tipo de lugar'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Por favor ingresa el tipo de lugar';
                    }
                    return null;
                  },
                  onChanged: (value) => _formData.tipoLugar = value,
                ),
              ],
            ),
          ),
          Step(
            title: Text('Infraestructura'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Estado de las carreteras o calles de acceso'),
                  onChanged: (value) =>
                  _formData.estadoCarreteras = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Disponibilidad de servicios básicos'),
                  onChanged: (value) =>
                  _formData.serviciosBasicos = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Estado de edificaciones cercanas'),
                  onChanged: (value) =>
                  _formData.estadoEdificaciones = value,
                ),
              ],
            ),
          ),
          Step(
            title: Text('Agua'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Calidad del agua'),
                  onChanged: (value) => _formData.calidadAgua = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Fuentes de agua cercanas'),
                  onChanged: (value) => _formData.fuentesAgua = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Problemas específicos relacionados con el agua'),
                  onChanged: (value) => _formData.problemasAgua = value,
                ),
              ],
            ),
          ),
          Step(
            title: Text('Sistemas de Agua'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Tipo de suministro de agua'),
                  onChanged: (value) =>
                  _formData.tipoSuministroAgua = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText:
                      'Estado de las instalaciones de tratamiento de agua'),
                  onChanged: (value) =>
                  _formData.estadoTratamientoAgua = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Frecuencia y duración de cortes de agua'),
                  onChanged: (value) => _formData.cortesAgua = value,
                ),
              ],
            ),
          ),
          Step(
            title: Text('Infraestructura de alcantarillado'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Tipo de sistema de alcantarillado'),
                  onChanged: (value) =>
                  _formData.tipoAlcantarillado = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText:
                      'Estado de las instalaciones de tratamiento de aguas residuales'),
                  onChanged: (value) =>
                  _formData.estadoTratamientoAlcantarillado = value,
                ),
              ],
            ),
          ),
          Step(
            title: Text('Problemas específicos'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Descripción detallada de cualquier problema específico'),
                  onChanged: (value) =>
                  _formData.problemasEspecificos = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Fotos o archivos adjuntos'),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Comentarios adicionales'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Comentarios adicionales'),
                  onChanged: (value) =>
                  _formData.comentariosAdicionales = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveFormData() {
    // Aquí puedes guardar los datos de _formData donde desees, por ejemplo:
    print('Datos guardados:');
    print('Ubicación: ${_formData.ubicacion}');
    print('Tipo de lugar: ${_formData.tipoLugar}');
    print('Estado de las carreteras: ${_formData.estadoCarreteras}');
    print('Servicios básicos: ${_formData.serviciosBasicos}');
  }
}
