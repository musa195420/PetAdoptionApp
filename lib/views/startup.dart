import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/blinking_dots.dart';
import '../viewModel/startup_viewmodel.dart';

class Startup extends StatelessWidget {
  Startup({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    StartupViewModel viewModel = context.watch<StartupViewModel>();

    return StatefulWrapper(
      onInit: () {
       viewModel.doStartupLogic(context);
      },
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/bg.png'))),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(child: Image.asset("assets/images/startup.png")),
              Positioned(
                top: 0,
                
  child: SizedBox(
    width: 400,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'We are setting things up\nPlease Wait!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(255, 146, 61, 5),
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
       const BlinkingDotsLoader(),
      ],
    ),
  ),
),

           
            ],
          ),
        ),
      ),
    );
  }
}


