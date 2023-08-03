import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_responsive.dart';
import '../controllers/menu_controller.dart';

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          if (!AppResponsive.isDesktop(context))
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: Provider.of<CustomMenuController>(context, listen: false)
                  .controlMenu,
            ),
          Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!AppResponsive.isMobile(context)) ...{
            Spacer(),
          }
        ],
      ),
    );
  }

}
