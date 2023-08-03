import 'package:flutter/material.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/screens/side_bar_menu.dart';
import 'package:provider/provider.dart';

import '../app_responsive.dart';
import '../controllers/menu_controller.dart';
import 'dashboard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      key: Provider.of<CustomMenuController>(context, listen: false).scaffoldKey,
      backgroundColor: MyLightBlue,
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
              child: Dashboard(),
            ),
          ],
        ),
      ),
    );
  }
}
