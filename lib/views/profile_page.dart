// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/loading_indicators.dart';
import 'package:petadoption/helpers/current_location.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/request_models/application_model.dart';
import 'package:petadoption/models/response_models/meetup.dart';
import 'package:petadoption/models/response_models/payment.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/models/response_models/secure_meetup.dart';
import 'package:petadoption/models/response_models/user_profile.dart';
import 'package:petadoption/models/response_models/user_verification.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';

NavigationService get _navigationService => locator<NavigationService>();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryColor = const Color(0xFF3E2723);
  final Color accentColor = const Color.fromARGB(255, 83, 36, 6);
  final Color backgroundColor = const Color(0xFFFAF3E0);
  UserProfile? user;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  late ProfileViewModel viewModel;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();

    viewModel = context.read<ProfileViewModel>();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final loadedUser = await viewModel.getUser();
    if (loadedUser != null) {
      setState(() {
        user = loadedUser;
        nameController.text = user?.name ?? "";
        addressController.text = user?.location ?? "";
        phoneController.text = user?.phonenumber ?? "";
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: user == null
          ? const Center(
              child: FadingCircularDots(
                count: 8,
                radius: 20,
                dotRadius: 3,
                duration: Duration(milliseconds: 1200),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
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
                      child: const Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _profileHeaderWidget(),
                          const SizedBox(height: 24),
                          _updateInfoWidget(),
                          const SizedBox(height: 24),
                          _infoSectionWidget(),
                          const SizedBox(height: 24),
                          _logoutButton(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _profileHeaderWidget() {
    return Consumer<ProfileViewModel>(
      builder: (_, viewModel, __) {
        User? user = viewModel.user;
        final profile = viewModel.userProfile;

        if (user == null) {
          return const Center(child: Text("User data is unavailable"));
        }

        return Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: accentColor.withOpacity(0.1),
                    backgroundImage: viewModel.path != null
                        ? FileImage(File(viewModel.path ?? ""))
                        : (user.profileImage != null &&
                                user.profileImage!.isNotEmpty)
                            ? NetworkImage(user.profileImage!) as ImageProvider
                            : const AssetImage('assets/images/noprofile.png'),
                  ),
                ),
                if (viewModel.editMode)
                  InkWell(
                    onTap: () {
                      if (viewModel.path != null) {
                        viewModel.removeImagePath();
                      } else {
                        viewModel.saveImagePath();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: viewModel.path != null
                          ? Icon(Icons.delete, size: 22, color: primaryColor)
                          : Icon(Icons.camera_alt,
                              size: 22, color: primaryColor),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Text(
                  profile?.name ?? "Name not set",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 0.4,
                  ),
                ),
                if (user.email != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "@${(user.email ?? "N/A").split("@")[0]}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _updateInfoWidget() {
    return Consumer<ProfileViewModel>(
      builder: (_, viewModel, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.8,
                      color: viewModel.editMode
                          ? Colors.white
                          : Colors.brown.shade800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    viewModel.editMode ? Icons.edit_off_rounded : Icons.edit,
                    size: 12,
                    color: viewModel.editMode
                        ? Colors.white
                        : Colors.brown.shade800,
                  ),
                ],
              ),
              selected: viewModel.editMode,
              selectedColor: Colors.brown.shade600,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: viewModel.editMode ? 5 : 0,
              pressElevation: 8,
              onSelected: (selected) {
                viewModel.seteditMode(selected);
              },
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: viewModel.editMode
                  ? InkWell(
                      key: const ValueKey('update_button'),
                      onTap: () async {
                        await viewModel.updateUser(
                          phoneController.text,
                          addressController.text,
                          nameController.text,
                        );
                        viewModel.seteditMode(false);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 28),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade700,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.shade900.withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  Widget _infoSectionWidget() {
    return Consumer<ProfileViewModel>(
      builder: (_, viewModel, __) {
        User? user = viewModel.user;
        final profile = viewModel.userProfile;

        if (user == null) {
          return const Center(child: Text("User data is unavailable"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
          children: [
            _buildExpandableCard(
              icon: Icons.person,
              title: "Personal Information",
              children: [
                viewModel.editMode
                    ? _editableField("Name", nameController, Icons.person)
                    : _infoTile("Name", profile?.name ?? "-"),
                _infoTile("Email", user.email ?? "N/A"),
                viewModel.editMode
                    ? _editableField(
                        "Phone", phoneController, Icons.phone_callback)
                    : _infoTile("Phone", user.phoneNumber ?? "N/A"),
                viewModel.editMode
                    ? _editableField(
                        "Address", addressController, Icons.location_on)
                    : _infoTile("Address", profile?.location ?? "-"),
              ],
            ),
            _buildExpandableCard(
              icon: Icons.security,
              title: "Login and Security",
              children: [
                _infoTile("Role", user.role ?? "N/A"),
                _infoTile("Device ID", user.deviceId ?? "N/A"),
                _infoTile(
                  "Is Active",
                  (profile?.isActive ?? false) ? "Yes" : "No",
                  color:
                      (profile?.isActive ?? false) ? Colors.green : Colors.red,
                ),
              ],
            ),
            if (user.role?.toLowerCase() == "donor")
              _buildExpandableCard(
                icon: Icons.pets,
                title: "Your Pets",
                children: [
                  viewModel.pet != null && viewModel.pet!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: viewModel.pet!
                              .map((pet) => _buildPetCard(pet))
                              .toList(),
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _navigationService.pushNamed(
                            Routes.petpage,
                            args: TransitionType.fade,
                            data: null,
                          );
                        },
                        icon: const Icon(Icons.pets, size: 24),
                        label: const Text(
                          'Add Pet',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 53, 30, 14),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          shadowColor: Colors.brown.shade200,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (viewModel.meets != null && viewModel.meets!.isNotEmpty)
              _buildExpandableCard(
                icon: Icons.handshake,
                title: "Meetups",
                children: viewModel.meets!
                    .map((meet) => _buildMeetupCard(meet))
                    .toList(),
              ),
            if (viewModel.securemeets.isNotEmpty)
              _buildExpandableCard(
                icon: Icons.lock,
                title: "Secure Meetup",
                children: viewModel.securemeets
                    .map((secure) => _buildSecureMeetupCard(secure))
                    .toList(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMeetupCard(Meetup meet) {
    final bool isThreeStepProtected =
        (meet.addVerification ?? "").toLowerCase() == "applied";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 244, 236),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon for Meetup
          InkWell(
            onTap: () {
              viewModel.gotoMeetupModal(meet);
            },
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.handshake, size: 40, color: Colors.blueAccent),
            ),
          ),
          const SizedBox(width: 16),

          // Meetup Info
          Expanded(
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet Name + Lock Icon if protected
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color.fromARGB(255, 254, 170, 3),
                            ),
                            child: const Icon(Icons.pets_sharp),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            meet.petName ?? "Unknown Pet",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isThreeStepProtected)
                      const Tooltip(
                        message: "3 Step Protected",
                        child: Icon(
                          Icons.lock,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                _infoLine("Location", meet.location),
                _infoLine("Time", meet.time),
                _infoLine("Adopter", meet.adopterEmail),
                _infoLine("Donor", meet.donorEmail),

                if (meet.rejectionReason != null &&
                    meet.rejectionReason!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Rejected: ${meet.rejectionReason}",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // ---------- Application & Payment Status ----------

// Usage in your column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAdminVerification(meet),
                    if (meet.application != null)
                      _buildApplicationStatus(meet)
                    else
                      const SizedBox.shrink(),
                    const SizedBox(height: 10),
                    if (meet.paymentInfo != null)
                      _buildPaymentStatus(meet)
                    else
                      _buildStatusChip(
                        onTap: () {
                          viewModel.gotoPaymentPage(meet);
                        },
                        label: "Not Paid",
                        icon: Icons.payment,
                        color: Colors.red,
                      ),
                    const SizedBox(height: 10),
                    _buildVerificationStatus(meet)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecureMeetupCard(SecureMeetup secureMeetup) {
    final info = secureMeetup.meetupinfo;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 244, 236),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- PET NAME ----------
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 254, 170, 3),
                ),
                child: const Icon(Icons.pets_sharp),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  info?.petName ?? "Unknown Pet",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ---------- TIME ----------
          _iconText(Icons.timelapse_rounded, info?.time ?? "No Time"),

          // ---------- LOCATION ----------
          FutureBuilder<String?>(
            future: CurrentLocation().getAddressFromLatLngString(
              info?.latitude ?? "",
              info?.longitude ?? "",
            ),
            builder: (context, snapshot) {
              return _iconText(
                Icons.location_on,
                snapshot.data ?? "Loading location...",
              );
            },
          ),

          // ---------- ADOPTER ----------
          Row(
            children: [
              Expanded(
                  child: _iconText(Icons.person, info?.adopterEmail ?? "")),
              InkWell(
                onTap: () {
                  // Protection link action
                },
                child: Tooltip(
                  message: "Protection Link",
                  child: Icon(
                    Icons.security,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // ---------- DONOR ----------
          _iconText(Icons.volunteer_activism, info?.donorEmail ?? ""),

          const SizedBox(height: 14),

          // ---------- START MEETUP BUTTON ----------
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                viewModel.gotoEditSecure(secureMeetup);
              },
              icon: const Icon(Icons.handshake, size: 24),
              label: const Text(
                'Start Meetup',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 53, 30, 14),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
                shadowColor: Colors.brown.shade200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3E2723), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF3E2723),
              ),
            ),
          ),
        ],
      ),
    );
  }

// ----------------- Widgets for Status -----------------
  Widget _buildStatusChip({
    Function()? onTap,
    required String label,
    required IconData icon,
    required Color color,
    String? description,
    IconData? descriptionIcon,
    Color? descriptionIconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          selected: true,
          onSelected: (_) => onTap?.call(), // ✅ Actually call the function
          selectedColor: color,
          backgroundColor: color.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                descriptionIcon ?? Icons.info_outline,
                color: descriptionIconColor ?? Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: descriptionIconColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildApplicationStatus(Meetup meetup) {
    final status =
        (meetup!.application?.verificationStatus ?? "").toLowerCase();

    if (status == "rejected") {
      return _buildStatusChip(
        onTap: () {
          viewModel.gotoApplication(meetup);
        },
        label: "Rejected",
        description: "You Application is Rejected Pay to Continue",
        descriptionIcon: Icons.warning,
        descriptionIconColor: Colors.red,
        icon: Icons.warning,
        color: Colors.red,
      );
    } else if (status == "pending") {
      return _buildStatusChip(
        onTap: () {
          viewModel.gotoApplication(meetup);
        },
        label: "Pending",
        icon: Icons.hourglass_empty,
        color: Colors.grey,
      );
    } else if (status == "approved") {
      return _buildStatusChip(
        onTap: () {
          viewModel.gotoApplication(meetup);
        },
        label: "Approved",
        icon: Icons.note_alt_sharp,
        color: Colors.amber,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildVerificationStatus(Meetup meet) {
    UserVerification? userVerification = meet.userVerification;
    if (userVerification != null) {
      return _buildStatusChip(
        onTap: () {
          viewModel.gotoVerifyPage(meet);
        },
        label: "Verified",
        icon: Icons.security,
        color: Colors.green,
      );
    }
    return _buildStatusChip(
      onTap: () {
        if (meet.paymentInfo != null ||
            (meet.application != null &&
                meet.application?.verificationStatus.toString().toLowerCase() ==
                    "approved")) {
          viewModel.gotoVerifyPage(meet);
        } else {
          dialogService.showBeautifulToast("Please Pay Payment To Verify");
        }
      },
      label: "Not Verified",
      icon: Icons.security_update_warning_sharp,
      color: Colors.red,
    );
  }

  Widget _buildPaymentStatus(Meetup meetup) {
    if (meetup.paymentInfo?.paymentId != null &&
        meetup.paymentInfo!.paymentId!.isNotEmpty) {
      return _buildStatusChip(
        label: "Paid",
        icon: Icons.payment_rounded,
        color: Colors.green,
      );
    }
    return _buildStatusChip(
      onTap: () {
        viewModel.gotoPaymentPage(meetup);
      },
      label: "Not Paid",
      icon: Icons.payment,
      color: Colors.red,
    );
  }

  Widget _buildAdminVerification(Meetup meetup) {
    if (meetup.verificationmeetup?.adopterVerificationStatus != null) {
      switch (meetup.verificationmeetup?.adopterVerificationStatus
          .toString()
          .toLowerCase()) {
        case "pending":
          return _buildStatusChip(
            label:
                "Admin ${meetup.verificationmeetup?.adopterVerificationStatus.toString()}",
            description: "Secure Meetup Will Start After Approved",
            icon: Icons.admin_panel_settings_outlined,
            color: Colors.grey,
          );
        case "rejected":
          return _buildStatusChip(
            label:
                "Admin ${meetup.verificationmeetup?.adopterVerificationStatus.toString()}",
            description: "If it is true than Secure Meetup Will start",
            icon: Icons.add_moderator_outlined,
            color: Colors.red,
          );
        case "approved":
          return _buildStatusChip(
            label:
                "Admin ${meetup.verificationmeetup?.adopterVerificationStatus.toString()}",
            description: "If it is true than Secure Meetup Will start",
            icon: Icons.admin_panel_settings_rounded,
            color: Colors.green,
          );
      }
    }
    return SizedBox();
  }

  Widget _buildPetCard(PetResponse pet) {
    final Color statusColor = viewModel.getColor(pet.isApproved ?? "");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rounded Image
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: pet.image != null && pet.image!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: pet.image!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(
                      width: 80,
                      height: 80,
                      child: Center(
                          child: FadingCircularDots(
                        count: 10,
                        radius: 20,
                        dotRadius: 4,
                        duration: Duration(milliseconds: 1200),
                      )),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/nopet.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/images/nopet.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 16),

          // Pet Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Link
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pet.name ?? "Unnamed",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await viewModel.gotopetDetail(pet);
                      },
                      child: const Icon(Icons.link, color: Colors.blueAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Approval + Live Status Badges
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pet.isApproved ?? "Pending",
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: (pet.isLive ?? false)
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (pet.isLive ?? false) ? "Live" : "Inactive",
                        style: TextStyle(
                          color:
                              (pet.isLive ?? false) ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _infoLine("Animal", pet.animal),
                _infoLine("Breed", pet.breed),
                _infoLine("Age", pet.age?.toString()),
                _infoLine("Gender", pet.gender),
                _infoLine("Location", pet.location),
                if (pet.description != null)
                  _infoLine("About", pet.description),
                if (pet.rejectionReason != null &&
                    pet.rejectionReason!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Rejected: ${pet.rejectionReason}",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoLine(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
            TextSpan(
              text: value ?? "N/A",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editableField(
      String label, TextEditingController controller, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DefaultTextInput(
        icon: icon,
        controller: controller,
        hintText: label,
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required List<Widget> children,
    IconData? icon, // optional icon parameter
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: accentColor.withOpacity(0.1),
          highlightColor: accentColor.withOpacity(0.05),
          unselectedWidgetColor: accentColor,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          iconColor: accentColor,
          collapsedIconColor: accentColor.withOpacity(0.7),
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: accentColor),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  fontSize: 15,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, {Color? color}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label,
          style: const TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600)),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color ?? primaryColor,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => viewModel.logout(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 57, 26, 21),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.logout,
              color: Colors.white,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
