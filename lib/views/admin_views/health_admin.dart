// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:provider/provider.dart';

import '../../models/response_models/health_info.dart';
import '../../viewModel/admin_view_models/health_admin_view_model.dart';

class HealthAdmin extends StatelessWidget {
  HealthAdmin({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HealthAdminViewModel>();

    return StatefulWrapper(
      onInit: () => viewModel.gethealthInfo(),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: searchController,
                          onChanged: viewModel.filterHealths,
                          decoration: InputDecoration(
                            hintText: "Search by Name",
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
              const SizedBox(height: 12),
              Expanded(
                child: viewModel.filteredInfo == null
                    ? const Center(child: Text("No healths loaded."))
                    : ListView.builder(
                        padding: const EdgeInsets.all(2),
                        itemCount: viewModel.filteredInfo!.length,
                        itemBuilder: (context, index) {
                          final health = viewModel.filteredInfo![index];
                          return _buildHealthCard(context, health, viewModel);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard(BuildContext context, PetHealthInfo health,
      HealthAdminViewModel viewModel) {
    const Color lightBrown = Color(0xFFD7CCC8); // Soft light brown
    const Color darkBrown = Color.fromARGB(255, 146, 61, 5); // Rich dark brown
    const Color softGrey = Colors.grey;
    const Color cardBackground = Colors.white;
    return Card(
      color: cardBackground,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Name & Animal Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " ${health.petName} (${health.animalName})",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: lightBrown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    health.animalName ?? "N/A",
                    style: const TextStyle(
                      color: darkBrown,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Disease Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.medical_services, size: 20, color: softGrey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    health.diseaseName ?? "No Disease Info",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            // Optional Disability
            if ((health.disabilityName ?? "").isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.accessibility, size: 20, color: softGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      health.disabilityName!,
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await viewModel.gotoEdithealth(health);
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text("Edit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    viewModel.deleteHealth(health.healthId ?? "", health.petId);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
