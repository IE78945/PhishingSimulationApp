
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phishing_simulation_app/constant.dart';

Widget CustomButtonForm(BuildContext context, {required VoidCallback BtnAction ,required String textBtn, required IconData icon, required double widthBtn , required double topLeftRadius,required bool isLoading}) {
  if (isLoading==false )
    return ElevatedButton.icon(
      onPressed: BtnAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyLightBlue,
        minimumSize: Size(widthBtn, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeftRadius),
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
      ),
      icon:  Icon(
        icon,
        color: MyWhite,
      ),
      label:  Text(textBtn),
    );

  else
    return ElevatedButton(
    onPressed: (){},
    style: ElevatedButton.styleFrom(
      backgroundColor: MyLightBlue,
      minimumSize: Size(widthBtn, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeftRadius),
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
          ),
        ),
      ),
      child: CircularProgressIndicator(color: MyWhite,),
    );



}