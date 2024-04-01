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

class FormularioInformacion extends StatefulWidget {
  @override
  _FormularioInformacionState createState() => _FormularioInformacionState();
}

class _FormularioInformacionState extends State<FormularioInformacion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _ubicacionController = TextEditingController();
  TextEditingController _tipoLugarController = TextEditingController();
  TextEditingController _estadoCarreterasController = TextEditingController();
  TextEditingController _serviciosBasicosController = TextEditingController();
  TextEditingController _estadoEdificacionesController = TextEditingController();
  TextEditingController _calidadAguaController = TextEditingController();
  TextEditingController _fuentesAguaController = TextEditingController();
  TextEditingController _problemasAguaController = TextEditingController();
  TextEditingController _tipoSuministroAguaController = TextEditingController();
  TextEditingController _estadoTratamientoAguaController = TextEditingController();
  TextEditingController _cortesAguaController = TextEditingController();
  TextEditingController _tipoAlcantarilladoController = TextEditingController();
  TextEditingController _estadoTratamientoAlcantarilladoController = TextEditingController();
  TextEditingController _problemasEspecificosController = TextEditingController();
  TextEditingController _comentariosAdicionalesController = TextEditingController();

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
            if (_currentStep < 7) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              //_submitForm();
            }
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
                  controller: _ubicacionController,
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
                ),
                TextFormField(
                  controller: _tipoLugarController,
                  decoration: InputDecoration(labelText: 'Tipo de lugar'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Por favor ingresa el tipo de lugar';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          Step(
            title: Text('Infraestructura'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  controller: _estadoCarreterasController,
                  decoration: InputDecoration(
                      labelText: 'Estado de las carreteras o calles de acceso'),
                ),
                TextFormField(
                  controller: _serviciosBasicosController,
                  decoration: InputDecoration(
                      labelText: 'Disponibilidad de servicios básicos'),
                ),
                TextFormField(
                  controller: _estadoEdificacionesController,
                  decoration: InputDecoration(
                      labelText: 'Estado de edificaciones cercanas'),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Agua'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  controller: _calidadAguaController,
                  decoration: InputDecoration(labelText: 'Calidad del agua'),
                ),
                TextFormField(
                  controller: _fuentesAguaController,
                  decoration: InputDecoration(
                      labelText: 'Fuentes de agua cercanas'),
                ),
                TextFormField(
                  controller: _problemasAguaController,
                  decoration: InputDecoration(
                      labelText: 'Problemas específicos relacionados con el agua'),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Sistemas de Agua'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  controller: _tipoSuministroAguaController,
                  decoration: InputDecoration(
                      labelText: 'Tipo de suministro de agua'),
                ),
                TextFormField(
                  controller: _estadoTratamientoAguaController,
                  decoration: InputDecoration(
                      labelText: 'Estado de las instalaciones de tratamiento de agua'),
                ),
                TextFormField(
                  controller: _cortesAguaController,
                  decoration: InputDecoration(
                      labelText: 'Frecuencia y duración de cortes de agua'),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Infraestructura de alcantarillado'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  controller: _tipoAlcantarilladoController,
                  decoration: InputDecoration(
                      labelText: 'Tipo de sistema de alcantarillado'),
                ),
                TextFormField(
                  controller: _estadoTratamientoAlcantarilladoController,
                  decoration: InputDecoration(
                      labelText: 'Estado de las instalaciones de tratamiento de aguas residuales'),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Problemas específicos'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  controller: _problemasEspecificosController,
                  decoration: InputDecoration(
                      labelText: 'Descripción detallada de cualquier problema específico'),
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
                  controller: _comentariosAdicionalesController,
                  decoration: InputDecoration(
                      labelText: 'Comentarios adicionales'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
