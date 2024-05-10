import 'package:flutter/material.dart';
class GameViewModel {
  late String gameName;
  late String imagePath;
  late String routeName;
  bool? isIcon;
  IconData? iconData;
  GameViewModel({required this.gameName, required this.imagePath, this.isIcon, this.iconData, required this.routeName});
}