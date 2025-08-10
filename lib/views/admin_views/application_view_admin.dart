import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/application_view_model.dart';
import 'package:provider/provider.dart';

class ApplicationAdmin extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Color darkBrown = const Color(0xFF4E342E);
  final Color lightBrown = const Color(0xFFD7CCC8);
  final Color whiteColor = Colors.white;

  ApplicationAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ApplicationViewModel>();

    return StatefulWrapper(
      onInit: () => viewModel.getApplications(),
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: lightBrown,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, viewModel),
              _buildSearchBar(viewModel),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: viewModel.filteredApplications == null
                      ? _buildLoading()
                      : viewModel.filteredApplications!.isEmpty
                          ? _buildEmpty()
                          : _buildList(viewModel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ApplicationViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: darkBrown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back, color: whiteColor),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Application Management",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: darkBrown),
            ),
          ),
          InkWell(
            onTap: () => _showFilter(context, viewModel),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: darkBrown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.filter_list, color: whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ApplicationViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search by user email...",
          prefixIcon: Icon(Icons.search, color: darkBrown),
          filled: true,
          fillColor: whiteColor.withOpacity(0.9),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: viewModel.setSearchQuery,
      ),
    );
  }

  Widget _buildList(ApplicationViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.filteredApplications!.length,
      itemBuilder: (context, index) {
        final app = viewModel.filteredApplications![index];
        final user = app.user;

        return GestureDetector(
          onTap: () {
            viewModel.gotoApplicatiopage(user?.userId ?? "", app);
          },
          child: Card(
            color: whiteColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      user?.profileImage ?? "",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        "assets/images/noprofile.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Long Email wraps here
                        Text(
                          user?.email ?? "No Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkBrown,
                            fontSize: 14,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),

                        // Row with Role & Status Chip
                        Row(
                          children: [
                            ChoiceChip(
                              label: Text(user?.role ?? "Unknown"),
                              selected: false,
                              labelStyle: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusChip(app.verificationStatus ?? ""),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Text(
                          "Profession: ${app.profession ?? "N/A"}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Phone: ${user?.phoneNumber ?? ''}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    final lowerStatus = status.toLowerCase();
    IconData icon;
    Color color;

    if (lowerStatus == "approved") {
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (lowerStatus == "rejected") {
      icon = Icons.cancel;
      color = Colors.red;
    } else {
      icon = Icons.hourglass_empty;
      color = Colors.orange;
    }

    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text("No applications found",
          style: TextStyle(color: darkBrown.withOpacity(0.7), fontSize: 14)),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  void _showFilter(BuildContext context, ApplicationViewModel viewModel) {
    final statuses = [
      {"label": "All", "icon": Icons.all_inclusive, "color": Colors.blueGrey},
      {"label": "Approved", "icon": Icons.check_circle, "color": Colors.green},
      {"label": "Rejected", "icon": Icons.cancel, "color": Colors.red},
      {
        "label": "Pending",
        "icon": Icons.hourglass_empty,
        "color": Colors.orange
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Apply Filters",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: statuses.map((status) {
                  final isSelected = viewModel.verificationStatusFilter ==
                      (status["label"] == "All"
                          ? null
                          : (status["label"] as String).toLowerCase());

                  return ChoiceChip(
                    avatar: Icon(
                      status["icon"] as IconData,
                      size: 18,
                      color:
                          isSelected ? Colors.white : status["color"] as Color,
                    ),
                    label: Text(
                      status["label"] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected
                            ? Colors.white
                            : status["color"] as Color,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: status["color"] as Color,
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (_) {
                      viewModel.setVerificationStatusFilter(
                        status["label"] == "All"
                            ? null
                            : (status["label"] as String).toLowerCase(),
                      );
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
