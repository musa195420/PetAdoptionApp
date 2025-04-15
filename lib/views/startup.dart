import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../viewModel/authentication_view_model.dart';

class Startup extends StatelessWidget {
  Startup({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>(); 

  @override
  Widget build(BuildContext context) {
     AuthenticationViewModel viewModel = context.watch< AuthenticationViewModel>();
      onInit: () {
     
      };
    return Scaffold( key: scaffoldKey,
       backgroundColor: Colors.white,
       body: Container(
         decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/bg.png'))),
         padding: const EdgeInsets.all(20.0),
         child:  Column(
           children: [
             Expanded(child: SizedBox()),
             Align(alignment: Alignment.center, child: SizedBox( width: 400, child: Text('Not Supported on This Device!'))),
             CustomButton(text:"Login",onTap:(){
               viewModel.Login("ahmed@gmail.com", "Connect@360");
             }),
             Expanded(child: SizedBox()),
           ],
         ),
       ),
     );
  }
}