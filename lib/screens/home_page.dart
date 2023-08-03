import 'package:flutter/material.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/screens/side_bar_menu.dart';
import 'package:provider/provider.dart';

import '../app_responsive.dart';
import '../controllers/menu_controller.dart';
import 'dashboard.dart';
import 'header_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    int selectedMenuItem = Provider.of<CustomMenuController>(context).selectedMenuItem;


    return Scaffold(
      drawer: SideBar(),
      key: Provider.of<CustomMenuController>(context, listen: false).scaffoldKey,
      backgroundColor: MyDarkBlue,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Side Navigation Menu
            /// Only show in desktop
            if (AppResponsive.isDesktop(context))
              Expanded(
                child: SideBar(),
              ),

            /// Main Body Part
            Expanded(
              flex: 4,
              child: Column(
                  children: [
                  /// Header Part
                  HeaderWidget(),
                  _buildBody(selectedMenuItem),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(int selectedMenuItem) {
    switch (selectedMenuItem) {
      case 0:
        return Container(color: MyDarkBlue,height: 100,width: 100,); // Widget to be shown when 'item1' is selected.
      case 1:
        return SingleChildScrollView(); // Widget to be shown when 'item2' is selected.
    // Add more cases for other menu items if needed...
      default:
        return SingleChildScrollView(); // Fallback widget or default content.
    }
  }



}
