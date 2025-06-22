import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:petadoption/viewModel/home_view_model.dart';
import 'package:petadoption/views/message_info.dart';
import 'package:petadoption/views/profile_page.dart';
import 'package:petadoption/views/home_page.dart';
import 'package:provider/provider.dart';
import 'favourite_page.dart';
import 'search_page.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    HomeViewModel viewModel = context.watch<HomeViewModel>();
    PageController pageController =
        PageController(initialPage: viewModel.tabIndex);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 99, 34, 10),
      extendBody: true,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 0), // Pushes above nav bar
        child: CircleNavBar(
          activeIcons: const [
            Icon(Icons.favorite, color: Colors.white),
            Icon(Icons.search, color: Colors.white),
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.message, color: Colors.white),
            Icon(Icons.person, color: Colors.white),
          ],
          inactiveIcons: const [
            Column(children: [Icon(Icons.favorite, color: Colors.white)]),
            Column(children: [Icon(Icons.search, color: Colors.white)]),
            Column(children: [Icon(Icons.home, color: Colors.white)]),
            Column(
                children: [Icon(Icons.message_rounded, color: Colors.white)]),
            Column(children: [Icon(Icons.person, color: Colors.white)]),
          ],
          color: const Color.fromARGB(255, 99, 34, 10),
          height: 50,
          circleWidth: 50,
          activeIndex: viewModel.tabIndex,
          onTap: (index) {
            viewModel.tabIndex = index;
            pageController.jumpToPage(viewModel.tabIndex);
          },
          padding: EdgeInsets.zero,
          cornerRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(0),
          ),
          shadowColor: const Color(0xFF3E2723),
          elevation: 10,
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          viewModel.tabIndex = v;
        },
        children: [
          FavouritePage(),
          SearchPage(),
          HomePage(),
          MessageInfo(),
          ProfilePage(),
        ],
      ),
    );
  }
}
