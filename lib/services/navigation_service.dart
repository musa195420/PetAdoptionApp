// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:petadoption/views/admin_views/admin.dart';
import 'package:petadoption/views/admin_views/adopter_admin.dart';
import 'package:petadoption/views/admin_views/donor_admin.dart';
import 'package:petadoption/views/admin_views/pet_admin.dart';
import 'package:petadoption/views/admin_views/user_admin.dart';
import 'package:petadoption/views/home.dart';
import 'package:petadoption/views/login.dart';
import 'package:petadoption/views/modals/admin_modals/adopter_edit_modal.dart';
import 'package:petadoption/views/modals/animalBreed_modal.dart';
import 'package:petadoption/views/modals/animalType_modal.dart';
import 'package:petadoption/views/modals/admin_modals/animal_config_modal.dart';
import 'package:petadoption/views/modals/donor_edit_modal.dart';
import 'package:petadoption/views/modals/user_edit_modal.dart';
import 'package:petadoption/views/modals/userlink_modal.dart';
import 'package:petadoption/views/not_supported.dart';
import 'package:petadoption/views/pet_page.dart';
import 'package:petadoption/views/signup.dart';
import 'package:petadoption/views/startup.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../helpers/locator.dart';
import '../views/modals/pet_edit_modal.dart';
import 'global_service.dart';

class Routes {
  Routes._();

  static const String startup = "/";
  static const String home = "home";
  static const String login = "login";
  static const String dashboard = "dashboard";
  static const String message = "message";
  static const String notSupported = "notSupported";
  static const String signup = "signup";
  static const String admin = "admin";
  static const String petpage = "petpage";
  static const String animalType_modal = "animalType_modal";
  static const String animalBreed_modal = "animalBreed_modal";
  static const String user_edit_modal = "user_edit_modal";
    static const String user_link_modal = "user_link_modal";
    static const String donor_edit_modal = "donor_edit_modal";
    static const String adopter_edit_modal = "adopter_edit_modal";
    static const String pet_edit_modal = "pet_edit_modal";
   static const String userAdmin = "userAdmin";
    static const String adopterAdmin = "adopterAdmin";
     static const String donorAdmin = "donorAdmin";
    static const String petAdmin = "petAdmin";
     static const String animal_config_modal = "animal_config_modal";
}

