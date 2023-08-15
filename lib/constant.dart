import 'package:flutter/material.dart';
import 'dart:ui';


const MyDarkBlue = Color(0xFF2FBBF5);
const MyLightBlue = Color(0xFFA4E1F4);
const MyWhite = Color(0xFFFBFAF8);
const SideBarMenuColor = Color(0xFF4D5875);
const AdminMainWidgetColor = Color(0xFFF2F4FC);

const landingPageTitle = TextStyle(
    color: MyDarkBlue ,
    backgroundColor: MyWhite,
    fontFamily: "Poppins-Bold"
);

const landingPageText = TextStyle(
    color: Colors.black87 ,
    backgroundColor: MyWhite,
    fontFamily: "Poppins-Light",
);

const landingPageButtonText = TextStyle(
    color: MyWhite ,
    fontFamily: "Poppins-ExtraBoldItalic",
);

const MyGradient = LinearGradient(
    colors: [MyLightBlue, MyDarkBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0], // Optional: Specify stops for each color (0.0 to 1.0)
);

const TextFieldTitle = TextStyle(
    color: Colors.black54,
    fontFamily: "Poppins-Regular",
    fontSize: 18.0,
);

const EmployeeNamesLayout = TextStyle(
    color: Colors.black,
    fontFamily: "Poppins-Bold",
    fontSize: 18.0,
);

const EmployeeDepartmentLayout = TextStyle(
    color: Colors.black54,
    fontFamily: "Poppins-Regular",
    fontSize: 16.0,
);

const EmployeeEmailLayout = TextStyle(
    color: Colors.black54,
    fontFamily: "Poppins-ExtraLight",
    fontSize: 14.0,
);
