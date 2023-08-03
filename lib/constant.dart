import 'package:flutter/material.dart';
import 'dart:ui';


const MyDarkBlue = Color(0xFF2FBBF5);
const MyLightBlue = Color(0xFFA4E1F4);
const MyWhite = Color(0xFFFBFAF8);

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