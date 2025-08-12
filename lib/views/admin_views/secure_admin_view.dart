import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/secure_meetup.dart';
import 'package:petadoption/viewModel/admin_view_models/secureMeetup_admin_view_model.dart';
import 'package:provider/provider.dart';

class SecureAdminView extends StatelessWidget {
  SecureAdminView({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  final Color darkBrown = const Color(0xFF3E2723);
  final Color mediumBrown = const Color(0xFF5D4037);
  final Color lightBrown = const Color(0xFFD7CCC8);
  final Color greyTone = Colors.grey.shade400;
  final Color whiteTone = Colors.white;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SecureMeetupAdminViewModel>();

    return StatefulWrapper(
      onInit: () => viewModel.getSecureMeetups(),
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: lightBrown.withOpacity(0.3),
        body: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: whiteTone,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: darkBrown),
                      onPressed: () => viewModel.gotoPrevious(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: viewModel.filterSecureMeetup,
                        decoration: InputDecoration(
                          hintText: "Search by Name...",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: mediumBrown),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: greyTone),
                                  onPressed: () {
                                    searchController.clear();
                                    viewModel.resetFilter();
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // List Section
              Expanded(
                child: viewModel.filteredSecure == null
                    ? Center(
                        child: Text(
                          "No meetups loaded.",
                          style: TextStyle(
                              color: mediumBrown, fontWeight: FontWeight.w600),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: viewModel.filteredSecure!.length,
                        itemBuilder: (context, index) {
                          final secure = viewModel.filteredSecure![index];
                          return _buildUserCard(context, secure, viewModel);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, SecureMeetup secure,
      SecureMeetupAdminViewModel viewModel) {
    Color color = viewModel.getColor(secure.approval ?? "");

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [whiteTone, lightBrown.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.shade100,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address
            Text(
              secure.currentAddress ?? "Unknown Address",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 8),

            // Time
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: greyTone),
                const SizedBox(width: 6),
                Text(secure.time ?? "--:--",
                    style: TextStyle(color: mediumBrown)),
              ],
            ),
            const SizedBox(height: 4),

            // Phone
            Row(
              children: [
                Icon(Icons.phone, size: 18, color: greyTone),
                const SizedBox(width: 6),
                Text(
                  secure.phoneNumber ?? "No phone number",
                  style: TextStyle(color: mediumBrown),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Status & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    secure.approval ?? "Unknown",
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: color.withOpacity(0.15),
                  shape: StadiumBorder(side: BorderSide(color: color)),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.edit, size: 16),
                      label: const Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mediumBrown,
                        foregroundColor: whiteTone,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      onPressed: () => viewModel.gotoEditSecure(secure),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade400),
                      onPressed: () => viewModel
                          .deleteSecureMeetup(secure.secureMeetupId ?? ""),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
