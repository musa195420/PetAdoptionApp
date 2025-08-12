import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/response_models/meetup.dart';
import 'package:petadoption/models/response_models/user_verification.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/user_verification_view_model.dart';
import 'package:provider/provider.dart';

class UserVerificationPage extends StatefulWidget {
  final Meetup? meetup;

  const UserVerificationPage({super.key, required this.meetup});

  @override
  State<UserVerificationPage> createState() => _UserVerificationPageState();
}

class _UserVerificationPageState extends State<UserVerificationPage> {
  GlobalService get _globalService => locator<GlobalService>();
  late TextEditingController addressController;

  bool _billImageError = false;
  bool _cnicImageError = false;

  final Gradient appBarGradient = const LinearGradient(
    colors: [Color(0xFF8B4513), Color(0xFF5D1F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    addressController = TextEditingController(
        text: widget.meetup?.userVerification?.address ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserVerificationViewModel>();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAddressField(viewModel),
                    const SizedBox(height: 20),
                    _buildVerificationImage(
                      title: "Proof of Residence",
                      localPath: viewModel.billImage,
                      networkUrl:
                          widget.meetup?.userVerification?.proofOfResidence,
                      placeholderText:
                          "Please provide any bill (electricity, water, gas) so we can verify your proof of residence",
                      onPickImage: () async {
                        final picked = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (picked != null) {
                          setState(() => _billImageError = false);
                          viewModel.billImage = picked.path;
                          viewModel.notifyListeners();
                        }
                      },
                      onRemove: () {
                        viewModel.resetBillImagePath();
                      },
                      isError: _billImageError,
                    ),
                    const SizedBox(height: 20),
                    _buildVerificationImage(
                      title: "CNIC",
                      localPath: viewModel.cnicpath,
                      networkUrl: widget.meetup?.userVerification?.cnicPic,
                      placeholderText:
                          "Please upload CNIC image. You can hide other parts except CNIC number and your image",
                      onPickImage: () async {
                        final picked = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (picked != null) {
                          setState(() => _cnicImageError = false);
                          viewModel.cnicpath = picked.path;
                          viewModel.notifyListeners();
                        }
                      },
                      onRemove: () {
                        viewModel.resetCnicPath();
                      },
                      isError: _cnicImageError,
                    ),
                    const SizedBox(height: 30),
                    _buildButton(viewModel)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gradient Header
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
                      'User Verification',
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
        Image.asset(
          'assets/images/user_verif.png',
          height: 120,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _buildAddressField(UserVerificationViewModel viewModel) {
    return DefaultTextInput(
      icon: Icons.location_history,
      maxLines: 3,
      hintText:
          "Enter You Address \n Note: Your Address Should Be Same \n As Proof Pic Address ",
      controller: addressController,
    );
  }

  Widget _buildVerificationImage({
    required String title,
    required String? localPath,
    required String? networkUrl,
    required String placeholderText,
    required VoidCallback onPickImage,
    required VoidCallback onRemove,
    required bool isError,
  }) {
    Widget imageWidget;

    if (localPath != null) {
      imageWidget = Image.file(File(localPath), fit: BoxFit.cover);
    } else if (networkUrl != null && networkUrl.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: networkUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) => const Icon(Icons.error),
      );
    } else {
      imageWidget = Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            placeholderText,
            style: TextStyle(
              color: isError ? Colors.red : Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isError ? Colors.red : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: isError ? Colors.red : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageWidget,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ChoiceChip(
              label: const Text(
                "Upload",
                style: TextStyle(color: Colors.white),
              ),
              avatar: const Icon(Icons.upload, color: Colors.white, size: 18),
              selected: false,
              onSelected: (_) => onPickImage(),
              backgroundColor: const Color(0xFF5D1F00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 8),
            if (localPath != null)
              ChoiceChip(
                label: const Text(
                  "Remove",
                  style: TextStyle(color: Colors.white),
                ),
                avatar: const Icon(Icons.delete, color: Colors.white, size: 18),
                selected: false,
                onSelected: (_) => onRemove(),
                backgroundColor: Colors.red.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
          ],
        ),
      ],
    );
  }

  _buildButton(UserVerificationViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _billImageError = viewModel.billImage == null &&
                  (widget.meetup?.userVerification?.proofOfResidence?.isEmpty ??
                      true);
              _cnicImageError = viewModel.cnicpath == null &&
                  (widget.meetup?.userVerification?.cnicPic?.isEmpty ?? true);
            });

            if (!_billImageError && !_cnicImageError) {
              viewModel.addUserVerification(
                  widget.meetup,
                  UserVerification(
                    userId: _globalService.getuser()?.userId,
                    address: addressController.text,
                  ));
            } else {
              dialogService.showBeautifulToast("Please Add Pic Urls");
            }
          },
          icon: const Icon(Icons.pets, size: 24),
          label: const Text(
            'Apply For Verify',
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
