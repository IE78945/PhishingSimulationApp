import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMenuController extends ChangeNotifier{
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _globalKey;

  void controlMenu(){
    if(!_globalKey.currentState!.isDrawerOpen){
      _globalKey.currentState?.openDrawer();
    }
  }

  int _selectedMenuItem = 0;

  int get selectedMenuItem => _selectedMenuItem;

  void selectMenuItem(int item) {
    _selectedMenuItem = item;
    notifyListeners(); // Notify listeners that the state has changed
  }

}
