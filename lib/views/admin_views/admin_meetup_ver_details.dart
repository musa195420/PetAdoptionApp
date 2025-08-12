import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:petadoption/extenshions/string_ext.dart';
import 'package:petadoption/helpers/constants.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/response_models/meetup_verification.dart';
import 'package:petadoption/viewModel/admin_view_models/meetup_verification_model.dart';

bool _isSelected = false;
MeetupVerificationViewModel get _ver => locator<MeetupVerificationViewModel>();

class MeetupVerificationDetailPage extends StatefulWidget {
  final MeetupVerification meetupVerification;

  const MeetupVerificationDetailPage({
    super.key,
    required this.meetupVerification,
  });

  @override
  State<MeetupVerificationDetailPage> createState() =>
      _MeetupVerificationDetailPageState();
}

class _MeetupVerificationDetailPageState
    extends State<MeetupVerificationDetailPage> {
  late String currentStatus;

  final Color darkBrown = const Color(0xFF4E342E);
  final Color lightBrown = const Color(0xFFD7CCC8);
  final Color whiteColor = Colors.white;

  @override
  void initState() {
    super.initState();
    currentStatus =
        widget.meetupVerification.adopterVerificationStatus?.toLowerCase() ??
            "pending";
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      elevation: 2,
      shadowColor: Colors.black45,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showStatusChangeDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF3E2723), // Dark brown background
          title: const Text(
            "Change Verification Status",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusOption("pending"),
              _buildStatusOption("approved"),
              _buildStatusOption("rejected"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusOption(String status) {
    // Elegant 3-tone brown color palette
    final Map<String, Color> primaryColors = {
      "approved": const Color(0xFFA1887F), // Light brown
      "rejected": const Color(0xFF8D6E63), // Medium brown
      "pending": const Color(0xFF6D4C41), // Dark brown
    };

    final Map<String, IconData> icons = {
      "approved": Icons.check_circle,
      "rejected": Icons.cancel,
      "pending": Icons.hourglass_bottom,
    };

    final color = primaryColors[status] ?? primaryColors["pending"]!;
    final icon = icons[status] ?? icons["pending"]!;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          currentStatus = status;
          widget.meetupVerification.adopterVerificationStatus =
              status[0].toUpperCase() + status.substring(1);
        });
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 14),
            Text(
              status[0].toUpperCase() + status.substring(1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const Spacer(),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {VoidCallback? onTap, bool showLink = false}) {
    final content = Row(
      children: [
        Icon(icon, size: 20, color: darkBrown),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
        if (showLink)
          GestureDetector(
            onTap: onTap,
            child: Icon(Icons.link, color: Colors.blueAccent),
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: content,
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: appBarGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => navigationService.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Meetup verification Details',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  // Placeholder to balance the Row so text stays centered
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: darkBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const Divider(color: Colors.black26, height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meetup = widget.meetupVerification;

    final adminStatus = currentStatus;
    final paymentStatus = meetup.paymentStatus ?? "Not Paid";
    final userVerificationStatus =
        meetup.userVerification != null ? "Done" : "Not Done";
    final applicationVerificationStatus =
        meetup.application?.verificationStatus ?? "Pending";

    final amount = meetup.paymentInfo?.amount ?? 0;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Chips row
                  Wrap(
                    spacing: 14,
                    runSpacing: 10,
                    children: [
                      _buildStatusChip("Admin Verification", adminStatus,
                          Icons.verified_user),
                      _buildStatusChip("Payment", paymentStatus,
                          Icons.account_balance_wallet),
                      _buildStatusChip("User Verification",
                          userVerificationStatus, Icons.person),
                      _buildStatusChip("Application",
                          applicationVerificationStatus, Icons.description),
                    ],
                  ),

                  const SizedBox(height: 28),

                  _sectionCard("Verification Info", [
                    _infoRow(Icons.confirmation_num, "Meetup ID",
                        meetup.meetupId ?? "N/A"),
                    _infoRow(Icons.verified_user, "Adopter Verification Status",
                        "${adminStatus[0].toUpperCase()}${adminStatus.substring(1)}"),
                    if (meetup.userVerification != null &&
                        meetup.userVerification?.userId != null)
                      _infoRow(
                        Icons.link,
                        "See Adopter",
                        "",
                        showLink: true,
                        onTap: () {
                          _ver.showLink(meetup.userVerification?.userId ?? "");
                        },
                      )
                  ]),

                  _sectionCard("Payment Info", [
                    _infoRow(Icons.payment, "Payment Status", paymentStatus),
                    _infoRow(
                        Icons.attach_money, "Amount", "\$${amount.toString()}"),
                  ]),

                  _sectionCard("Application Info", [
                    _infoRow(Icons.assignment, "Application ID",
                        meetup.applicationId ?? "N/A"),
                    _infoRow(
                        Icons.verified_outlined,
                        "Application Verification Status",
                        "${applicationVerificationStatus[0].toUpperCase()}${applicationVerificationStatus.substring(1)}"),
                    _infoRow(
                      Icons.link,
                      "Go to Application",
                      "",
                      showLink: true,
                      onTap: () {
                        _ver.gotoApplicatiopage(
                            meetup.application?.userId ?? "",
                            meetup.application!);
                      },
                    )
                  ]),

                  _sectionCard("User Verification", [
                    _infoRow(Icons.person_pin, "User Verified",
                        userVerificationStatus),
                    _infoRow(
                      Icons.link,
                      "Go to User Verification",
                      "",
                      showLink: true,
                      onTap: () {
                        _ver.gotoUserVerificationpage(
                            meetup.application?.userId ?? "",
                            meetup.userVerification!);
                      },
                    ),
                  ]),

                  const SizedBox(height: 40),

                  Center(
                    child: ChoiceChip(
                      label: const Text(
                        "Change Admin Verification Status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      avatar: const Icon(
                        Icons
                            .security, // secure icon, you can also use Icons.lock, Icons.shield
                        size: 20,
                        color: Colors.white,
                      ),
                      selectedColor: const Color.fromARGB(255, 116, 65, 28),
                      backgroundColor: const Color.fromARGB(255, 74, 35, 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      selected:
                          _isSelected, // a boolean to manage selection state
                      onSelected: (bool selected) {
                        // update your selection state and show dialog

                        _showStatusChangeDialog();
                      },
                    ),
                  ),

                  _buildUpdate()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdate() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            _ver.updateMeetupVerification(widget.meetupVerification);
          },
          icon: const Icon(Icons.pets, size: 24),
          label: const Text(
            'Update Item',
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 53, 30, 14),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            shadowColor: Colors.brown.shade200,
          ),
        ),
      ),
    );
  }
}
