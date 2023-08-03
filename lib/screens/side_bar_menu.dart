import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:provider/provider.dart';

import '../controllers/menu_controller.dart';
import '../repository/authentication_repository.dart';
import 'landing_page.dart';

class SideBar extends StatefulWidget {
  int? clickedMenuItemIndex;

  SideBar({
    Key? key,
    this.clickedMenuItemIndex,
  }) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override

  late int _activeIndex ;

  void _onMenuItemPress(int index) {
    Provider.of<CustomMenuController>(context, listen: false).selectMenuItem(index);
    setState(() {
      _activeIndex = index;
    });
  }

  bool isItemSelected(int index){
    if (_activeIndex == index) return true;
    else return false;
  }

  @override
  void initState() {
    if (widget.clickedMenuItemIndex == null) {
      _activeIndex = 0;
    }
    else {
      _activeIndex = widget.clickedMenuItemIndex!;
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: MyWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "TEST",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DrawerListTile(
              title: "Dashboard",
              icon: "assets/svg/dashboard-svgrepo-com.svg",
              press: () {
                _onMenuItemPress(1);
              },
              isActive: isItemSelected(1),
            ),
            DrawerListTile(
              title: "Employees",
              icon: "assets/svg/people-team-svgrepo-com.svg",
              press: () {
                _onMenuItemPress(2);
              },
              isActive: isItemSelected(2),
            ),
            DrawerListTile(
              title: "New Simulation",
              icon: "assets/svg/add-bracket-svgrepo-com.svg",
              press: () {
                _onMenuItemPress(3);
              },
              isActive: isItemSelected(3),
            ),
            DrawerListTile(
              title: "Reports",
              icon: "assets/svg/report-linechart-svgrepo-com.svg",
              press: () {
                _onMenuItemPress(4);
              },
              isActive: isItemSelected(4),
            ),
            DrawerListTile(
              title: "Settings",
              icon: "assets/svg/settings-svgrepo-com.svg",
              press: () {
                _onMenuItemPress(5);
              },
              isActive: isItemSelected(5),
            ),
            DrawerListTile(
              title: "Sign out",
              icon: "assets/svg/sign-out-svgrepo-com.svg",
              press: () {
                _onMenuItemPress(6);
                setState(() {
                  AuthentificationRepository.instance.logout();
                  Get.snackbar(
                    "success",
                    "Logged out successfully",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.white.withOpacity(0.7),
                    colorText: Colors.green,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LandingPage(),
                    ),
                  );
                });
              },
            ),
            /*
            Spacer(),
            Image.asset("assets/sidebar_image.png")
             */
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title, icon;
  final VoidCallback press;
  final bool? isActive,showBorder;

  const DrawerListTile({Key? key,this.isActive = false,this.showBorder = true, required this.title, required this.icon, required this.press})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: InkWell(
        onTap: press,
        child: Row(
          children: [
            (isActive ?? false )
                ? SvgPicture.asset(
              "assets/Icons/Angle right.svg",
              width: 15,
            )
                : SizedBox(width: 15),
            SizedBox(width: 20.0 / 4),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 15, right: 5),
                decoration: showBorder ?? true
                    ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFDFE2EF)),
                  ),
                )
                    : null,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      icon,
                      height: 20,
                      color: (isActive ?? false )
                          ? MyDarkBlue
                          : Colors.black
                    ),
                    SizedBox(width: 20.0 * 0.75),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.button?.copyWith(
                        color: (isActive ?? false )
                            ? MyDarkBlue
                            : Colors.black
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
