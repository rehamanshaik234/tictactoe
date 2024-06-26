import 'dart:convert';

import 'package:flutter/material.dart';

import '../../model/team_colors/team_colors.dart';

class Constants{

  ///sharedpreferencekeys
  static String deviceInfoKey='device_info';
  static String homeTeamName='home_team_name';
  static String homeTeamColor='home_team_color';
  static String guestTeamName='guest_team_name';
  static String guestTeamColor='guest_team_color';


  ///android-id
  static String androidId='android-client';

  ///teamColors
  static List<TeamColors> colors=[
    TeamColors(colorName: 'White', color: Colors.white),
    TeamColors(colorName: 'Teal', color: const Color(0xFF00FFFF)),
    TeamColors(colorName: 'Yellow', color: const Color(0xFFFFFF00)),
    TeamColors(colorName: 'Green', color: const Color(0xFF00FF00)),
    TeamColors(colorName: 'Pink', color: const Color(0xFFFF00FF)),
    TeamColors(colorName: 'Blue', color: const Color(0xFF0000FF)),
    TeamColors(colorName: 'Red', color: const Color(0xFFFF0000)),
  ];

  static TeamColors getTeamColorByColor(Color teamColor){
    TeamColors color=colors[0];
    for(int i=0;i<colors.length;i++){
      if(colors[i].color.value==teamColor.value){
        color=colors[i];
        break;
      }
    }
    return color;
  }

  static String colorToString(Color color) {
    return "{\"R\":\"${color.red}\",\"G\":\"${color.green}\",\"B\":\"${color.blue}\"}";
  }

  static String convertMSToMin(int? data){
    int totalSeconds = data! ~/ 1000;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minutesStr = minutes.toString().padLeft(
        2, '0');
    String secondsStr = seconds.toString().padLeft(
        2, '0');
    return '$minutesStr : $secondsStr';
  }

  static String convertSecondsToMin(int data){
    int totalSeconds = data;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minutesStr = minutes.toString().padLeft(
        2, '0');
    String secondsStr = seconds.toString().padLeft(
        2, '0');
    return '$minutesStr:$secondsStr';
  }


  ///Sound Assets
  static String tapSound='game_sounds/tap_sound.mp3';
  static String gameDraw='game_sounds/game_draw.mpeg';
  static String gameWon='game_sounds/game_won.mp3';
  static String gameLost='game_sounds/game_lost.mpeg';
  static String addPoint='game_sounds/add_point_sound.mp3';

}


enum BowDirection{
  firstRow,
  secondRow,
  thirdRow,
  firstColumn,
  secondColumn,
  thirdColumn,
  diagonal,
  antiDiagonal,
  none
}

List<String> dares= [
  "Sing the alphabet backward as fast as you can.",
  "Do the chicken dance in public for 1 minute.",
  "Wear socks on your hands for the next round.",
  "Speak in rhymes for the next three turns.",
  "Post a silly selfie on social media with a funny caption.",
  "Do 10 push-ups in the silliest way possible.",
  "Talk in a high-pitched voice for the next round.",
  "Wear a funny hat for the rest of the game.",
  "Dance like nobody's watching for 2 minutes straight.",
  "Make up a rap about your opponent and perform it.",
  "Talk like a robot for the next three turns.",
  "Wear a fake mustache for the next round.",
  "Do your best impression of a famous celebrity.",
  "Speak in pig Latin for the next round.",
  "Balance a spoon on your nose for 1 minute.",
  "Tell a joke and keep a straight face for 30 seconds.",
  "Do an interpretive dance of your favorite animal.",
  "Wear your clothes backward for the next round.",
  "Talk with your tongue sticking out for the next three turns.",
  "Do an impression of your favorite cartoon character."
];
