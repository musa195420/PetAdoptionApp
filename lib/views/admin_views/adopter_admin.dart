import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/helpers/colors.dart';
import 'package:petadoption/helpers/constants.dart';
import 'package:petadoption/models/response_models/user_profile.dart';
import 'package:petadoption/viewModel/admin_view_models/adopter_admin_view_model.dart';
import 'package:provider/provider.dart';

class AdopterAdmin extends StatelessWidget {
  AdopterAdmin({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdopterAdminViewModel>();

    return StatefulWrapper(
      onInit: () => viewModel.getAdopters(),
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              // HEADER with frosted glass
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: appBarGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: viewModel.gotoPrevious,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(6),
                        child:
                            Icon(Icons.arrow_back, color: darkBrown, size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Manage Adopters",
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: lightBrown.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: viewModel.filterAdopters,
                    style: TextStyle(color: darkBrown, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Search by Name",
                      hintStyle: TextStyle(color: greyColor),
                      prefixIcon: Icon(Icons.search, color: darkBrown),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: rejectedRed),
                              onPressed: () {
                                searchController.clear();
                                viewModel.resetFilter();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Adopter List
              Expanded(
                child: viewModel.filteredAdopters == null
                    ? const Center(child: Text("No adopters loaded."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: viewModel.filteredAdopters!.length,
                        itemBuilder: (context, index) {
                          final user = viewModel.filteredAdopters![index];
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

  Widget _buildUserCard(
      BuildContext context, UserProfile user, AdopterAdminViewModel viewModel) {
    String displayText =
        user.isActive.toString() == 'true' ? "Live" : "Offline";
    Color statusColor =
        user.isActive.toString() == 'true' ? Colors.green : Colors.red;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white.withOpacity(0.6),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: lightBrown.withOpacity(0.3), width: 1),
              gradient: LinearGradient(
                colors: [
                  lightBrown.withOpacity(0.25),
                  whiteColor.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: lightBrown.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: darkBrown,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              user.location,
                              style: TextStyle(
                                fontSize: 14,
                                color: greyColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Status + Actions
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              border: Border.all(color: statusColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              displayText,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              _actionBtn(
                                icon: Icons.edit,
                                onTap: () => viewModel.gotoEditAdopter(user),
                                gradient: kButtonGradient,
                              ),
                              const SizedBox(width: 6),
                              _actionBtn(
                                icon: Icons.delete_forever,
                                onTap: () => viewModel
                                    .deleteAdopter(user.adopterId ?? ""),
                                color: rejectedRed,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required VoidCallback onTap,
    Gradient? gradient,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? color : null,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: whiteColor, size: 20),
      ),
    );
  }
}
