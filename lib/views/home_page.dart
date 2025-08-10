import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/loading_indicators.dart';
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
                  _buildUpperSection(viewModel, context),
                  _buildMiddleSection(viewModel, context),
                ],
              ),

              /// PET CATEGORIES SECTION

              // Any other widget below
              _buildPetsListView(viewModel, context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _buildUpperSection(HomeViewModel viewModel, BuildContext context) {
    return Container(
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
                        height: MediaQuery.sizeOf(context).height * 0.37,
                        imagePath,
                        fit: BoxFit.contain,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color:
                                              Color.fromARGB(255, 254, 170, 3),
                                        ),
                                        child: Icon(Icons.pets_sharp),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Adopter",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 146, 61, 5),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Adopt a \npet ❤️",
                                    style: TextStyle(
                                      height: 1.2,
                                      color:
                                          const Color.fromARGB(255, 83, 36, 6),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Find Your New \nBest Friend",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 83, 36, 6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  InkWell(
                                    onTap: () {
                                      debugPrint("Adopt Now Pressed!");
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 146, 61, 5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Adopt Now !",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        debugPrint("Search Pressed!");
                                      },
                                      child: Icon(
                                        Icons.search,
                                        color: const Color.fromARGB(
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
    );
  }

  _buildMiddleSection(HomeViewModel viewModel, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: MediaQuery.sizeOf(context).height * 0.25,
      margin: EdgeInsets.fromLTRB(
          0, MediaQuery.sizeOf(context).height * 0.33, 0, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: GridView.count(
            childAspectRatio: 1.1,
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            physics: NeverScrollableScrollPhysics(),
            children: viewModel.petSelection.map((pet) {
              bool isSelected = pet == viewModel.selectedAnimal;
              return InkWell(
                onTap: () {
                  viewModel.filteredSelection(pet);
                },
                child: SizedBox(
                  height: 80, // Try adjusting this value
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: isSelected
                            ? Color(0xfff8c561)
                            : Colors.grey.shade100,
                        child: Image.asset(
                          viewModel.getSvgs(pet),
                          width: 28,
                          height: 28,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        pet[0].toUpperCase() + pet.substring(1),
                        style: TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  _buildPetsListView(HomeViewModel viewModel, BuildContext context) {
    return Padding(
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
              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View All",
                      style: TextStyle(
                        color: viewModel.boolValue
                            ? Colors.white
                            : Color.fromARGB(255, 61, 28, 6),
                      ),
                    ),
                  ],
                ),
                selected: viewModel.boolValue,
                onSelected: (bool selected) {
                  viewModel.viewAll(selected);
                },
                selectedColor: Color.fromARGB(255, 61, 28, 6),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Color.fromARGB(255, 61, 28, 6)),
                ),
                checkmarkColor: Colors.white, // <-- here
              )
            ],
          ),

          // Place this after SizedBox(height: 20)
          // PetsListView(
          //   viewModel: viewModel,
          // ),
          petsListView(viewModel),
        ],
      ),
    );
  }

  petsListView(HomeViewModel viewModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 80),
          height: MediaQuery.of(context).size.height * 0.33,
          child: viewModel.filteredPets == null
              ? const Center(
                  child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Center(
                      child: FadingCircularDots(
                    count: 10,
                    radius: 20,
                    dotRadius: 4,
                    duration: Duration(milliseconds: 1200),
                  )),
                ))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.filteredPets!.length,
                  itemBuilder: (context, index) {
                    final pet = viewModel.filteredPets![index];
                    final screenWidth = MediaQuery.of(context).size.width;
                    final cardWidth =
                        isSmallScreen ? screenWidth * 0.5 : screenWidth * 0.25;

                    return Container(
                      width: cardWidth,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 3),
                      child: GestureDetector(
                        onTap: () {
                          viewModel.gotoDetail(pet);
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: 'petImage${pet.petId}',
                                child: pet.image != null &&
                                        pet.image!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: pet.image!,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 120,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: const Center(
                                              child: SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Center(
                                                child: FadingCircularDots(
                                              count: 10,
                                              radius: 20,
                                              dotRadius: 4,
                                              duration:
                                                  Duration(milliseconds: 1200),
                                            )),
                                          )),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 120,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child:
                                              const Icon(Icons.pets, size: 50),
                                        ),
                                      )
                                    : Container(
                                        height: 120,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.pets, size: 50),
                                      ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.grey.shade100
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 3,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              pet.name ?? 'No Name',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            pet.gender?.toLowerCase() == 'male'
                                                ? Icons.male
                                                : Icons.female,
                                            size: 20,
                                            color: pet.gender?.toLowerCase() ==
                                                    'male'
                                                ? Colors.blue
                                                : Colors.pink,
                                          )
                                        ],
                                      ),
                                      Text(
                                        pet.breed ?? 'Unknown Breed',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        '${pet.age ?? 0} years old',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 14,
                                              color: Colors.redAccent),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              pet.location ?? 'Unknown',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class PetsListView extends StatelessWidget {
  final HomeViewModel viewModel;

  const PetsListView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final pets = viewModel.filteredPets ?? [];

    const cardWidth = 180.0;
    const spacing = 12.0;
    final totalWidth = (cardWidth + spacing) * (pets.isEmpty ? 1 : pets.length);

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: totalWidth,
              // no fixed minHeight here: let it grow vertically
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: List.generate(pets.length, (index) {
                  final pet = pets[index];

                  return GestureDetector(
                    onTap: () => viewModel.gotoDetail(pet),
                    child: Container(
                      width: cardWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'petImage${pet.petId}',
                            child: pet.image != null && pet.image!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: pet.image!,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.pets, size: 50),
                                    ),
                                  )
                                : Container(
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.pets, size: 50),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        pet.name ?? 'No Name',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      pet.gender?.toLowerCase() == 'male'
                                          ? Icons.male
                                          : Icons.female,
                                      size: 20,
                                      color: pet.gender?.toLowerCase() == 'male'
                                          ? Colors.blue
                                          : Colors.pink,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  pet.breed ?? 'Unknown Breed',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600),
                                ),
                                Text(
                                  '${pet.age ?? 0} years old',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 14, color: Colors.redAccent),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        pet.location ?? 'Unknown',
                                        style: TextStyle(
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
