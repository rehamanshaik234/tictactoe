import 'package:flutter/material.dart';
import 'package:playspace/views/home/home_screen.dart';


import '../../views/game/Board.dart';
import '../../views/splash/splash_screen.dart';
import 'RouteNames.dart';

class Routes{
  static Route<dynamic>generateRoute(RouteSettings settings){
    switch(settings.name) {
      case RoutesName.homeScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
            settings: settings);
      case RoutesName.splashScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen(),
            settings: settings);

      case RoutesName.singlePlayer:
        return MaterialPageRoute(
            builder: (BuildContext context) => Board(),
            settings: settings);
      default:
        return MaterialPageRoute(builder: (_){
          return const Scaffold(
              body:Center(
                child: Text("No Routes Found"),
              )
          );
        });
    }
  }
}