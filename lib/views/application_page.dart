import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/models/request_models/application_model.dart';
import 'package:petadoption/models/response_models/meetup.dart';
import 'package:petadoption/viewModel/application_view_model.dart';
import 'package:provider/provider.dart';

class ApplicationPage extends StatefulWidget {
  final Meetup meet;

  const ApplicationPage({super.key, required this.meet});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController professionController;
  late TextEditingController reasonController;
  late TextEditingController adopterEmailController;
  late TextEditingController donorEmailController;
  late TextEditingController petNameController;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    professionController = TextEditingController();
    reasonController = TextEditingController();
    adopterEmailController =
        TextEditingController(text: widget.meet.adopterEmail);
    donorEmailController = TextEditingController(text: widget.meet.donorEmail);
    petNameController = TextEditingController(text: widget.meet.petName);

    if (widget.meet.application != null) {
      submitted = true;
      professionController.text = widget.meet.application?.profession ?? "";
      reasonController.text = widget.meet.application?.reason ?? "";
    }
  }

  @override
  void dispose() {
    professionController.dispose();
    reasonController.dispose();
    adopterEmailController.dispose();
    donorEmailController.dispose();
    petNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationViewModel viewModel = context.watch<ApplicationViewModel>();

    bool isRejected =
        widget.meet.application?.verificationStatus?.toLowerCase() ==
            "rejected";

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    _buildHeaderImage(),
                    Container(
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              _buildApplicationForm(viewModel),
                              const SizedBox(height: 20),
                              _buildSubmitButton(
                                  viewModel, "Submit Application"),
                              if (viewModel.isAdmin())
                                _buildAdminEdit(viewModel),
                            ],
                          ),
                          if (isRejected) ...[
                            Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.sizeOf(context).height * 0.15),
                              child: Center(
                                child: Transform.rotate(
                                  angle: -0.20, // slight tilt for stamp effect
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          "REJECTED",
                                          style: TextStyle(
                                            fontSize:
                                                36, // larger for main stamp text
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: 4,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "You have to pay to continue",
                                          style: TextStyle(
                                            fontSize: 16, // smaller for subtext
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 241, 241, 241),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => navigationService.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF5D1F00),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Image.asset(
      'assets/images/application.png',
      height: 150,
      fit: BoxFit.contain,
    );
  }

  Widget _buildApplicationForm(ApplicationViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 8,
        children: [
          const Text(
            "APPLICATION",
            style: TextStyle(
              color: Color.fromARGB(255, 146, 61, 5),
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          DefaultTextInput(
            controller: adopterEmailController,
            hintText: "Adopter Email",
            readOnly: true,
            icon: Icons.email_outlined,
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter Adopter Email' : null,
          ),
          DefaultTextInput(
            controller: donorEmailController,
            hintText: "Donor Email",
            readOnly: true,
            icon: Icons.email_outlined,
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter Donor Email' : null,
          ),
          DefaultTextInput(
            controller: petNameController,
            hintText: "Pet Name",
            readOnly: true,
            icon: Icons.pets,
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter Pet Name' : null,
          ),
          DefaultTextInput(
            controller: professionController,
            hintText: "Enter your Profession",
            readOnly: submitted,
            icon: Icons.work_outline,
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter Profession' : null,
          ),
          DefaultTextInput(
            align: TextAlign.center,
            readOnly: submitted,
            controller: reasonController,
            hintText: "Reason Why You Can't Afford",
            icon: Icons.note_alt_outlined,
            maxLines: 5,
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter Reason' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ApplicationViewModel viewModel, String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: viewModel.isAdmin()
            ? const Color.fromARGB(255, 148, 40, 7)
            : submitted
                ? Colors.grey
                : const Color.fromARGB(255, 148, 40, 7),
      ),
      child: GestureDetector(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onTap: () {
          if (formKey.currentState!.validate()) {
            if (!submitted) {
              viewModel.addApplication(ApplicationModel(
                userId: widget.meet.adopterId,
                meetupId: widget.meet.meetupId,
                profession: professionController.text,
                reason: reasonController.text,
              ));
            }
            if (viewModel.isAdmin()) {
              viewModel.updateApplication(ApplicationModel(
                userId: widget.meet.adopterId,
                meetupId: widget.meet.meetupId,
                profession: professionController.text,
                reason: reasonController.text,
                verificationStatus:
                    widget.meet.application?.verificationStatus ?? "Pending",
                applicationId: widget.meet.application?.applicationId ?? "",
              ));
            }
          }
        },
      ),
    );
  }

  Widget _buildAdminEdit(ApplicationViewModel viewModel) {
    final statuses = ['Pending', 'Rejected', 'Approved'];
    String? selectedStatus =
        widget.meet.application?.verificationStatus ?? 'Pending';

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Section",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 20),

            // ChoiceChip group inside StatefulBuilder
            StatefulBuilder(
              builder: (context, setState) {
                return Wrap(
                  spacing: 40,
                  runSpacing: 20,
                  children: statuses.map((status) {
                    final isSelected = selectedStatus == status;
                    return ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedStatus = status;
                            if (widget.meet.application != null) {
                              widget.meet.application!.verificationStatus =
                                  status;
                            }
                            viewModel.notifyListeners();
                          });
                        }
                      },
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 12), // spacing between chips and button

            // More Info Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  viewModel.userInfo(widget.meet.application?.userId ?? "");
                },
                child: Text(
                  "User Information",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
