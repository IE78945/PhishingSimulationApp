import 'package:flutter/material.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/EmployeePage/employees.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/reports.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/settings.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/side_bar_menu.dart';
import 'package:provider/provider.dart';

import '../../app_responsive.dart';
import '../../controllers/menu_controller.dart';
import 'CostumSimulation/costum_simulation.dart';
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
      backgroundColor: AdminMainWidgetColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Side Navigation Menu (Only show in desktop)
            if (AppResponsive.isDesktop(context))
              Expanded(
                flex: 1,
                child: SideBar(),
              ),
            // Main Body Part
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                children: [
                  // Header Part
                  Expanded(
                      flex : 1,
                      child: HeaderWidget()
                  ),
                  // Main Content
                  Expanded (
                    flex:10,
                    child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Expanded(
                      child: _buildBody(selectedMenuItem),
                    ),
                  ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(int selectedMenuItem) {
    switch (selectedMenuItem) {
      case 1:
        return Dashboard();
      case 2:
        return Employees();
      case 3:
        return CustomSimulation();
      case 4:
        return Reports();
      case 5:
        return Settings();
      default:
        return SingleChildScrollView(); // Fallback widget or default content.
    }
  }
}
