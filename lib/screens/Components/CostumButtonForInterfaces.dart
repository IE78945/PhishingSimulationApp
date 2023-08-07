import 'package:flutter/material.dart';
import 'package:phishing_simulation_app/app_responsive.dart';

Widget CustomButtonForInterfaces(BuildContext context, {required VoidCallback BtnAction ,required String textBtn, required Icon icon, required double paddingsize}) {
  return GestureDetector(
    onTap: BtnAction,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height* 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(paddingsize),
        child: AppResponsive.isDesktop(context)?
        Row(
          children: [
            SizedBox(width: 10),
            icon,
            SizedBox(width: 10,),
            Expanded(
              child: Text(
                  textBtn
              ),
            ),

          ],
        )
            :icon,
      ),
    ),
  );
}