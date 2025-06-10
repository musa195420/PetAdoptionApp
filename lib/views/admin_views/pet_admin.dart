// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/viewModel/admin_view_models/pet_admin_view_model.dart';
import 'package:provider/provider.dart';

class PetAdmin extends StatelessWidget {
  PetAdmin({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PetAdminViewModel>();

    return StatefulWrapper(
      onInit: () => viewModel.getPets(),
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
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
                          color: const Color.fromARGB(255, 146, 61, 5),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      // <-- Fix: this makes TextField take the remaining space
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: searchController,
                          onChanged: viewModel.filterPets,
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
                            fillColor: Theme.of(context).cardColor,
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
                child: viewModel.filteredPets == null
                    ? const Center(child: Text("No Pets loaded."))
                    : ListView.builder(
                        padding: const EdgeInsets.all(2),
                        itemCount: viewModel.filteredPets!.length,
                        itemBuilder: (context, index) {
                          final pets = viewModel.filteredPets![index];
                          return _buildUserCard(context, pets, viewModel);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(
      BuildContext context, PetResponse pets, PetAdminViewModel viewModel) {
    String displayText = pets.isLive.toString() == 'true' ? "Live" : "NotLive";
    Color color = pets.isLive.toString() == 'true' ? Colors.green : Colors.red;

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
                CircleAvatar(
                  radius: 30,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  backgroundImage:
                      pets.image != null ? NetworkImage(pets.image!) : null,
                  child: pets.image == null
                      ? Image.asset("assets/images/signup.png")
                      : null,
                ),
                Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      pets.animal ?? "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ))
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(pets.name ?? "",
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(child: Text(pets.userEmail ?? ""))
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              border: Border.all(color: color),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(displayText,
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () async {
                                viewModel.gotoEditPet(pets);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: Theme.of(context).colorScheme.error),
                              onPressed: () {
                                viewModel.deletePet(pets.petId ?? "");
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
