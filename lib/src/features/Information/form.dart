import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import '../services/image_helper.dart';
import '../services/location_service.dart';
import '../services/image_service.dart';
import '../services/firestore_service.dart';


class FormExampleApp extends StatefulWidget {
  final String? initialAddress;
  const FormExampleApp({Key? key, this.initialAddress}) : super(key: key);

  @override
  State<FormExampleApp> createState() => _FormExampleAppState();
}

class _FormExampleAppState extends State<FormExampleApp> {
  final LocationService _locationService = LocationService();
  final ImageService _imageService = ImageService();
  final FirestoreService _firestoreService = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int currentStep = 0;

  bool get isFirstStep => currentStep == 0;

  bool get isLastStep => currentStep == steps().length - 1;

  late TextEditingController ubicacion;
  final tipoLugar = TextEditingController();
  final Descripcion = TextEditingController();
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
  String? currentAddress;

  @override
  void initState() {
    super.initState();
    ubicacion = TextEditingController();
    _initializeLocation();
  }

  void _initializeLocation() async {
    try {
      currentPosition = await _locationService.getCurrentPosition();
      currentAddress = await _locationService.getAddressFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude);
      setState(() {
        ubicacion.text = currentAddress ?? '';
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void saveDataToFirestore() async {
    if (currentPosition != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final userSnapshot = await FirebaseFirestore.instance.collection(
              'Usuarios').doc(user.uid).get();
          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>;
            final userName = userData['name'] ??
                'Usuario Desconocido'; // Obtener el nombre de usuario o establecer uno predeterminado
            final reportData = {
              'userId': user.uid,
              'userName': userName,
              // Guardar el nombre del usuario en el informe
              'ubicacion': currentAddress ?? '',
              'Descripcion': Descripcion.text,
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
              'timestamp': FieldValue.serverTimestamp(),
              'images': selectedImages.map((image) => image.path).toList(),
              'coordenadas': GeoPoint(
                  currentPosition!.latitude, currentPosition!.longitude),
            };
            await _firestoreService.saveReport(reportData);
            print('Data added successfully!');
          } else {
            print('User data not found in Firestore.');
          }
        } catch (error) {
          print('Failed to fetch user data: $error');
        }
      } else {
        print('No user currently signed in.');
      }
    } else {
      print('Current position is null. Cannot save data.');
    }
  }

