import 'package:flutter/material.dart';

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




  bool isComplete = false;

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

  List<Step> steps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text('Información General del lugar'),
      content: Column(
        children: [
          TextFormField(
            controller: ubicacion,
            decoration: const InputDecoration(labelText: 'Ubicación'),
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
            decoration: const InputDecoration(labelText: 'Estado de las carreteras o cales de acceso'),
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
      title: const Text('Infraestructura de aantarillado'),
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
      title: const Text('Problemas especificos'),
      content: Column(
        children: [
          TextFormField(
            controller: problemasEspecificos,
            decoration: const InputDecoration(labelText: 'Descripción detallada de cualquier problema específico relacionado con la infraestructura o el agua'),
          ),
          //incluis elementos para subir archivos adjuntos o fotos
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
}