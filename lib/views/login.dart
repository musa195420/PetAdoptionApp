import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../viewModel/authentication_view_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>(); 

  @override
  Widget build(BuildContext context) {
    
       
    return Scaffold( key: scaffoldKey,
       backgroundColor: Colors.white,
       body: Container(
         decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/bg.png'))),
         padding: const EdgeInsets.all(20.0),
         child: const Column(
           children: [
             Expanded(child: SizedBox()),
             Align(alignment: Alignment.center, child: SizedBox( width: 400, child: Text('Not Supported on This Device!'))),
             Expanded(child: SizedBox()),
           ],
         ),
       ),
     );
  }
}