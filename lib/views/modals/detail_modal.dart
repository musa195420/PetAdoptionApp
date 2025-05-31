import 'package:flutter/material.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/appwidget.dart';
import '../../custom_widgets/stateful_wrapper.dart';
import '../../viewModel/detail_view_model.dart';

class DetailModal extends StatelessWidget {
  final PetResponse pet;
  DetailModal({super.key, required this.pet});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DetailViewModel viewModel = context.watch<DetailViewModel>();

    return StatefulWrapper(
      onInit: () async => await viewModel.getData(pet),
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        extendBody: true,
        body: viewModel.user == null
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final screenHeight = constraints.maxHeight;
                  final screenWidth = constraints.maxWidth;

                  return SingleChildScrollView(
                    child: SizedBox(
                      height: screenHeight,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(screenWidth * 0.04),
                              topRight: Radius.circular(screenWidth * 0.04),
                            ),
                            child: Image.network(pet.image ?? "",
                                height: screenHeight * 0.35,
                                width: screenWidth,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    AppWidget.imageLoad()),
                          ),
                          Positioned(
                            top: screenHeight * 0.02,
                            left: screenWidth * 0.04,
                            right: screenWidth * 0.04,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.black,
                                      size: screenWidth * 0.07),
                                ),
                                Icon(Icons.favorite,
                                    color: Colors.white,
                                    size: screenWidth * 0.07),
                              ],
                            ),
                          ),
                          Positioned(
                            top: screenHeight * 0.32,
                            bottom: 0, // adjust to overlap the image a little
                            left: 0,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF5EB),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                ),
                              ),
                              padding: EdgeInsets.all(screenWidth * 0.05),
                              child: SingleChildScrollView(
                                child:
                                    info(screenHeight, screenWidth, viewModel),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget info(
      double screenHeight, double screenWidth, DetailViewModel viewModel) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pet.name ?? "Unknown",
            style: TextStyle(
              fontSize: screenHeight * 0.035,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF522501),
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Row(
            children: [
              Icon(Icons.location_on,
                  color: const Color(0xFFF7992C), size: screenWidth * 0.045),
              SizedBox(width: screenWidth * 0.01),
              Text(
                pet.location ?? "Not Specified",
                style: TextStyle(fontSize: screenHeight * 0.02),
              ),
              SizedBox(width: screenWidth * 0.015),
              Text(
                "(NearBy)",
                style: TextStyle(fontSize: screenHeight * 0.02),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),

          // Info Tags Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoTag(
                  screenWidth,
                  screenHeight,
                  "Age",
                  pet.age?.toString() ?? "N/A",
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: _buildInfoTag(
                  screenWidth,
                  screenHeight,
                  "Type",
                  pet.animal ?? "N/A",
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: _buildInfoTag(
                  screenWidth,
                  screenHeight,
                  "Gender",
                  pet.gender ?? "N/A",
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: _buildInfoTag(
                  screenWidth,
                  screenHeight,
                  "Breed",
                  pet.breed ?? "N/A",
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.03),

          // Owner Info Section
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.08,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: Image.network(
                          viewModel.user!.profileImage ?? "",
                          fit: BoxFit.cover,
                          width: screenWidth * 0.16,
                          height: screenWidth * 0.16,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset("assets/images/noprofile.png");
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.user!.email ?? "",
                          style: TextStyle(
                            color: const Color(0xFF522501),
                            fontSize: screenHeight * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Owner",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: screenHeight * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  pet.description ?? "A Lovely Pet",
                  style: TextStyle(
                    height: 1.4,
                    fontSize: screenHeight * 0.02,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.message_outlined,
                        color: const Color(0xFFF7992C),
                        size: screenWidth * 0.09),
                    ElevatedButton(
                      onPressed: () {
                        // Future enhancement: Trigger adoption process
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7992C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.03,
                          horizontal: screenWidth * 0.09,
                        ),
                      ),
                      child: Text(
                        "Adopt Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.02,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoTag(
    double screenWidth,
    double screenHeight,
    String title,
    String value,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.w600,
              color: Color(0xFF522501),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: screenHeight * 0.017,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
