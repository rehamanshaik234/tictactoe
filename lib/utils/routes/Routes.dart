import 'package:flutter/material.dart';
import 'package:playspace/views/game/play_with_friend/play_with_friend.dart';
import 'package:playspace/views/home/home_screen.dart';


import '../../views/game/single_player/single_player.dart';
import 'RouteNames.dart';

class Routes{
  static Route<dynamic>generateRoute(RouteSettings settings){
    switch(settings.name) {
      case RoutesName.homeScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
            settings: settings);

      case RoutesName.singlePlayer:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SinglePLayer(),
            settings: settings);

      case RoutesName.playWithFriend:
        return MaterialPageRoute(
            builder: (BuildContext context) => const PlayWithFriend(),
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