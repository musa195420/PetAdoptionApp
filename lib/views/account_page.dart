import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/label_value_row.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();
TextEditingController logout = TextEditingController(text: "logout");
  @override
  Widget build(BuildContext context) {
    HomeViewModel viewModel = context.watch<HomeViewModel>();
    

    return StatefulWrapper(
      onInit: (){
      },
      onDispose: (){},
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           Container(
            margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey.shade100, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
              child: LabelValueRow(
                label: "Logout",
                value:  "Logout",
                showArrow: true,
                onTap: ()async {
                 viewModel.logout();
                } ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
