// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/admin_view_models/general_config_view_model.dart';
import '../../../../custom_widgets/default_text_input.dart';
import '../../../../helpers/locator.dart';
import '../../../../models/response_models/animal_Type.dart';
import 'package:provider/provider.dart';

import '../../../services/navigation_service.dart';

NavigationService get _navigationService => locator<NavigationService>();
dynamic formKey = GlobalKey<FormState>();
dynamic formKey2 = GlobalKey<FormState>();

class AnimalConfigModal extends StatelessWidget {
  AnimalConfigModal({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

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
                    child: const Icon(Icons.arrow_back,
                        size: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 60),
                Center(
                  child: Text(
                    "Add Animal",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 146, 61, 5),
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
              color: const Color.fromARGB(255, 146, 61, 5),
            ),
            Expanded(
              flex: 1,
              child: Column(
                spacing: 10,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.black, Color.fromARGB(255, 146, 61, 5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      controller: TabController(
                          initialIndex: viewModel.selectedIndex,
                          length: 2,
                          vsync: Navigator.of(
                              _navigationService.navigatorKey.currentContext!)),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: Colors.white,
                      onTap: (index) {
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
                flex: 3,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    if (viewModel.selectedIndex == 0)
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
                    if (viewModel.selectedIndex == 1)
                      DefaultTextInput(
                        controller: nameController,
                        labelText: "Add Names In Bulk",
                        hintText: "Separate By Commas For Example Leopard,Lion",
                        maxLines: 5,
                        icon: Icons.pets_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter animal names';
                          }
                          return null;
                        },
                      ),
                  ],
                )),
            _buildButton(viewModel, "Add Animal", () {
              if (formKey2.currentState!.validate()) {
                viewModel.animalName = nameController.text;
                viewModel.addAnimal(nameController.text);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEditAnimal(GeneralConfigViewModel viewModel) {
    nameController = TextEditingController(text: viewModel.animalName);
    idController = TextEditingController(text: viewModel.animalId);

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
                    child: const Icon(Icons.arrow_back,
                        size: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 80),
                const Text(
                  "Animal Edit",
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
              controller: idController,
              labelText: "ID",
              hintText: "ID",
              readOnly: true,
              enabled: false,
              icon: Icons.unarchive,
              validator: (value) =>
                  value == null || value.isEmpty ? 'ID required' : null,
            ),
            DefaultTextInput(
              controller: nameController,
              labelText: "Name",
              hintText: "Name",
              icon: Icons.pets_outlined,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Name required' : null,
            ),
            _buildButton(viewModel, "Update Animal", () {
              if (formKey.currentState!.validate()) {
                viewModel.animalName = nameController.text;
                viewModel.updateAnimal(idController.text, nameController.text);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      GeneralConfigViewModel viewModel, String text, Function() onTap) {
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
          style:
              const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
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
                  child: const Icon(Icons.arrow_back,
                      size: 30, color: Colors.white),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
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
        const SizedBox(height: 12),
        Expanded(
          child: viewModel.filteredAnimals == null ||
                  viewModel.filteredAnimals!.isEmpty
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

  Widget _buildUserCard(BuildContext context, AnimalType animals,
      GeneralConfigViewModel viewModel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text("⦾   ${animals.name}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // <-- Add this line
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                viewModel.gotoEditAnimal(animals);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                viewModel.deleteAnimal(animals.animalId);
              },
            )
          ],
        ),
      ),
    );
  }
}
