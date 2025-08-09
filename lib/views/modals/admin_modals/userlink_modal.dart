// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/loading_indicators.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import '../../../models/hive_models/user.dart';
import '../../../models/response_models/pet_response.dart';
import '../../../models/response_models/user_profile.dart';

class UserLinkModal extends StatelessWidget {
  final UserProfile? userProfile;
  final List<PetResponse>? pets;
  final User user;

  UserLinkModal({super.key, this.userProfile, required this.user, this.pets});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController petController = TextEditingController();

  final Color headerColor = const Color.fromARGB(255, 146, 61, 5);
  final EdgeInsets boxPadding = const EdgeInsets.all(5);
  final BorderRadius boxRadius = BorderRadius.circular(10);
  final BoxDecoration whiteBoxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(width: 1, color: Colors.brown),
    borderRadius: BorderRadius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {},
      onDispose: petController.dispose,
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/bg.png', fit: BoxFit.cover),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 247, 240),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("User Information", style: _headerTextStyle()),
                      _buildUserInfo(),
                      if (pets?.isNotEmpty ?? false) _buildPetInfo(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _headerTextStyle() => TextStyle(
        color: headerColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  Widget _buildUserInfo() {
    return Container(
      width: double.infinity,
      padding: boxPadding,
      decoration: whiteBoxDecoration,
      child: Column(
        children: [
          _profileImage(user.profileImage),
          const Divider(),
          if (userProfile != null) ...[
            _infoRow("Name", userProfile!.name),
            _infoRow("Location", userProfile!.location),
            _statusRow("Is Active", userProfile!.isActive.toString()),
          ],
          _infoRow("Email", user.email),
          _infoRow("Phone Number", user.phoneNumber),
          _infoRow("Role", user.role),
          _infoRow("Device ID", user.deviceId),
        ],
      ),
    );
  }

  Widget _buildPetInfo() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pets!.length,
      itemBuilder: (context, index) {
        final pet = pets![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pet (${index + 1}) Information", style: _headerTextStyle()),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(8),
              decoration: whiteBoxDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileImage(pet.image,
                      defaultAsset: "assets/images/signup.png"),
                  _infoRow("Name", pet.name),
                  _infoRow("Animal Type", pet.animal),
                  _infoRow("Breed", pet.breed),
                  _infoRow("Age", pet.age?.toString()),
                  _infoRow("Gender", pet.gender),
                  _infoRow("Created At", pet.createdAt?.toString()),
                  _infoRow("Description", pet.description),
                  _statusRow("Approval Status", pet.isApproved),
                  _statusRow("Live Status", pet.isLive.toString()),
                  _infoRow("Rejection Reason", pet.rejectionReason),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _profileImage(String? imageUrl,
      {String defaultAsset = "assets/images/noprofile.png"}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                width: 80,
                height: 80,
                child: Center(child:SizedBox(
                      width: 80,
                      height: 80,
                      child: Center(
                          child: FadingCircularDots(
                        count: 10,
                        radius: 20,
                        dotRadius: 4,
                        duration: Duration(milliseconds: 1200),
                      )),
                    )),
              ),
              errorWidget: (context, url, error) => Image.asset(
                defaultAsset,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            )
          : Image.asset(
              defaultAsset,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600))),
            Expanded(
                child: Text(value ?? "",
                    style: const TextStyle(color: Colors.black))),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _statusRow(String label, String? value) {
    final status = (value ?? "").toLowerCase();
    late Color color;
    late String displayText;

    switch (label) {
      case "Approval Status":
        displayText = {
              "approved": "Approved",
              "pending": "Pending",
              "rejected": "Disapproved"
            }[status] ??
            "Unknown";
        color = {
              "approved": Colors.green,
              "pending": Colors.orange,
              "rejected": Colors.red
            }[status] ??
            Colors.grey;
        break;
      case "Live Status":
      case "Is Active":
        displayText = status == 'true' ? "Live" : "Offline";
        color = status == 'true' ? Colors.green : Colors.red;
        break;
      default:
        displayText = value ?? "Unknown";
        color = Colors.grey;
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600))),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  border: Border.all(color: color),
                  borderRadius: boxRadius,
                ),
                child: Center(
                  child: Text(displayText,
                      style:
                          TextStyle(color: color, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