  Future<void> _showImageOptions() async {
    final remainingImages = 5 - selectedImages.length;

    if (remainingImages <= 0) {
      // Si ya se han seleccionado 5 imágenes, mostrar un mensaje de error y no permitir agregar más.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No puedes subir más de 5 imágenes.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Mostrar opciones para seleccionar imágenes.
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Seleccionar de la galería'),
              onTap: () async {
                Navigator.pop(context);
                final newImages = await _imageService.pickImages(maxImages: remainingImages);
                _addImages(newImages);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Tomar una foto'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _imageService.takePhoto();
                if (image != null) {
                  _addImages([image]);
                }
              },
            ),
          ],
        );
      },
    );
  }


  void _addImages(List<File> newImages) {
    final totalImages = selectedImages.length + newImages.length;

    if (totalImages > 5) {
      // Si el número total de imágenes excede 5, mostrar un mensaje de error.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No puedes subir más de 5 imágenes.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Lista para almacenar imágenes válidas (resolución <= 1024x1024)
    List<File> validImages = [];

    // Verificar el tamaño y la resolución de cada imagen antes de agregarla a la lista de imágenes seleccionadas.
    for (final image in newImages) {
      final resolution = ImageHelper.getImageResolution(image);
      final width = int.parse(resolution.split('x')[0]);
      final height = int.parse(resolution.split('x')[1]);

      if (width > 800 || height > 800) {
        // Si la resolución de la imagen es mayor que 1024x1024, mostrar un mensaje de error.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'La imagen seleccionada tiene una resolución mayor que 1024x1024 y no puede ser agregada.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Si la imagen es válida (resolución <= 1024x1024), agregarla a la lista de imágenes válidas.
        validImages.add(image);
      }
    }

    // Si las imágenes cumplen con los requisitos, agregarlas a la lista de imágenes seleccionadas.
    selectedImages.addAll(validImages);

    // Mostrar el tamaño y la resolución de las imágenes


    setState(() {});
  }




  List<Step> steps() =>
      [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('Información General del lugar'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  enabled: false,
                  // Deshabilitar el campo
                  controller: ubicacion,
                  // Usar el controlador para la dirección
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La dirección es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: tipoLugar,
                  decoration: const InputDecoration(labelText: 'Tipo de lugar'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El tipo de lugar es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: Descripcion,
                  decoration: const InputDecoration(labelText: 'Descripcion general'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Descripcion de lugar es obligatorio';
                    }
                    return null;
                  },
                ),
              ],
            ),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El estado de las carreteras es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: serviciosBasicos,
                decoration: const InputDecoration(labelText: 'Disponibilidad de servicios básicos'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La disponibilidad de servicios básicos es obligatoria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: estadoEdificaciones,
                decoration: const InputDecoration(
                    labelText: 'Estado de edificaciones cercanas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El estado de las edificaciones es obligatorio';
                  }
                  return null;
                },
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
                decoration: const InputDecoration(
                    labelText: 'Calidad del agua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La calidad del agua es obligatoria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: fuentesAgua,
                decoration: const InputDecoration(
                    labelText: 'Fuentes de agua cercanas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Las fuentes de agua cercanas son obligatorias';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: problemasAgua,
                decoration: const InputDecoration(
                    labelText: 'Problemas específicos relacionados con el agua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Los problemas específicos relacionados con el agua son obligatorios';
                  }
                  return null;
                },
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
                decoration: const InputDecoration(
                    labelText: 'Tipo de suministro de agua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El tipo de suministro de agua es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: estadoInstalaciones,
                decoration: const InputDecoration(
                    labelText: 'Estado de las instalaciones de tratamiento de agua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El estado de las instalaciones de tratamiento de agua es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cortesAgua,
                decoration: const InputDecoration(
                    labelText: 'Frecuencia y duración de cortes de agua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La frecuencia y duración de cortes de agua son obligatorias';
                  }
                  return null;
                },
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
                decoration: const InputDecoration(
                    labelText: 'Tipo de sistema de alcantarillado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El tipo de sistema de alcantarillado es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: estadoAlcantarillado,
                decoration: const InputDecoration(
                    labelText: 'Estado de las instalaciones de tratamiento de aguas residuales'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El estado de las instalaciones de tratamiento de aguas residuales es obligatorio';
                  }
                  return null;
                },
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
                decoration: const InputDecoration(
                    labelText: 'Descripción detallada de cualquier problema específico relacionado con la infraestructura o el agua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción de los problemas específicos es obligatoria';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () => _showImageOptions(),
                child: Text('Adjuntar Fotos (${selectedImages.length}/5)'),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: selectedImages.map((image) {
                  return Stack(
                    children: [
                      Image.file(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImages.remove(image);
                            });
                          },
                          child: Container(
                            color: Colors.black54,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
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
                decoration: const InputDecoration(
                    labelText: 'Comentarios adicionales'),
              ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de reporte'),
      ),
      body: isComplete
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Éxito!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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
              child: const Text('Nuevo Reporte'),
            ),
          ],
        ),
      )
          : Stepper(
        type: StepperType.vertical,
        steps: steps(),
        currentStep: currentStep,
        onStepContinue: () {
          if (_formKey.currentState!.validate()) {
            if (isLastStep) {
              saveDataToFirestore();
              setState(() => isComplete = true);
            } else {
              setState(() => currentStep += 1);
            }
          }
        },
        onStepCancel: isFirstStep
            ? null
            : () => setState(() => currentStep -= 1),
        onStepTapped: (step) => setState(() => currentStep = step),
        controlsBuilder: (context, details) =>
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(isLastStep ? 'Confirmar' : 'Siguiente'),
                    ),
                  ),
                  if (!isFirstStep)
                    const SizedBox(width: 12),
                  if (!isFirstStep)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Atrás'),
                      ),
                    ),
                ],
              ),
            ),
      ),
    );
  }
}

