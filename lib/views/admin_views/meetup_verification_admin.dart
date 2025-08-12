import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/viewModel/admin_view_models/meetup_verification_model.dart';
import 'package:provider/provider.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

final Color darkBrown = const Color(0xFF4E342E);
final Color lightBrown = const Color(0xFFD7CCC8);
final Color whiteColor = Colors.white;

MeetupVerificationViewModel get _meetupModel =>
    locator<MeetupVerificationViewModel>();

class MeetupVerificationAdmin extends StatefulWidget {
  const MeetupVerificationAdmin({super.key});

  @override
  State<MeetupVerificationAdmin> createState() =>
      _MeetupVerificationAdminState();
}

class _MeetupVerificationAdminState extends State<MeetupVerificationAdmin> {
  @override
  void initState() {
    _meetupModel.getMeetupVerifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MeetupVerificationViewModel>();
    return Scaffold(
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
                child: viewModel.fiteredMeetups == null
                    ? _buildLoading()
                    : viewModel.fiteredMeetups!.isEmpty
                        ? _buildEmpty()
                        : _buildList(viewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, MeetupVerificationViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          InkWell(
            onTap: () => navigationService.pop(),
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
              "Meetup Verification Management",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
          ),
          InkWell(
            onTap: () => _showFilter(context, vm),
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

  Widget _buildSearchBar(MeetupVerificationViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search by meetup ID or user email...",
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
        onChanged: vm.setSearchQuery,
      ),
    );
  }

  Widget _buildList(MeetupVerificationViewModel vm) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.fiteredMeetups!.length,
      itemBuilder: (context, index) {
        final meetup = vm.fiteredMeetups![index];

        final status = meetup.adopterVerificationStatus ?? "Pending";
        final paymentStatus = meetup.paymentStatus ?? "Not Paid";
        final userVerificationStatus =
            meetup.userVerification != null ? "Done" : "Not Done";
        final applicationVerificationStatus =
            meetup.application?.verificationStatus ?? "Pending";
        final amount = meetup.paymentInfo?.amount ?? 0;

        return GestureDetector(
          onTap: () {
            vm.gotoMeetupVerificationDetails(meetup);
          },
          child: Card(
            color: whiteColor,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Meetup ID: ${meetup.meetupId ?? 'N/A'}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildStatusChip(
                          "Admin Verification", status, Icons.verified_user),
                      _buildStatusChip("Payment", paymentStatus,
                          Icons.account_balance_wallet),
                      _buildStatusChip("User Verification",
                          userVerificationStatus, Icons.person),
                      _buildStatusChip("Application",
                          applicationVerificationStatus, Icons.description),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Payment Amount: \$${amount.toString()}",
                    style: TextStyle(
                        fontSize: 14, color: darkBrown.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Application ID: ${meetup.applicationId ?? 'N/A'}",
                    style: TextStyle(
                        fontSize: 14, color: darkBrown.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String label, String status, IconData icon) {
    IconData displayIcon = icon;
    Color color;

    switch (status.toLowerCase()) {
      case "approved":
      case "done":
      case "paid":
        color = Colors.green.shade600;
        displayIcon = Icons.check_circle;
        break;
      case "rejected":
      case "not done":
      case "not paid":
        color = Colors.red.shade600;
        displayIcon = Icons.cancel;
        break;
      case "pending":
      default:
        color = Colors.orange.shade600;
        displayIcon = Icons.hourglass_bottom;
        break;
    }

    return Chip(
      avatar: Icon(displayIcon, color: Colors.white, size: 18),
      label: Text(
        "$label: ${status[0].toUpperCase()}${status.substring(1)}",
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text("No meetup verifications found",
          style: TextStyle(color: darkBrown.withOpacity(0.7), fontSize: 16)),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  void _showFilter(BuildContext context, MeetupVerificationViewModel vm) {
    final verificationStatuses = [
      {"label": "All", "value": null},
      {"label": "Pending", "value": "pending"},
      {"label": "Approved", "value": "approved"},
      {"label": "Rejected", "value": "rejected"},
    ];

    final paymentStatuses = [
      {"label": "All", "value": null},
      {"label": "Paid", "value": "paid"},
      {"label": "Not Paid", "value": "not paid"},
    ];

    final userVerificationStatuses = [
      {"label": "All", "value": null},
      {"label": "Done", "value": "done"},
      {"label": "Not Done", "value": "not done"},
    ];

    final applicationVerificationStatuses = [
      {"label": "All", "value": null},
      {"label": "Pending", "value": "pending"},
      {"label": "Approved", "value": "approved"},
      {"label": "Rejected", "value": "rejected"},
    ];

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          String? selectedVerification = vm.verificationStatusFilter;
          String? selectedPayment = vm.paymentStatusFilter;
          String? selectedUserVerification = vm.userVerificationStatusFilter;
          String? selectedApplicationVerification =
              vm.applicationVerificationStatusFilter;

          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.98),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 14,
                        offset: const Offset(0, -4)),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Apply Filters",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 24),

                      // Verification Status
                      const Text(
                        "Admin Verification Status",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: verificationStatuses.map((status) {
                          final isSelected =
                              selectedVerification == status["value"];
                          return ChoiceChip(
                            label: Text(status["label"] as String),
                            selected: isSelected,
                            selectedColor: darkBrown,
                            backgroundColor: lightBrown,
                            labelStyle: TextStyle(
                              color: isSelected ? whiteColor : darkBrown,
                              fontWeight: FontWeight.w600,
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                selectedVerification = selected
                                    ? status["value"] as String?
                                    : null;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Payment Status
                      const Text(
                        "Payment Status",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: paymentStatuses.map((status) {
                          final isSelected = selectedPayment == status["value"];
                          return ChoiceChip(
                            label: Text(status["label"] as String),
                            selected: isSelected,
                            selectedColor: darkBrown,
                            backgroundColor: lightBrown,
                            labelStyle: TextStyle(
                              color: isSelected ? whiteColor : darkBrown,
                              fontWeight: FontWeight.w600,
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                selectedPayment = selected
                                    ? status["value"] as String?
                                    : null;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // User Verification Status
                      const Text(
                        "User Verification Status",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: userVerificationStatuses.map((status) {
                          final isSelected =
                              selectedUserVerification == status["value"];
                          return ChoiceChip(
                            label: Text(status["label"] as String),
                            selected: isSelected,
                            selectedColor: darkBrown,
                            backgroundColor: lightBrown,
                            labelStyle: TextStyle(
                              color: isSelected ? whiteColor : darkBrown,
                              fontWeight: FontWeight.w600,
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                selectedUserVerification = selected
                                    ? status["value"] as String?
                                    : null;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Application Verification Status
                      const Text(
                        "Application Verification Status",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: applicationVerificationStatuses.map((status) {
                          final isSelected = selectedApplicationVerification ==
                              status["value"];
                          return ChoiceChip(
                            label: Text(status["label"] as String),
                            selected: isSelected,
                            selectedColor: darkBrown,
                            backgroundColor: lightBrown,
                            labelStyle: TextStyle(
                              color: isSelected ? whiteColor : darkBrown,
                              fontWeight: FontWeight.w600,
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                selectedApplicationVerification = selected
                                    ? status["value"] as String?
                                    : null;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: darkBrown),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkBrown,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              vm.setVerificationStatusFilter(
                                  selectedVerification);
                              vm.setPaymentStatusFilter(selectedPayment);
                              vm.setUserVerificationStatusFilter(
                                  selectedUserVerification);
                              vm.setApplicationVerificationStatusFilter(
                                  selectedApplicationVerification);
                              Navigator.pop(context);
                            },
                            child: const Text("Apply",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
