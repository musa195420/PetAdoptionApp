// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/admin_view_models/general_config_view_model.dart';
import '../../../../custom_widgets/default_text_input.dart';
import '../../../../helpers/locator.dart';
import 'package:provider/provider.dart';

import '../../../models/response_models/get_vaccines.dart';
import '../../../services/navigation_service.dart';
  NavigationService get _navigationService => locator<NavigationService>();
dynamic formKey = GlobalKey<FormState>();
dynamic formKey2 = GlobalKey<FormState>();

class VaccinationConfig extends StatelessWidget {
  VaccinationConfig({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController animalController = TextEditingController();
  TextEditingController vaccineController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GeneralConfigViewModel>();
    return StatefulWrapper(
      onInit: () {
        viewModel.getVaccinations();
      },
      onDispose: () {
        animalController.dispose();
        vaccineController.dispose();
        descriptionController.dispose();
        searchController.dispose();
      },
      child: Scaffold(
        floatingActionButton: viewModel.showSearch == true
            ? FloatingActionButton(
                onPressed: () {
                  viewModel.setAddAnimal(true);
                },
                backgroundColor: const Color.fromARGB(255, 146, 61, 5),
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: viewModel.showSearch
              ? _buildSearchBox(viewModel)
              : viewModel.addInfo
                  ? _buildAddAnimal(viewModel)
                  : _buildEditAnimal(viewModel),
        ),
      ),
    );
  }

  Widget _buildAddAnimal(GeneralConfigViewModel viewModel) {
     animalController=TextEditingController(text: viewModel.animalName);
       vaccineController=TextEditingController(text: viewModel.vaccineName);
       descriptionController=TextEditingController(text:viewModel.description);
    return Form(
      key: formKey2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
           spacing: 10,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    viewModel.gotoPrevious();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(255, 146, 61, 5),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 60),
                Center(
                  child: Text(
                    
                              "Add Vaccine",
                              style: TextStyle(
                  color: const Color.fromARGB(255, 146, 61, 5),
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
                            ),
                ),
              ],
            ),

                Divider(thickness: 2,color: const Color.fromARGB(255, 146, 61, 5),),
             Expanded(
              flex: 1,
                  child: Column(
                    spacing: 10,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.black,  Color.fromARGB(255, 146, 61, 5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TabBar(
                          controller: TabController(initialIndex: viewModel.selectedIndex,length: 2, vsync: Navigator.of(_navigationService.navigatorKey.currentContext!)),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
                        
                          indicatorColor: Colors.white,
                          onTap: (index)
                          {
                           viewModel.setselectedIndex(index);

                          },
                          tabs: const [
                            Tab(text: "Add Single"),
                            Tab(text: "Add In Bulk"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          Expanded(
            flex: 5,
            child: Column(
              spacing: 10,
              children: [
              const SizedBox(height: 10),

              DefaultTextInput(
              controller: animalController,
              labelText: "Animal Name",
              hintText: "Animal Name",
              icon: Icons.pets_outlined,
              readOnly: true,
              onTap:(){viewModel.getAnimals();},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Animal  Name Please';
                }
                return null;
              },
            ),
          if(viewModel.selectedIndex==0)
            DefaultTextInput(
              controller: vaccineController,
              labelText: "Vaccine Name",
              hintText: "Vaccine Name",
              icon: Icons.pets_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Vaccine  Name Please';
                }
                return null;
              },
            ),
             if(viewModel.selectedIndex==1)
            DefaultTextInput(
              controller: vaccineController,
              labelText: "Add Vaccine  Names In Bulk",
              hintText: "Separate By Commas For Example Panandol,Rumadol",
              maxLines: 5,
              icon: Icons.pets_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Vaccine  animal names';
                }
                return null;
              },
            ),


             DefaultTextInput(
              controller: descriptionController,
              labelText: "Vaccine Description",
              hintText: "Add Vaccine Description",
              maxLines: 3,
              icon: Icons.description,
             
            ),
          ],)),
            _buildButton(viewModel, "Add Breeds", () {
              if (formKey2.currentState!.validate()) {
                viewModel.vaccineName = vaccineController.text;
                
                viewModel.description = descriptionController.text;
               viewModel.addVaccines(vaccineController.text,descriptionController.text);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEditAnimal(GeneralConfigViewModel viewModel) {
    vaccineController = TextEditingController(text: viewModel.vaccineName);
    animalController = TextEditingController(text: viewModel.animalName??"");
 descriptionController = TextEditingController(text: viewModel.description??"");

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    viewModel.gotoPrevious();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(255, 146, 61, 5),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 80),
                const Text(
                  "Vaccine Edit",
                  style: TextStyle(
                      color: Color.fromARGB(255, 146, 61, 5),
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Divider(thickness: 2, color: Color.fromARGB(255, 146, 61, 5)),
            const SizedBox(height: 10),
            DefaultTextInput(
              controller: animalController,
              labelText: "Animal",
              hintText: "Animal",
              readOnly: true,
              onTap: (){
                viewModel.getAnimals();
              },
              icon: Icons.unarchive,
              validator: (value) => value == null || value.isEmpty ? 'ID required' : null,
            ),
            DefaultTextInput(
              controller: vaccineController,
              labelText: "Vaccine Name",
              hintText: "Vaccine Name",
              icon: Icons.pets_outlined,
              validator: (value) => value == null || value.isEmpty ? 'Vaccine Name required' : null,
            ),

              DefaultTextInput(
              controller: descriptionController,
              labelText: "Vaccine Description Name",
              hintText: "Vaccine Description  Name",
              icon: Icons.pets_outlined,
              maxLines: 2,
             
            ),
            _buildButton(viewModel, "Update Vaccine", () {
              if (formKey.currentState!.validate()) {
                viewModel.vaccineName = vaccineController.text;
                viewModel.description = descriptionController.text;
                viewModel.updateVaccine(vaccineController.text,descriptionController.text);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(GeneralConfigViewModel viewModel, String text, Function() onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSearchBox(GeneralConfigViewModel viewModel) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                viewModel.gotoPrevious();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 146, 61, 5),
                ),
                padding: const EdgeInsets.all(3),
                child: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: searchController,
                  onChanged: viewModel.filtereVaccines,
                  decoration: InputDecoration(
                    hintText: "Search by Name",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              viewModel.resetFilterVaccines();
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
      const SizedBox(height: 12),

      // Only show the filter list if animalSelection is not empty
      if (viewModel.animalSelection.isNotEmpty)
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.animalSelection.length,
            itemBuilder: (context, index) {
              final animal = viewModel.animalSelection[index];
              final isSelected = viewModel.selectedAnimal == animal;

              return GestureDetector(
                onTap: () {
                  viewModel.filteredSelectionVaccines(animal);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.brown : Colors.transparent,
                    border: Border.all(
                      color: Colors.brown,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    animal,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.brown,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

      const SizedBox(height: 10),

      Expanded(
        child: viewModel.filteredVaccines == null || viewModel.filteredVaccines!.isEmpty
            ? const Center(child: Text("No Animals loaded."))
            : ListView.builder(
                padding: const EdgeInsets.all(2),
                itemCount: viewModel.filteredVaccines!.length,
                itemBuilder: (context, index) {
                  final vaccine = viewModel.filteredVaccines![index];
                  return _buildUserCard(context, vaccine, viewModel);
                },
              ),
      ),
    ],
  );
}


  Widget _buildUserCard(BuildContext context, Vaccine vaccine, GeneralConfigViewModel viewModel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
  title: Row(
    spacing: 10,
    children: [
      Container(
       padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
        
        color:  const Color.fromARGB(255, 146, 61, 5),
        borderRadius: BorderRadius.circular(10),
        
      ),
      child:Text(vaccine.animal??"",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),) ,
      ),
      Text(vaccine.name??""),
    ],
  ),
  trailing: Row(
    mainAxisSize: MainAxisSize.min, // <-- Add this line
    children: [
     
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          viewModel.gotoEditVaccine(vaccine);
        },
      ),
       IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          viewModel.deleteVaccine(vaccine.vaccineId);
        },
      )
    ],
  ),
),
    );
  }
}
