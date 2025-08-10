import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/helpers/colors.dart';
import 'package:petadoption/helpers/constants.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/viewModel/admin_view_models/user_admin_view_model.dart';
import 'package:provider/provider.dart';

class UserAdmin extends StatelessWidget {
  UserAdmin({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserAdminViewModel>();

    return StatefulWrapper(
      onInit: () => viewModel.getUsers(),
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              // HEADER WITH GRADIENT
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: appBarGradient,
                  borderRadius: BorderRadius.only(
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
                            Icon(Icons.arrow_back, size: 24, color: darkBrown),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Manage Users",
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

              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: lightBrown.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: viewModel.filterUsers,
                    style: TextStyle(color: darkBrown, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Search by Email",
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

              // USER LIST
              Expanded(
                child: viewModel.filteredUsers == null
                    ? const Center(child: Text("No users loaded."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: viewModel.filteredUsers!.length,
                        itemBuilder: (context, index) {
                          final user = viewModel.filteredUsers![index];
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
      BuildContext context, User user, UserAdminViewModel viewModel) {
    final roleIcon = viewModel.getRoleIcon(user.role ?? "Adopter");

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: lightBrown.withOpacity(0.15),
      shadowColor: darkBrown.withOpacity(0.2),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Avatar with Ring
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: kLightBrownGradient,
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: whiteColor,
                backgroundImage: user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : null,
                child: user.profileImage == null
                    ? Icon(Icons.person, color: darkBrown, size: 30)
                    : null,
              ),
            ),
            const SizedBox(width: 12),

            // User Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.email ?? "N/A",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: darkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Role Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: lightBrown.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(roleIcon, size: 16, color: whiteColor),
                            const SizedBox(width: 4),
                            Text(
                              (user.role ?? "N/A").toUpperCase(),
                              style: TextStyle(color: whiteColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          _actionBtn(
                            icon: Icons.edit,
                            onTap: () => viewModel.gotoEditUser(user),
                            gradient: kButtonGradient,
                          ),
                          const SizedBox(width: 6),
                          _actionBtn(
                            icon: Icons.delete_forever,
                            onTap: () => viewModel.deleteUser(user.userId),
                            color: rejectedRed,
                          ),
                          const SizedBox(width: 6),
                          _actionBtn(
                            icon: Icons.link_rounded,
                            onTap: () => viewModel.showLink(
                              user.userId,
                              role: user.role ?? "N/A",
                            ),
                            color: lightBrown,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Actions
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(
      {required IconData icon,
      required VoidCallback onTap,
      Gradient? gradient,
      Color? color}) {
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
