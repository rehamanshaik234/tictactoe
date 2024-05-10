 import 'package:flutter/cupertino.dart';

class GlobalProvider extends ChangeNotifier{
  bool _isLightMode=false;
  bool get isLightMode  => _isLightMode;

  bool _isBoardConnected=false;
  bool get isBoardConnected  => _isBoardConnected;


  void setAppTheme(bool isLight){
    _isLightMode=isLight;
    notifyListeners();
  }


  void setBoardConnectivity(bool isConnected){
    _isBoardConnected=isConnected;
    notifyListeners();
  }
}