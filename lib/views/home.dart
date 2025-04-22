import 'package:flutter/material.dart';
import 'package:petadoption/viewModel/home_view_model.dart';

import 'package:provider/provider.dart';

import '../custom_widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    HomeViewModel viewModel = context.watch<HomeViewModel>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/images/bg.png'))),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(),
            Align(
                alignment: Alignment.center,
                child: SizedBox(width: 400, child: Text('This Is Home Page'))),
            CustomButton(
              text: "Logout",
              onTap: () async {
                await viewModel.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