class NavigationService {
  // ************************** **************************

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "navigator");
  GlobalService get _globalService => locator<GlobalService>();

  // ************************** **************************

  Future popWithResult({required dynamic result}) async {
    if (navigatorKey.currentState?.canPop() == true) {
      _globalService.log('Go Back with Result');
      return navigatorKey.currentState?.pop(result);
    } else {
      _globalService.log('No page to pop with result');
      // Handle the case when there's no page to pop to
      // e.g., show a message or disable the button
      debugPrint("No page to pop to");
    }
  }

  Future popDialog({required dynamic result}) async {
    if (navigatorKey.currentState?.canPop() == true) {
      _globalService.log('Close Dialog');
      return navigatorKey.currentState?.pop(result);
    } else {
      _globalService.log('No page to pop with dialog');
      // Handle the case when there's no page to pop to
      // e.g., show a message or disable the button
      debugPrint("No page to pop to");
    }
  }

  Future pop() async {
    if (navigatorKey.currentState?.canPop() == true) {
      _globalService.log('Go Back');
      return navigatorKey.currentState?.pop();
    } else {
      _globalService.log('No page to pop to');
      // Handle the case when there's no page to pop to
      // e.g., show a message or disable the button
      debugPrint("No page to pop to");
    }
  }

  Future pushModalBottom(String path, {required dynamic data}) async {
    _globalService.log('Open {$path}\' Modal');
    openModalBottomSheet(path, data);
  }

  Future pushNamed(String path,
      {required dynamic data, required TransitionType args}) async {
    _globalService.log('Go to {$path}\' Page');
    return await navigatorKey.currentState?.pushNamed(
      path,
      arguments: [args, data],
    );
  }

  Future pushReplacementNamed(String path,
      {required TransitionType args}) async {
    _globalService.log('Go to {$path}\' Page');
    return await navigatorKey.currentState?.pushReplacementNamed(
      path,
      arguments: [args],
    );
  }

  // ignore: prefer_function_declarations_over_variables
  final removeAllOldRoutes = (Route<dynamic> route) => false;

  Future navigateToReset(String path, {required TransitionType args}) async {
    _globalService.log('Go to {$path}\' Page');
    return await navigatorKey.currentState?.pushNamedAndRemoveUntil(
      path,
      removeAllOldRoutes,
      arguments: [args],
    );
  }

  void openModalBottomSheet(String path, dynamic data) {
    switch (path) {
      case Routes.animalType_modal:
        {
          showBarModalBottomSheet(
            expand: true,
            context: navigatorKey.currentContext!,
            backgroundColor: Colors.transparent,
            builder: (context) => AnimaltypeModal(
                //  invoice: data,
                ),
          );
        }
        break;
         case Routes.adopter_edit_modal:
        {
          showBarModalBottomSheet(
            expand: true,
            context: navigatorKey.currentContext!,
            backgroundColor: Colors.transparent,
            builder: (context) => AdopterEditModal(
                user: data.user,
                ),
          );
        }
        break;
         case Routes.user_link_modal:
        {
          showBarModalBottomSheet(
            expand: true,
            context: navigatorKey.currentContext!,
            backgroundColor: Colors.transparent,
            builder: (context) => UserLinkModal(user: data.user,
            userProfile: data.userProfile,pets: data.pets,
                //  invoice: data,
                ),
          );
        }
        break;

      case Routes.animalBreed_modal:
        {
          showBarModalBottomSheet(
            expand: true,
            context: navigatorKey.currentContext!,
            backgroundColor: Colors.transparent,
            builder: (context) => AnimalbreedModal(
              petId: data.petId,
            ),
          );
        }
        break;

          case Routes.user_edit_modal:
        {
          showBarModalBottomSheet(
            expand: true,
            context: navigatorKey.currentContext!,
            backgroundColor: Colors.transparent,
            builder: (context) => UserEditModal(
              user: data.user,
            ),
          );
        }
        break;
        case Routes.donor_edit_modal:
        {
          showBarModalBottomSheet(
            expand: true,
            context: navigatorKey.currentContext!,
            backgroundColor: Colors.transparent,
            builder: (context) => DonorEditModal(
              user: data.user,
            ),
          );
        }
        break;
         case Routes.pet_edit_modal:
        {
          showBarModalBottomSheet(
            expand: true,
            context: navigatorKey.currentContext!,
            backgroundColor: Colors.transparent,
            builder: (context) => PetEditModal(
              pet: data.pet,
            ),
          );
        }
        break;

         case Routes.animal_config_modal:
        {
          showBarModalBottomSheet(
            expand: true,
            context: navigatorKey.currentContext!,
            backgroundColor: Colors.transparent,
            builder: (context) => AnimalConfigModal(
              
            ),
          );
        }
        break;
    }
  }

  Future pushNamedAndRemoveUntil(String path,
      {required TransitionType args}) async {
    _globalService.log('Go to {$path}\' Page');
    return await navigatorKey.currentState?.pushNamedAndRemoveUntil(
      path,
      removeAllOldRoutes,
      arguments: [args],
    );
  }
}

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "An error occurred.",
              textAlign: TextAlign.center,
              // style: Theme.of(context).textTheme.display1.copyWith(
              //       color: const Color.fromARGB(255, 255, 255, 255),
              //     ),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteManager {
  RouteManager._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    TransitionType transition;
    if (settings.arguments != null) {
      var args = settings.arguments as List<dynamic>;
      transition = args[0] as TransitionType;
      if (args.length > 1) {
      }
    } else {
      transition = TransitionType.fade;
    }

    switch (settings.name) {
      case Routes.notSupported:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return NotSupportedPage();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }
      case Routes.signup:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return SignupPage();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }
 case Routes.petAdmin:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return PetAdmin();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }

      case Routes.home:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return HomePage();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }
      case Routes.login:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return LoginPage();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }
      case Routes.startup:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Startup();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }

          case Routes.adopterAdmin:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AdopterAdmin();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }
        case Routes.donorAdmin:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return DonorAdmin();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }

      // case Routes.dashboard:
      //   {
      //     return PageRouteBuilder(
      //       pageBuilder: (BuildContext context, Animation<double> animation,
      //           Animation<double> secondaryAnimation) {
      //         return DetailInvoicePage(data as Invoice);
      //       },
      //       transitionsBuilder: (BuildContext context,
      //           Animation<double> animation,
      //           Animation<double> secondaryAnimation,
      //           Widget child) {
      //         return _transitionsBuilder(transition, animation, child);
      //       },
      //     );
      //   }

      case Routes.admin:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AdminPage();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }
      case Routes.petpage:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return PetPage();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }
         case Routes.userAdmin:
        {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return UserAdmin();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return _transitionsBuilder(transition, animation, child);
            },
          );
        }
      default:
        {
          return _errorPage();
        }
    }
  }

  static Widget _transitionsBuilder(
      TransitionType type, Animation<double> animation, Widget child) {
    switch (type) {
      case TransitionType.slideRight:
        {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          );
        }
      case TransitionType.slideLeft:
        {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }
      case TransitionType.slideTop:
        {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }
      case TransitionType.slideBottom:
        {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }
      case TransitionType.fade:
        {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        }
      case TransitionType.scale:
        {
          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(animation),
            child: child,
          );
        }
      case TransitionType.rotate:
        {
          return RotationTransition(
            turns: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(animation),
            child: child,
          );
        }
      case TransitionType.size:
        {
          return Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          );
        }
      case TransitionType.scaleRotate:
        {
          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: RotationTransition(
              turns: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.linear,
                ),
              ),
              child: child,
            ),
          );
        }
    }
  }

  static Route<dynamic> _errorPage() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Navigation Error',
            ),
          ),
          body: const Center(
            child: Text(
              'Navigation Error',
            ),
          ),
        );
      },
    );
  }
}

enum TransitionType {
  slideRight,
  slideLeft,
  slideTop,
  slideBottom,
  fade,
  scale,
  rotate,
  size,
  scaleRotate,
}
