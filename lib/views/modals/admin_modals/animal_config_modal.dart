import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/admin_view_models/general_config_view_model.dart';
import '../../../../custom_widgets/default_text_input.dart';
import '../../../../helpers/locator.dart';
import '../../../../models/response_models/animal_Type.dart';
import '../../../../services/api_service.dart';

import 'package:provider/provider.dart';
dynamic formKey = GlobalKey<FormState>();

class AnimalConfigModal extends StatelessWidget {
  AnimalConfigModal({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();
   TextEditingController nameController = TextEditingController();
    TextEditingController idController = TextEditingController();
      final   TextEditingController searchController =TextEditingController();
  @override
  Widget build(BuildContext context) {
       
    final viewModel = context.watch<GeneralConfigViewModel>();
    return StatefulWrapper(
      onInit: () {
        viewModel.getPets();
      },
      onDispose: () {
        nameController.dispose();
      },
      child:Scaffold(
         floatingActionButton: viewModel.showAnimals == true
    ? FloatingActionButton(
        onPressed: () {
          // Your action here
        },
        backgroundColor: const Color.fromARGB(255, 146, 61, 5),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      )
    : null,
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
        child: viewModel.showAnimals?_buildSearchBox(viewModel):_buildEditAnimal(viewModel),
        ),
      )
    );
  }

Widget _buildEditAnimal(GeneralConfigViewModel viewModel)
{
  nameController = TextEditingController(text: viewModel.animalName);
    idController = TextEditingController(text: viewModel.animalId);
  return    Form(
    key: formKey,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 10,
                children: [
    
                  Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     GestureDetector(
                       onTap: () {
                         viewModel.gotoPrevious();
                       },
                       child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color:  const Color.fromARGB(255, 146, 61, 5),
                        )
                        ,
                         padding: const EdgeInsets.all(3),
                         child: Icon(
                           Icons.arrow_back,
                           size: 30,
                           color:Colors.white,
                         ),
                       ),
                     ),
                     SizedBox(width: 80,),
                  Text(
                    
              "Animal Edit",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: const Color.fromARGB(255, 146, 61, 5),
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
            ),
                   ],
                 ),
                 Divider(thickness: 2,color: const Color.fromARGB(255, 146, 61, 5),),
                 SizedBox(height: 10,),
                 DefaultTextInput(
              controller: idController,
              labelText: "id",
              hintText: "id",
              readOnly: true,
              enabled: false,
              icon: Icons.unarchive,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Your Name Please';
                }
                return null;
              },
            ),
    
            DefaultTextInput(
              controller: nameController,
              labelText: "Name",
              hintText: "Name",
              
              icon: Icons.pets_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Your Name Please';
                }
                return null;
              },
            ),

             _buildUpdateButton(viewModel)
                ],
              ),
    ),
  );
}



  Widget _buildUpdateButton(GeneralConfigViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: GestureDetector(
        child: Text(
          "Update Animal",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onTap: () {
          if (formKey.currentState!.validate()) {
            viewModel.animalName=nameController.text;
            viewModel.updateAnimal(idController.text,nameController.text);
          }
        },
      ),
    );
  }

Widget _buildSearchBox(GeneralConfigViewModel viewModel)
{
  return    Column(
            children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   GestureDetector(
                     onTap: () {
                       viewModel.gotoPrevious();
                     },
                     child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color:  const Color.fromARGB(255, 146, 61, 5),
                      )
                      ,
                       padding: const EdgeInsets.all(3),
                       child: Icon(
                         Icons.arrow_back,
                         size: 30,
                         color:Colors.white,
                       ),
                     ),
                   ),
                   Expanded( // <-- Fix: this makes TextField take the remaining space
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
                       child: TextField(
                        style: TextStyle(color: Colors.black),
                         controller: searchController,
                         onChanged: viewModel.filteredAnimal,
                         decoration: InputDecoration(
                           hintText: "Search by Owner Email",
                           prefixIcon: const Icon(Icons.search),
                           suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        viewModel.resetFilter();
                      },
                    )
                  : null,
                           border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                           ),
                           filled: true,
                           
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
              const SizedBox(height: 16),
              
              const SizedBox(height: 12),
              Expanded(
                child: viewModel.filteredAnimals == null
                    ? const Center(child: Text("No Animals loaded."))
                    : ListView.builder(
                        padding: const EdgeInsets.all(2),
                        itemCount: viewModel.filteredAnimals!.length,
                        itemBuilder: (context, index) {
                          final animals = viewModel.filteredAnimals![index];
                          return _buildUserCard(context, animals, viewModel);
                        },
                      ),
              ),
            ],
          );
}

   Widget _buildUserCard(BuildContext context,AnimalType animals, GeneralConfigViewModel viewModel) {
      


    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 5,
              children: [
               
                Container(
                  
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(animals.name,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w400),))
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(animals.name, style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(width: 20,),
                      Flexible(child: 
                      Text(animals.animalId))
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                   
                    Flexible(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
        onPressed: () async{
      viewModel.gotoEditAnimal(animals);
        },
      ),
      IconButton(
        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
        onPressed: () {
        //  viewModel.deletePet(pets.petId);
        },
      ),
    
    ],
  ),
),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}
 
}
