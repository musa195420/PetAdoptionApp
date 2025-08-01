import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/admin_view_models/secureMeetup_admin_view_model.dart';
import 'package:provider/provider.dart';

final formKey2 = GlobalKey<FormState>();
final formKey = GlobalKey<FormState>();

class MeetupModal extends StatelessWidget {
  final String userId;
  final String adopterId;
  MeetupModal({
    super.key,
    required this.userId,
    required this.adopterId,
  });

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SecureMeetupAdminViewModel viewModel =
        context.watch<SecureMeetupAdminViewModel>();

    return StatefulWrapper(
      onInit: () async {
        await viewModel.intialMeetupSetup(userId, adopterId);
      },
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: viewModel.initailizing
                      ? CircularProgressIndicator(
                          color: Colors.brown,
                        )
                      : Column(
                          spacing: 5,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 247, 240),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    viewModel.isUpdate
                                        ? "Update Meetup"
                                        : "Add Meetup",
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 146, 61, 5),
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  _buildePetForm(viewModel, context),
                                  viewModel.isDonor
                                      ? _buildVerificationEdit(
                                          viewModel, context)
                                      : viewModel.applicationController.text
                                                  .toLowerCase() ==
                                              "applied"
                                          ? buildPaymentVerificationSection(
                                              context, viewModel)
                                          : SizedBox(),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () async {
                                      if (formKey.currentState!.validate()) {
                                        viewModel.isUpdate
                                            ? await viewModel.updateMeetup(
                                                viewModel.meetupId ?? "",
                                                viewModel.petId ?? "",
                                                viewModel.locationNameController
                                                    .text,
                                                viewModel.latitude ?? "",
                                                viewModel.longitude ?? "",
                                                viewModel.isAcceptedByDonor,
                                                viewModel.isAcceptedByAdopter)
                                            : await viewModel.addMeetup(
                                                userId,
                                                adopterId,
                                                viewModel.petId ?? "",
                                                userId,
                                                adopterId,
                                                viewModel.locationNameController
                                                    .text,
                                                viewModel.latitude ?? "",
                                                viewModel.longitude ?? "",
                                                viewModel.isAcceptedByDonor,
                                                viewModel.isAcceptedByAdopter);
                                      }
                                    },
                                    child: _buildButton(viewModel.isUpdate),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildePetForm(
      SecureMeetupAdminViewModel viewModel, BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: viewModel.verificationLock
                  ? const Color.fromARGB(255, 230, 229, 228)
                  : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 3,
                color: viewModel.verificationLock
                    ? const Color.fromARGB(255, 168, 167, 165)
                    : const Color.fromARGB(255, 146, 61, 5),
              ),
            ),
            child: Column(spacing: 10, children: [
              if (viewModel.verificationLock)
                InkWell(
                  onTap: () {
                    _showGatewayDialog(context,
                        "Pay To Edit The Meetup \n And To Follow Secure Meetup ");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        viewModel.verificationLock
                            ? Icons.lock
                            : Icons.lock_open,
                        size: 30,
                        color: viewModel.verificationLock
                            ? Color(0xFF2C5364)
                            : const Color.fromARGB(255, 51, 143, 54),
                      ),
                    ],
                  ),
                ),
              Form(
                key: formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    const SizedBox(height: 15),

                    // existing text inputs …
                    DefaultTextInput(
                      controller: viewModel.petNameController,
                      labelText: 'Pet Name',
                      hintText: 'Pet Name',
                      readOnly: true,
                      enabled: !viewModel.verificationLock,
                      icon: Icons.pets_outlined,
                      onTap: viewModel.selectPet,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter Pet Name Please'
                          : null,
                    ),
                    DefaultTextInput(
                      controller: viewModel.adopterNameController,
                      hintText: 'Adopter Name',
                      labelText: 'Adopter Name',
                      enabled: !viewModel.verificationLock,
                      readOnly: true,
                      icon: Icons.person,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter Adopter Name Please'
                          : null,
                    ),
                    DefaultTextInput(
                      controller: viewModel.locationNameController,
                      readOnly: true,
                      hintText: 'Location Name',
                      labelText: 'Location Name',
                      enabled: !viewModel.verificationLock,
                      onTap: viewModel.selectLocationonMaps,
                      icon: Icons.map,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter Your Location Name Please'
                          : null,
                    ),
                    DefaultTextInput(
                      controller: viewModel.timeController,
                      readOnly: true,
                      hintText: 'Time',
                      labelText: 'Time',
                      enabled: !viewModel.verificationLock,
                      onTap: viewModel.selectDateTime,
                      icon: Icons.access_time,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Enter Meetup Time' : null,
                    ),

                    // ★  new acceptance UI
                  ],
                ),
              ),
              _buildAcceptanceSection(viewModel),
            ])),
      ],
    );
  }

  Widget _booleanCard(
      {required bool isSelected,
      required String label,
      required VoidCallback onTap,
      required bool verficationLock}) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? verficationLock
                    ? const Color.fromARGB(255, 136, 134, 134)
                    : Colors.green.shade600
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 2,
              color: isSelected
                  ? verficationLock
                      ? const Color.fromARGB(255, 136, 134, 134)
                      : Colors.green.shade800
                  : Colors.grey.shade400,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                  color: Colors.green.shade200.withOpacity(.5),
                ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcceptanceSection(SecureMeetupAdminViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        if (vm.isDonor)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel('Accepted by Donor'),
              Row(
                children: [
                  _booleanCard(
                    isSelected: vm.isAcceptedByDonor,
                    label: 'Accepted',
                    onTap: () => vm.setacceptedbyDonor(true),
                    verficationLock: vm.verificationLock,
                  ),
                  _booleanCard(
                    isSelected: !vm.isAcceptedByDonor,
                    label: 'Not Accepted',
                    onTap: () => vm.setacceptedbyDonor(false),
                    verficationLock: vm.verificationLock,
                  ),
                ],
              ),
            ],
          ),
        const SizedBox(height: 18),
        if (vm.isAdopter)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel('Accepted by Adopter'),
              Row(
                children: [
                  _booleanCard(
                    isSelected: vm.isAcceptedByAdopter,
                    label: 'Accepted',
                    onTap: () => vm.setacceptedbyAdopter(true),
                    verficationLock: vm.verificationLock,
                  ),
                  _booleanCard(
                    isSelected: !vm.isAcceptedByAdopter,
                    label: 'Not Accepted',
                    onTap: () => vm.setacceptedbyAdopter(false),
                    verficationLock: vm.verificationLock,
                  ),
                ],
              ),
            ],
          )
      ],
    );
  }

  Widget _buildButton(bool isUpdate) {
    return Container(
      padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromARGB(255, 146, 61, 5),
      ),
      child: Text(
        isUpdate ? "Update Meetup" : "Add Meetup",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  Widget _buildVerificationEdit(
      SecureMeetupAdminViewModel viewModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verification Section",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    SizedBox(
                      width: 200, // set a width appropriate for your layout
                      child: Text(
                        'Set "pending" if not to apply admin verification',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // You can show help/info dialog here
                    _showGatewayDialog(
                        context, "Payment will be paid by Adopter");
                  },
                  child: Icon(
                    Icons.card_membership,
                    size: 28,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Edit Lock Button
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 2,
                  color: viewModel.isEdit ? Colors.green : Colors.grey.shade300,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Edit Mode",
                        style: TextStyle(
                          color: viewModel.isEdit
                              ? Colors.green.shade800
                              : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          viewModel.isEdit ? Icons.lock_open : Icons.lock,
                          color: Colors.green,
                        ),
                        onPressed: () => viewModel.setEdit(),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Payment Type Button
                  InkWell(
                    onTap: () {
                      if (viewModel.isEdit) {
                        viewModel.selectmeetupVerification();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: viewModel
                            .getColor(viewModel.applicationController.text),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          viewModel.applicationController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildAcceptanceSwitch(
                    context,
                    isEdit: viewModel.isEdit,
                    title: "Adopter Verification",
                    value: viewModel.adopterverificationRequest,
                    onChanged: (value) {
                      if (viewModel.isEdit) {
                        viewModel.setadopterverificationRequest(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentVerificationSection(
      BuildContext context, SecureMeetupAdminViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 39, 24, 15),
              Color.fromARGB(255, 157, 113, 37),
              Color.fromARGB(255, 75, 31, 11)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Actions Required",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Complete payment to unlock verification access.",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 24),

            // Icon Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Payment Button
                GestureDetector(
                  onTap: () async {
                    viewModel.gotoPaymentPage();
                  },
                  child: _buildIconButton(
                    icon: Icons.payment,
                    label: 'Pay',
                    color: Colors.greenAccent,
                  ),
                ),

                // Verification Button
                GestureDetector(
                  onTap: () {
                    if (!viewModel.verificationLock) {
                      // Navigate to verification page
                    } else {
                      _showGatewayDialog(context,
                          "Please complete the payment to unlock verification.");
                    }
                  },
                  child: _buildIconButton(
                    icon: viewModel.verificationLock
                        ? Icons.lock
                        : Icons.verified_user,
                    label: 'Verify',
                    color: viewModel.verificationLock
                        ? Colors.grey
                        : Colors.cyanAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptanceSwitch(BuildContext context,
      {required String title,
      required bool value,
      required bool isEdit,
      required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isEdit ? Colors.green.shade900 : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: isEdit ? Colors.green : Colors.grey,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showGatewayDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.green.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.green.shade800),
            const SizedBox(width: 8),
            Text("Payment Info"),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.green.shade900),
        ),
        actions: [
          TextButton(
            child:
                Text("Close", style: TextStyle(color: Colors.green.shade800)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      );
}

Widget _buildIconButton({
  required IconData icon,
  required String label,
  required Color color,
}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, size: 28, color: color),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    ],
  );
}
