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
}

