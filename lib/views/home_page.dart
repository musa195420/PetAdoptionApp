import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    HomeViewModel viewModel = context.watch<HomeViewModel>();

    return StatefulWrapper(
      onInit: () {
        viewModel.getPets();
      },
      onDispose: () {},
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.41,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xfff8c561),
                          Color(0xfffccf6f),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.sizeOf(context).height * 0.37,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                          ),
                          items: viewModel.imagePaths.map((imagePath) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Stack(children: [
                                  ClipRRect(
                                    child: Image.asset(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.37,
                                      imagePath,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: Color.fromARGB(
                                                            255, 254, 170, 3),
                                                      ),
                                                      child: Icon(
                                                          Icons.pets_sharp),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "Adopter",
                                                      style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 146, 61, 5),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Adopt a \npet ❤️",
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 83, 36, 6),
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Find Your New \n Best Friend",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 83, 36, 6),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                                InkWell(
                                                  onTap: () {
                                                    debugPrint(
                                                        "Adopt Now Pressed!");
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 213, 101, 25),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      "Adopt Now !",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      debugPrint(
                                                          "Search Pressed!");
                                                    },
                                                    child: Icon(
                                                      Icons.search,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 146, 61, 5),
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0, MediaQuery.sizeOf(context).height * 0.35, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 5),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          mainAxisSpacing: 12, // Reduced from 18
                          crossAxisSpacing: 12, // Reduced from 18
                          physics: NeverScrollableScrollPhysics(),
                          children: viewModel.petSelection.map((pet) {
                            return Column(
                              mainAxisSize: MainAxisSize.min, // Added this line
                              children: [
                                CircleAvatar(
                                  radius: 22, // Reduced from 25
                                  backgroundColor: Colors.grey.shade100,
                                  child: Image.asset(
                                    viewModel.getSvgs(pet),
                                    width: 28, // Reduced from 30
                                    height: 28, // Reduced from 30
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  pet[0].toUpperCase() + pet.substring(1),
                                  style: TextStyle(
                                      fontSize: 11), // Reduced from 12
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// PET CATEGORIES SECTION

              // Any other widget below
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Find Pets",
                          style: TextStyle(
                              color: Color.fromARGB(255, 61, 28, 6),
                              fontSize: 23,
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "View All",
                              style: TextStyle(
                                color: Color.fromARGB(255, 213, 101, 25),
                              ),
                            ),
                            Icon(Icons.navigate_next,
                                color: Color.fromARGB(255, 213, 101, 25))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
