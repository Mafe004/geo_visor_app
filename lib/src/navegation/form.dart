import 'package:flutter/material.dart';


class FormExampleApp extends StatelessWidget {
  const FormExampleApp({super.key});

  @override
  State<FormExampleApp> createState() => _FormExampleApp();
}

class _FormExampleApp extends State<FormExmapleApp>{
  int currentStep =0;
  bool get isFirstStep => currentStep ==0;
  bool get isLastStep => currentStep ==steps()-length -1;

  final Ubicacion = TextEditingController();
  final Tipo_Lugar = TextEditingController();
  final name = TextEditingController();
  final name = TextEditingController();

  bool isComplete = false;

  @override
  widget build(BuildContext context) => Scaffold(
         appBar: Appbar(title: const Text('Flutter Stepper widget')),
         body: isComplete
         ? buildSuccessPage()
         : Stepper (
           type: stepperType.horizontal
         steps: steps(),
         currentStep: currentStep,
         onStepContinue: () {
           if (islastStep){
             setState(() => isComplete = true);
           }else {
             setState(() => currentStep +=1);
           }
         },
         onStepCancel:
             isFirstStep ? null : () => setState(()=> currentStep -= 1 )
         onStepTapped: step => setState(()=> currentStep =step),
         controlsBuilder:(context, details) => Padding(
           padding: const EdgeInsert.only(top: 32),
           child: row (
             children:[
               Expanded(
                 child: ElevatedButton(
                   onPressed: details.onStepContinue,
                   child: Text isLastStep ? 'Confirm' :'Next'),
                 ),//ElevatedButton
               ), // Expanded
               if (!isFirstStep)...[
               const SizedBox(width: 16),
               Expanded(
                 child: ElevatedButton(
                   onPressed: isFirstStep ? null : details.onSteCancel,
                   child: const Text ('Back'),
                 ),//ElevatedButton
               ),// Expanded
             ],
           ),// Row
         ),//Padding
        ), //Stepper
       );//Scaffold

  List<Step> steps() =>[
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
              ), // TextFormField
            ],
          ),//column
         ), // step
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
             ), // TextFormField
           ],
         ),//column
         ), // step

         'your details have been confirmed successfully',
         textAling: TextAling.center,
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
                 company.clar();
                 role.cler();
  });
 },
  child: const Text('RESET'),
  ),// ElevatedButton
  ),//Align
],
  ), //Column
  ),//Padding
  );//Center
}













           isActive: currentStep >=1,
          title: const Text('Ubicación'),
          Content: const Column(),
        ), // Step
         Step(
           isActive: currentStep >=2,
          title: const Text('Ubicación'),
          Content: const Column(),
        ), // Step
         Step(
           isActive: currentStep >=3,
          title: const Text('Ubicación'),
          Content: const Column(),
        ), // Step
         Step(
           isActive: currentStep >=4,
          title: const Text('Ubicación'),
          Content: const Column(),
        ), // Step
         Step(
           isActive: currentStep >=5,
          title: const Text('Ubicación'),
          Content: const Column(),
        ), // Step
         Step(
           isActive: currentStep >=6,
          title: const Text('Ubicación'),
          Content: const Column(),
        ), // Step
         Step(
           isActive: currentStep >=7,
          title: const Text('Ubicación'),
          Content: const Column(),
        ), // Step
      ];
     ),// Column
   ),//Step
   Step(
       state
       )
}
}