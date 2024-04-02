

import 'package:flutter/material.dart';
class FormExampleApp extends StatefulWidget {
  const FormExampleApp({super.key});

  @override
    State<FormExampleApp> createState() => _FormExampleAppState();
  }

class _FormExampleAppState extends State<FormExampleApp>{
  int currentStep =0;
  bool get isFirstStep => currentStep ==0;
  bool get isLastStep => currentStep == steps().length -1;

  final Ubicacion = TextEditingController();
  final Tipo_Lugar = TextEditingController();
  final name = TextEditingController();

  bool isComplete = false;

  @override
  Widget build(BuildContext context) => Scaffold(
         appBar: AppBar(title: const Text('Flutter Stepper widget')),
         body: isComplete
              ?buildSuccessPage()
          :Stepper (
           type: StepperType.horizontal,
         steps: steps(),
         currentStep: currentStep,
         onStepContinue: () {
           if (isLastStep){
             setState(() => isComplete = true);
           }else {
             setState(() => currentStep +=1);
           }
         },
         onStepCancel:
             isFirstStep ? null : () => setState(()=> currentStep -= 1 ),
         onStepTapped: (step) => setState(()=> currentStep =step),
         controlsBuilder:(context, details) => Padding(
           padding: const EdgeInsets.only(top: 32),
           child: Row (
             children:[
               Expanded(
                 child: ElevatedButton(
                   onPressed: details.onStepContinue,
                   child: Text (isLastStep ? 'Confirm' :'Next'),
                 ),
               ),
               if (!isFirstStep)...[
               const SizedBox(width: 16),
               Expanded(
                 child: ElevatedButton(
                   onPressed: isFirstStep ? null : details.onStepCancel,
                   child: const Text ('Back'),
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
           isActive: currentStep >=0,
           title: const Text('Información General del lugar'),
           Content: Column(
            children:[
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Ubicación'),
              ),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Tipo de lugar'),
              ),
            ],
          ),
         ),
         Step(
           state: currentStep > 1 ? StepState.complete : StepState.indexed,
           isActive: currentStep >=1,
           title: const Text('Infraestructura'),
           Content: Column(
           children:[
             TextFormField(
               controller: name,
               decoration: const InputDecoration(labelText: 'Dirección'),
             ),
             TextFormField(
               controller: name,
               decoration: const InputDecoration(labelText: 'Dirección'),
             ),
           ],
         ),
         ),

         //       'your details have been confirmed successfully',
                textAlign: TextAling.center,
                style: TextStyle(fontSize: 18),
                ),// text
                const SizedBox(height: 20),
                const Spacer(),
                Align(
                 alignment:  Aliment.centerRight,
                 child: ElevatedButton(
                   onPressed:(){
                    setState((){
                      isComplete = false;
                      currentStop =0;
                      name.clear();
                      age.clear();
                      company.clear();
                      role.cler();
                    });
                   },
                   child: const Text('RESET'),
                 ),// ElevatedButton
                ),//Align
              ];
}