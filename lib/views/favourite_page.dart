import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/favourite_viewmodel.dart';
import '../custom_widgets/stateful_wrapper.dart';

class FavouritePage extends StatelessWidget {
  FavouritePage({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();

  final Color lightBrown = const Color(0xFFD7CCC8);
  final Color darkBrown = const Color(0xFF3E2723);
  final Color cardBackground = Colors.white;
  final Gradient appBarGradient = const LinearGradient(
    colors: [Color(0xFF3D1B00), Color(0xFFFF7700)],
  );

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FavouriteViewmodel>();

    return StatefulWrapper(
      onInit: () => viewModel.getFavourites(),
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        //backgroundColor: lightBrown.withOpacity(0.2),
        body: Column(
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
              ),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    Text(
                      '  Favourites',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: viewModel.filterFavourites,
                decoration: InputDecoration(
                  hintText: "Search by Name",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            viewModel.resetFilter();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            // 🐾 Pet List
            Expanded(
              child: viewModel.filteredFavourite == null
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.filteredFavourite!.isEmpty
                      ? const Center(child: Text("No favourites found."))
                      : ListView.builder(
                          itemCount: viewModel.filteredFavourite!.length,
                          itemBuilder: (context, index) {
                            final fav = viewModel.filteredFavourite![index];
                            final pet = fav.pet!;

                            return Dismissible(
                              key: Key(pet.petId!),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                viewModel.deleteFavourites(pet.petId!);
                                viewModel.favourites?.removeAt(index);
                                viewModel.resetFilter();
                              },
                              child: GestureDetector(
                                onTap: () async {
                                  await viewModel.gotoDetail(pet);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 6,
                                  color: cardBackground,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        ),
                                        child: Image.network(
                                          pet.image ?? '',
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Image.asset(
                                            'assets/images/icon.png',
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pet.name ?? "Unknown",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              _buildRichLine(
                                                  label: "Breed: ",
                                                  value:
                                                      pet.breed ?? "Unknown"),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Age: ',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: '${pet.age} years',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Gender: ',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: pet.gender ??
                                                          'Unknown',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Type: ',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: pet.animal ??
                                                          'Unknown',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          viewModel.isFavourite(pet.petId!)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                              viewModel.isFavourite(pet.petId!)
                                                  ? Colors.red
                                                  : Colors.grey,
                                        ),
                                        onPressed: () {
                                          if (viewModel
                                              .isFavourite(pet.petId!)) {
                                            viewModel
                                                .deleteFavourites(pet.petId!);
                                          } else {
                                            viewModel.addFavourites(pet.petId!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📍 Helper to bold the label but not the value
  Widget _buildRichLine({required String label, required String value}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
        ),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
