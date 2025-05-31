import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:petadoption/viewModel/home_view_model.dart';
import 'package:petadoption/views/profile_page.dart';
import 'package:petadoption/views/home_page.dart';

import 'package:provider/provider.dart';

import '../custom_widgets/custom_button.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    HomeViewModel viewModel = context.watch<HomeViewModel>();
    PageController pageController =
        PageController(initialPage: viewModel.tabIndex);
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.favorite, color: Colors.white),
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.message, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        inactiveIcons: const [
          Column(
            children: [
              Icon(Icons.favorite, color: Colors.white),
              Text(
                "Favourite",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.search, color: Colors.white),
              Text(
                "Search",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.home, color: Colors.white),
              Text(
                "Home",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.message_rounded, color: Colors.white),
              Text(
                "Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.person, color: Colors.white),
              Text(
                "Account",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
        color: Color.fromARGB(255, 213, 101, 25),
        height: 50,
        circleWidth: 50,
        activeIndex: viewModel.tabIndex,
        onTap: (index) {
          viewModel.tabIndex = index;
          pageController.jumpToPage(viewModel.tabIndex);
        },
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        shadowColor: Color(0xFF3E2723),
        elevation: 10,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          viewModel.tabIndex = v;
        },
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white),
          Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white),
          HomePage(),
          Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white),
          ProfilePage(),
        ],
      ),
    );
  }
}
