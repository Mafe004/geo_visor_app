import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';


class FormExampleApp extends StatefulWidget {
  const FormExampleApp({Key? key}) : super(key: key);

  @override
  State<FormExampleApp> createState() => _FormExampleAppState();
}

class _FormExampleAppState extends State<FormExampleApp> {
  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  final ubicacion = TextEditingController();
  final tipoLugar = TextEditingController();
  final estadoCarretera = TextEditingController();
  final serviciosBasicos = TextEditingController();
  final estadoEdificaciones = TextEditingController();
  final calidadAgua = TextEditingController();
  final fuentesAgua = TextEditingController();
  final problemasAgua = TextEditingController();
  final tipoSuministros = TextEditingController();
  final estadoInstalaciones = TextEditingController();
  final cortesAgua = TextEditingController();
  final tipoAlcantarillado = TextEditingController();
  final estadoAlcantarillado = TextEditingController();
  final problemasEspecificos = TextEditingController();
  final comentarios = TextEditingController();

  List<File> selectedImages = [];

  bool isComplete = false;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    Firebase.initializeApp().then((value) {
      // Firebase is initialized
    });
    // Obtain current location
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Flutter Stepper widget')),
    body: isComplete
        ? buildSuccessPage()
        : Stepper(
      type: StepperType.horizontal,
      steps: steps(),
      currentStep: currentStep,
      onStepContinue: () {
        if (isLastStep) {
          saveDataToFirestore();
          setState(() => isComplete = true);
        } else {
          setState(() => currentStep += 1);
        }
      },
      onStepCancel: isFirstStep ? null : () => setState(() => currentStep -= 1),
      onStepTapped: (step) => setState(() => currentStep = step),
      controlsBuilder: (context, details) => Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(isLastStep ? 'Confirm' : 'Next'),
              ),
            ),
            if (!isFirstStep) ...[
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: isFirstStep ? null : details.onStepCancel,
                  child: const Text('Back'),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );

  void saveDataToFirestore() {
    FirebaseFirestore.instance.collection('Reportes').add({
      'ubicacion': ubicacion.text,
      'tipoLugar': tipoLugar.text,
      'estadoCarretera': estadoCarretera.text,
      'serviciosBasicos': serviciosBasicos.text,
      'estadoEdificaciones': estadoEdificaciones.text,
      'calidadAgua': calidadAgua.text,
      'fuentesAgua': fuentesAgua.text,
      'problemasAgua': problemasAgua.text,
      'tipoSuministros': tipoSuministros.text,
      'estadoInstalaciones': estadoInstalaciones.text,
      'cortesAgua': cortesAgua.text,
      'tipoAlcantarillado': tipoAlcantarillado.text,
      'estadoAlcantarillado': estadoAlcantarillado.text,
      'problemasEspecificos': problemasEspecificos.text,
      'comentarios': comentarios.text,
      'timestamp': FieldValue.serverTimestamp(), // Add this line to save the timestamp
      'images': selectedImages.map((image) => image.path).toList(), // Add this line to save image paths
      'latitude': currentPosition?.latitude,
      'longitude': currentPosition?.longitude,
    }).then((value) {
      print('Data added successfully!');
    }).catchError((error) {
      print('Failed to add data: $error');
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  List<Step> steps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text('Información General del lugar'),
      content: Column(
        children: [
          TextFormField(
            controller: ubicacion,
            decoration: const InputDecoration(labelText: 'Dirección'),
          ),
          TextFormField(
            controller: tipoLugar,
            decoration: const InputDecoration(labelText: 'Tipo de lugar'),
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text('Infraestructura'),
      content: Column(
        children: [
          TextFormField(
            controller: estadoCarretera,
            decoration: const InputDecoration(labelText: 'Estado de las carreteras o calles de acceso'),
          ),
          TextFormField(
            controller: serviciosBasicos,
            decoration: const InputDecoration(labelText: 'Disponibilidad de servicios básicos'),
          ),
          TextFormField(
            controller: estadoEdificaciones,
            decoration: const InputDecoration(labelText: 'Estado de edificaciones cercanas'),
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: const Text('Agua'),
      content: Column(
        children: [
          TextFormField(
            controller: calidadAgua,
            decoration: const InputDecoration(labelText: 'Calidad del agua'),
          ),
          TextFormField(
            controller: fuentesAgua,
            decoration: const InputDecoration(labelText: 'Fuentes de agua cercanas'),
          ),
          TextFormField(
            controller: problemasAgua,
            decoration: const InputDecoration(labelText: 'Problemas específicos relacionados con el agua'),
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 3,
      title: const Text('Sistemas de Agua'),
      content: Column(
        children: [
          TextFormField(
            controller: tipoSuministros,
            decoration: const InputDecoration(labelText: 'Tipo de suministro de agua'),
          ),
          TextFormField(
            controller: estadoInstalaciones,
            decoration: const InputDecoration(labelText: 'Estado de las instalaciones de tratamiento de agua'),
          ),
          TextFormField(
            controller: cortesAgua,
            decoration: const InputDecoration(labelText: 'Frecuencia y duración de cortes de agua'),
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 4 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 4,
      title: const Text('Infraestructura de alcantarillado'),
      content: Column(
        children: [
          TextFormField(
            controller: tipoAlcantarillado,
            decoration: const InputDecoration(labelText: 'Tipo de sistema de alcantarillado'),
          ),
          TextFormField(
            controller: estadoAlcantarillado,
            decoration: const InputDecoration(labelText: 'Estado de las instalaciones de tratamiento de aguas residuales'),
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 5 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 5,
      title: const Text('Problemas específicos'),
      content: Column(
        children: [
          TextFormField(
            controller: problemasEspecificos,
            decoration: const InputDecoration(labelText: 'Descripción detallada de cualquier problema específico relacionado con la infraestructura o el agua'),
          ),
          ElevatedButton(
            onPressed: () => _showImageOptions(),
            child: Text('Adjuntar Fotos (${selectedImages.length}/5)'),
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 6 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 6,
      title: const Text('Comentarios adicionales'),
      content: Column(
        children: [
          TextFormField(
            controller: comentarios,
            decoration: const InputDecoration(labelText: 'Comentarios adicionales'),
          ),
          const Text(
            'Your details have been confirmed successfully',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isComplete = false;
                  currentStep = 0;
                  selectedImages.clear();
                  ubicacion.clear();
                  tipoLugar.clear();
                  estadoCarretera.clear();
                  serviciosBasicos.clear();
                  estadoEdificaciones.clear();
                  calidadAgua.clear();
                  fuentesAgua.clear();
                  problemasAgua.clear();
                  tipoSuministros.clear();
                  estadoInstalaciones.clear();
                  cortesAgua.clear();
                  tipoAlcantarillado.clear();
                  estadoAlcantarillado.clear();
                  problemasEspecificos.clear();
                  comentarios.clear();
                });
              },
              child: const Text('RESET'),
            ),
          ),
        ],
      ),
    ),
  ];

  Widget buildSuccessPage() => const Center(
    child: Text(
      '¡Éxito!',
      style: TextStyle(fontSize: 24),
    ),
  );

  Future<void> _showImageOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Seleccionar de la galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImages();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Tomar una foto'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage(
      maxHeight: 1024,
      maxWidth: 1024,
      imageQuality: 75,
    );

    if (pickedImages != null) {
      setState(() {
        selectedImages.addAll(pickedImages.map((image) => File(image.path)));
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1024,
      maxWidth: 1024,
      imageQuality: 75,
    );

    if (pickedImage != null) {
      setState(() {
        selectedImages.add(File(pickedImage.path));
      });
    }
  }
}
