import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
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
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: searchController,
                  onChanged: viewModel.filterUsers,
                  decoration: InputDecoration(
                    hintText: "Search by email",
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
              const SizedBox(height: 12),
              Expanded(
                child: viewModel.filteredUsers == null
                    ? const Center(child: Text("No users loaded."))
                    : ListView.builder(
                        padding: const EdgeInsets.all(2),
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

  Widget _buildUserCard(BuildContext context, User user, UserAdminViewModel viewModel) {
    final roleIcon = viewModel.getRoleIcon(user.role ?? '');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              backgroundImage: user.profileImage != null ? NetworkImage(user.profileImage!) : null,
              child: user.profileImage == null
                  ? Icon(Icons.person, color: Theme.of(context).primaryColor, size: 30)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.email, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(roleIcon, size: 18, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 6),
                          Text((user.role ).toUpperCase(),
                              style: Theme.of(context).textTheme.bodySmall),
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
      viewModel.gotoEditUser(user);
        },
      ),
      IconButton(
        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
        onPressed: () {
          viewModel.deleteUser(user.userId);
        },
      ),
      IconButton(
        icon: Icon(Icons.link, color: Theme.of(context).colorScheme.secondary),
        onPressed: () {
          viewModel.showLink(user);
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
