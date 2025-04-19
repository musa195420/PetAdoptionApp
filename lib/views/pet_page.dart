import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/pet_view_model.dart';

import 'package:provider/provider.dart';

import '../custom_widgets/default_text_input.dart';
import '../helpers/constants.dart';

dynamic formKey = GlobalKey<FormState>();

class PetPage extends StatelessWidget {
  PetPage({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
   TextEditingController nameController = TextEditingController();
  TextEditingController animalTypeController = TextEditingController();
   TextEditingController breedController = TextEditingController();
   TextEditingController ageController = TextEditingController();
   TextEditingController genderController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    
    PetViewModel viewModel = context.watch<PetViewModel>();
     animalTypeController = TextEditingController(text: viewModel.selectedAnimalTypeName);
  breedController = TextEditingController(text: viewModel.selectedBreedName);
   genderController = TextEditingController(text: viewModel.gender);
    return StatefulWrapper(
      onDispose: (){
nameController.dispose();
animalTypeController.dispose();
breedController.dispose();
ageController.dispose();
genderController.dispose();
descriptionController.dispose();
      },
      onInit: (){

      },
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
            // Login form content with SafeArea
          SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            // Character image at top, overlapping the container
            
      
            // Padding to make space for the image
            Padding(
              padding: const EdgeInsets.only(top: 75), // Adjust to control overlap
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 247, 240),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(
                  children: [
                    _buildAddPetForm(viewModel),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: (){
                         if (formKey.currentState!.validate()) {
            viewModel.addPet(nameController.text,int.parse(ageController.text),descriptionController.text);
          }
                      },
                      child: _buildAddPetButton(viewModel)),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(child: _buildCharacterImage(viewModel)),
            ),
          ],
        ),
      ),
        ),
      )
      
          ],
        ),
      ),
    );
  }
Widget _buildCharacterImage(PetViewModel viewModel) {
  return Column(
    spacing: 5,
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        decoration: BoxDecoration(
          color:  Colors.white,
          border: Border.all(
            color:Color.fromARGB(255, 255, 247, 240),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: viewModel.path != null
            ? ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(viewModel.path!),
          height: 130,
          width: 130,
          fit: BoxFit.cover,
        ),
      )
            : Image.asset(
                'assets/images/profile.png',
                height: 120,
                fit: BoxFit.contain,
              ),
      ),
  
  
       Row(
     mainAxisAlignment :   MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Container(
            decoration: BoxDecoration(
              color:viewModel.path != null ?Colors.brown: Colors.deepOrange,
              borderRadius: BorderRadius.circular(30),
             
            ),
            padding: EdgeInsets.fromLTRB(5,0, 5, 0),
             child: GestureDetector(
                onTap: () async {
                   await viewModel.savePetImagePath();
                 },
               child: Text(
                 viewModel.path != null ? "Change Image" : "Add Image",
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 14,
                   fontWeight: FontWeight.w600,
                 ),
               ),
             ),
           ),
                  
 if( viewModel.path != null)
             GestureDetector(
                onTap: ()  {
    viewModel.removeImage();
   //viewModel.logout();
    
    },
              child: Icon(Icons.delete,color: Colors.deepOrange,))
         ],
       ),
    ],
  );
}

  Widget _buildAddPetForm(PetViewModel viewModel) {

    return Form(
      key: formKey,
      child: Column(
        spacing: 5,
        children: [
         SizedBox(height: 15,),
          DefaultTextInput(
            controller: nameController,
            hintText: "Name",
          
            icon: Icons.pets,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Animal Name Please';
              }
              return null;
            },
          ),
         Row(
  children: [
    Expanded(
      child: DefaultTextInput(
        onTap: () async {
          viewModel.getAnimalType();
        },
        readOnly: true,
        controller: animalTypeController,
        hintText: "Animal Type",
        icon: Icons.animation,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter Your Animal Type Please';
          }
          return null;
        },
      ),
    ),
    const SizedBox(width: 5),
    GestureDetector(
      onTap: () async{
        viewModel.addanimalType();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
      ),
    ),
  ],
),


 Row(
  children: [
    Expanded(
      child: DefaultTextInput(
        onTap: () async {
        viewModel.getAnimalBreed();
        },
        readOnly: true,
        controller: breedController,
        hintText: "Breed Type",
        icon: Icons.type_specimen,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter Animal Breed Please';
          }
          return null;
        },
      ),
    ),
    const SizedBox(width: 5),
    GestureDetector(
      onTap: () async{
       viewModel.addanimalBreed();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
      ),
    ),
  ],
),
          
          DefaultTextInput(
            controller: ageController,
            keyboardType: TextInputType.number,
            hintText: "AGE",
            icon: Icons.height,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Animals Age Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: genderController,
            hintText: "Gender",
            readOnly: true,
            icon: Icons.g_mobiledata,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Animals Gender Please';
              }
              return null;
            },
            onTap: (){
              viewModel.getGender();
            },
          ),

            DefaultTextInput(
            controller: descriptionController,
            hintText: "Description",
            icon: Icons.description,
           
          ),
        ],
      ),
    );
  }

  Widget _buildAddPetButton(PetViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: Text(
        "Add pet",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
