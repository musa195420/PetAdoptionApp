// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/user_profile.dart';
import 'package:petadoption/viewModel/admin_view_models/donor_admin_view_model.dart';
import 'package:provider/provider.dart';

class DonorAdmin extends StatelessWidget {
  DonorAdmin({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DonorAdminViewModel>();

    return StatefulWrapper(
      onInit: () => viewModel.getDonors(),
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
                   Expanded( 
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: searchController,
                  onChanged: viewModel.filterDonors,
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
              ), ),
                 ],
               ),
			     ),
              const SizedBox(height: 12),
              Expanded(
                child: viewModel.filteredDonors == null
                    ? const Center(child: Text("No users loaded."))
                    : ListView.builder(
                        padding: const EdgeInsets.all(2),
                        itemCount: viewModel.filteredDonors!.length,
                        itemBuilder: (context, index) {
                          final user = viewModel.filteredDonors![index];
                          return _buildUserCard(context, user, viewModel);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserProfile user, DonorAdminViewModel viewModel) {
    
  String displayText = user.isActive.toString() == 'true' ? "Live" : "Offline";
   Color     color = user.isActive.toString() == 'true' ? Colors.green : Colors.red;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user.name, style: Theme.of(context).textTheme.titleMedium),
                      Spacer(),
                        Flexible(child: Text(user.location, style: Theme.of(context).textTheme.titleMedium)),
                    
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                       Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  border: Border.all(color: color),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(displayText, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
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
        icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
        onPressed: () async{
      viewModel.gotoEditAdopter(user);
        },
      ),
      IconButton(
        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
        onPressed: () {
          viewModel.deleteAdopter(user.donorId??"");
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
