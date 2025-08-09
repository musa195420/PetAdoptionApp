import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:petadoption/custom_widgets/colors.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/viewModel/admin_view_models/pet_admin_view_model.dart';
import 'package:provider/provider.dart';

class PetAdmin extends StatelessWidget {
  PetAdmin({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  // Define your new colors here
  final Color darkBrown = const Color(0xFF4E342E);
  final Color lightBrown = const Color(0xFFD7CCC8);
  final Color whiteColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PetAdminViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // We'll override the dark mode check, you can toggle it if you want
    // For now, assume always using your brown theme
    return StatefulWrapper(
        onInit: () => viewModel.getPets(),
        onDispose: () {},
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: lightBrown, // Light brown background
          body: SafeArea(
            child: Column(
              children: [
                // App Bar Section
                _buildAppBar(context, viewModel),

                // Search Section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: _buildSearchField(context, viewModel),
                ),

                // Pet List Section
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: viewModel.filteredPets == null
                        ? _buildLoadingShimmer()
                        : viewModel.filteredPets!.isEmpty
                            ? _buildEmptyState()
                            : _buildPetList(viewModel, context),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildAppBar(BuildContext context, PetAdminViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back Button
          InkWell(
            onTap: () => viewModel.gotoPrevious(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: darkBrown, // dark brown background
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: darkBrown.withOpacity(0.7),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back,
                  color: whiteColor), // white icon on dark brown
            ),
          ),

          const SizedBox(width: 16),

          // Title
          Text("Pet Management",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkBrown, // dark brown text
              )),

          const Spacer(),

          // Filter Button
          InkWell(
            onTap: () => _showFilterOptions(context, viewModel),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: darkBrown,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: darkBrown.withOpacity(0.7),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(Icons.filter_list, color: whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, PetAdminViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: searchController,
        onChanged: viewModel.filterPets,
        style: TextStyle(color: darkBrown),
        decoration: InputDecoration(
          hintText: "Search pets...",
          hintStyle: TextStyle(color: darkBrown.withOpacity(0.6)),
          prefixIcon: Icon(Icons.search, color: darkBrown.withOpacity(0.6)),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: darkBrown.withOpacity(0.6)),
                  onPressed: () {
                    searchController.clear();
                    viewModel.resetFilters();
                  },
                )
              : null,
          filled: true,
          fillColor: whiteColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context, PetAdminViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // lets it expand properly
      backgroundColor: Colors.transparent, // for rounded corners to work nicely
      builder: (context) {
        return FilterOptionsDialog(
          initialApprovalFilter: viewModel.approvalFilter,
          initialLiveStatusFilter: viewModel.liveStatusFilter,
          onApply: (approval, liveStatus) {
            viewModel.setApprovalFilter(approval);
            viewModel.setLiveStatusFilter(liveStatus);
          },
        );
      },
    );
  }

  Widget _buildPetList(PetAdminViewModel viewModel, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: viewModel.filteredPets!.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final pet = viewModel.filteredPets![index];
        return _buildPetCard(context, pet, viewModel);
      },
    );
  }

  Widget _buildPetCard(
      BuildContext context, PetResponse pet, PetAdminViewModel viewModel) {
    final status = pet.isLive == true ? "Live" : "Not Live";
    final statusColor = pet.isLive == true ? greenColor : lightred;

    // Normalize approval status to lowercase string for safe checks
    final approvalStatus = (pet.isApproved ?? "").toLowerCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: whiteColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => viewModel.gotoEditPet(pet),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Row(
                children: [
                  // Pet Image
                  Hero(
                    tag: 'pet-${pet.petId}',
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: pet.image != null
                            ? DecorationImage(
                                image: NetworkImage(pet.image!),
                                fit: BoxFit.cover)
                            : const DecorationImage(
                                image: AssetImage("assets/images/signup.png"),
                                fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Pet Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(pet.name ?? "Unnamed",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: darkBrown,
                                )),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(status,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(pet.animal ?? "Unknown breed",
                            style: TextStyle(
                              color: darkBrown.withOpacity(0.7),
                              fontSize: 14,
                            )),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person_outline,
                                size: 16, color: darkBrown.withOpacity(0.7)),
                            const SizedBox(width: 4),
                            Text(pet.userEmail ?? "No owner",
                                style: TextStyle(
                                  color: darkBrown.withOpacity(0.7),
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildActionButton(
                              icon: Icons.edit,
                              color: darkBrown,
                              onPressed: () => viewModel.gotoEditPet(pet),
                              bgColor: lightBrown,
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              icon: Icons.delete,
                              color: rejectedRed,
                              onPressed: () =>
                                  _showDeleteDialog(context, viewModel, pet),
                              bgColor: lightBrown,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Red Rejected Stamp Overlay
              if (approvalStatus == "rejected")
                Positioned(
                  top: 8,
                  right: 8,
                  child: Transform.rotate(
                    angle: -0.3, // slight tilt for style
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: rejectedRed, width: 2),
                        color: rejectedRed.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'REJECTED',
                        style: TextStyle(
                          color: rejectedRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    Color? bgColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor ?? lightBrown,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 60, color: darkBrown.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text("No pets found",
              style: TextStyle(
                fontSize: 18,
                color: darkBrown.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          Text("Try adjusting your search or filter",
              style: TextStyle(
                color: darkBrown.withOpacity(0.5),
              )),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: lightBrown.withOpacity(0.3),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(
      BuildContext context, PetAdminViewModel viewModel, PetResponse pet) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete ${pet.name ?? 'this pet'}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                viewModel.deletePet(pet.petId ?? "");
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

class FilterOptionsDialog extends StatefulWidget {
  final String? initialApprovalFilter;
  final String? initialLiveStatusFilter;
  final void Function(String? approvalFilter, String? liveStatusFilter) onApply;

  const FilterOptionsDialog({
    super.key,
    required this.initialApprovalFilter,
    required this.initialLiveStatusFilter,
    required this.onApply,
  });

  @override
  State<FilterOptionsDialog> createState() => _FilterOptionsDialogState();
}

class _FilterOptionsDialogState extends State<FilterOptionsDialog> {
  String? selectedApproval;
  String? selectedLiveStatus;

  // Reuse your colors here:
  final Color darkBrown = const Color(0xFF4B2E05);
  final Color lightBrown = const Color(0xFFD2B48C);
  final Color greyColor = Colors.grey.shade400;

  @override
  void initState() {
    super.initState();
    selectedApproval = widget.initialApprovalFilter;
    selectedLiveStatus = widget.initialLiveStatusFilter;
  }

  Widget _buildChoiceChips(
    String title,
    List<String?> options,
    String? selected,
    void Function(String?) onSelected,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: options.map((option) {
        final displayText = (option == null || option.isEmpty)
            ? "All"
            : option[0].toUpperCase() + option.substring(1);
        final isSelected = selected == option;

        return ChoiceChip(
          label: Text(
            displayText,
            style: TextStyle(
              color: isSelected ? Colors.white : darkBrown,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              onSelected(option);
            });
          },
          backgroundColor: Colors.transparent,
          selectedColor: darkBrown,
          side: BorderSide(color: darkBrown, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          // Customize the checkmark color:
          checkmarkColor: isSelected ? Colors.white : darkBrown,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          labelPadding: const EdgeInsets.symmetric(horizontal: 0),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom), // handle keyboard
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              Text(
                "Filter Options",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Approval Status",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: darkBrown,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              _buildChoiceChips(
                  "Approval Status",
                  [null, "pending", "approved", "rejected"],
                  selectedApproval,
                  (val) => selectedApproval = val),
              const SizedBox(height: 28),
              Text(
                "Live Status",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: darkBrown,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              _buildChoiceChips("Live Status", [null, "live", "not_live"],
                  selectedLiveStatus, (val) => selectedLiveStatus = val),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: kButtonGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(selectedApproval, selectedLiveStatus);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Apply Filters",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedApproval = null;
                      selectedLiveStatus = null;
                    });
                    widget.onApply(null, null);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Clear Filters",
                    style: TextStyle(
                      color: darkBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper extension to wrap ChoiceChip with gradient Container background
extension GradientChip on ChoiceChip {
  Widget wrapWithGradient(Gradient? gradient, Color fallbackColor) {
    if (gradient == null) {
      return Container(
        decoration: BoxDecoration(
          color: fallbackColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: this,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: this,
      );
    }
  }
}
