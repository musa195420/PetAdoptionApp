// search_page.dart
// Futuristic pet cards – overflow-safe

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/stateful_wrapper.dart';
import '../models/response_models/breed_type.dart';
import '../viewModel/search_view_model.dart';
import '../models/response_models/animal_Type.dart';
import '../models/response_models/pet_response.dart';

const _kPrimary = Color(0xFF222831);
const _kSecondary = Color.fromARGB(255, 69, 19, 2);
const _kStroke = Color(0xFFE0E0E0);
const _kBg = Color(0xFFFFFFFF);

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();

    return StatefulWrapper(
      onInit: () {
        vm.getPets();
        vm.getAnimalType();
      },
      onDispose: () {},
      child: Container(
        padding: EdgeInsets.only(bottom: 50),
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/images/bg.png'))),
        child: Scaffold(
          body: vm.isBusy
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color.fromARGB(255, 254, 170, 3),
                                    ),
                                    child: Icon(Icons.pets_sharp),
                                  ),
                                  const Text(' Find Your',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: _kPrimary)),
                                ],
                              ),
                              const Text('Lovely pet in anywhere',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54)),
                            ],
                          ),
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 35,
                            child: ClipOval(
                              child: Image.network(
                                vm.getuser().profileImage ?? "",
                                fit: BoxFit.contain,
                                width: 45,
                                height: 45,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/noprofile.png',
                                    fit: BoxFit.cover,
                                    width: 36,
                                    height: 36,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SearchBar(),
                      const SizedBox(height: 12),
                      _CategoryHeader(vm: vm),
                      const SizedBox(height: 12),
                      if (vm.animals != null) _CategoryGrid(vm: vm),
                      const SizedBox(height: 12),
                      _BreedsHeader(vm: vm),
                      const SizedBox(height: 12),
                      if (vm.breeds != null) _BreedsGrid(vm: vm),
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Newest Pet'),
                      const SizedBox(height: 12),
                      _PetGrid(vm: vm),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// ――― widgets ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      );
}

// ── Category ────────────────────────────────────────────────────────────────

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.vm});
  final SearchViewModel vm;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(
            child: Text('Pet Category',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _kPrimary)),
          ),
        ],
      );
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.vm});
  final SearchViewModel vm;

  @override
  Widget build(BuildContext context) {
    final items =
        vm.showAllCategories ? vm.animals! : vm.animals!.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3.5,
          ),
          itemBuilder: (ctx, i) {
            final AnimalType animal = items[i];
            final bool selected = animal.animalId == vm.animalId;

            return InkWell(
              onTap: () => vm.selectAnimal(animal),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      selected ? _kSecondary.withOpacity(0.08) : Colors.white,
                  border: Border.all(
                    color: selected ? _kSecondary : _kStroke,
                    width: 1.4,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    if (selected)
                      BoxShadow(
                        color: _kSecondary.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      vm.getSvgs(animal.name),
                      width: 28,
                      height: 28,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.pets, size: 24),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        animal.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: selected ? _kSecondary : _kPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: selected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.check_circle,
                          size: 18, color: _kSecondary),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // View More / View Less Button
        if (vm.animals!.length > 4)
          Center(
            child: TextButton.icon(
              onPressed: () => vm.toggleShowAllCategories(),
              icon: Icon(
                vm.showAllCategories ? Icons.expand_less : Icons.expand_more,
                size: 16,
              ),
              label: Text(vm.showAllCategories ? 'View Less' : 'View More'),
              style: TextButton.styleFrom(
                foregroundColor: _kSecondary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}

//<=================================================Breeds info=============================================>

class _BreedsHeader extends StatelessWidget {
  const _BreedsHeader({required this.vm});
  final SearchViewModel vm;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(
            child: Text('Animal Breeds',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _kPrimary)),
          ),
        ],
      );
}

class _BreedsGrid extends StatelessWidget {
  const _BreedsGrid({required this.vm});
  final SearchViewModel vm;

  @override
  Widget build(BuildContext context) {
    final items = vm.breeds!;
    final displayItems = vm.showMore ? items : items.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.8,
          ),
          itemBuilder: (ctx, i) {
            final breed = displayItems[i];
            final bool selected = breed.breedId == vm.breedId;

            return InkWell(
              onTap: () => vm.selectBreed(breed),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? _kSecondary.withOpacity(0.1) : Colors.white,
                  border: Border.all(
                    color: selected ? _kSecondary : _kStroke,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (selected)
                      BoxShadow(
                        color: _kSecondary.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        breed.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: selected ? _kSecondary : _kPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: selected ? 1.0 : 0.0,
                      child: Icon(
                        Icons.check_circle,
                        size: 18,
                        color: _kSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // View More / View Less Button
        if (items.length > 4)
          Center(
            child: TextButton.icon(
              onPressed: () => vm.setShowMore(!vm.showMore),
              icon: Icon(
                vm.showMore ? Icons.expand_less : Icons.expand_more,
                size: 16,
              ),
              label: Text(vm.showMore ? 'View Less' : 'View More'),
              style: TextButton.styleFrom(
                foregroundColor: _kSecondary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
// ── Pet Grid ────────────────────────────────────────────────────────────────

class _PetGrid extends StatelessWidget {
  const _PetGrid({required this.vm});
  final SearchViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm.pets == null || vm.pets!.isEmpty) {
      return Center(
        child: Text("No Pets Found Under These Filters"),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.pets!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68, // 👈 a bit taller than before
      ),
      itemBuilder: (ctx, i) => _PetCard(
        pet: vm.pets![i],
        vm: vm,
      ),
    );
  }
}

// ── Pet Card (no-overflow) ──────────────────────────────────────────────────

class _PetCard extends StatelessWidget {
  const _PetCard({required this.pet, required this.vm});
  final PetResponse pet;
  final SearchViewModel vm;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        vm.gotoDetail(pet);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.9), Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section expands to fill remaining height
              Expanded(
                child: pet.image != null
                    ? Image.network(pet.image!, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey.shade200,
                        child:
                            const Icon(Icons.pets, size: 48, color: _kPrimary),
                      ),
              ),

              // Info section – fixed padding, text kept short
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.9), Colors.white],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pet.name ?? 'Unnamed',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.category,
                            size: 13, color: Colors.black45),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            pet.breed ?? 'Unknown Breed',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 13, color: Colors.black38),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            pet.location ?? 'Unknown Location',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black45),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

// ── Section title ───────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: _kPrimary),
      );
}
