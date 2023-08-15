import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_responsive.dart';
import '../../controllers/menu_controller.dart';

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.height*0.02),
      child: Row(
        children: [
          if (!AppResponsive.isDesktop(context))
            IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: Colors.black,
              ),
              onPressed: Provider.of<CustomMenuController>(context, listen: false)
                  .controlMenu,
            ),
          if (!AppResponsive.isMobile(context)) ...{
            Flexible(
              child: SizedBox(),
            ),
          }
        ],
      ),
    );
  }

}
