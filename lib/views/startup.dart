import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/home_view_model.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/custom_button.dart';
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
              Expanded(child: SizedBox()),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 400,
                      child: Text('Not Supported on This Device!'))),
              Expanded(
                  child: CustomButton(
                      text: "Logout",
                      onTap: () {
                        viewModel.logout();
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
