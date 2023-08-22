import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ClonnedWebSitesRepository extends GetxController{
  static ClonnedWebSitesRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  // Function to generate a random string of specified length
  String getRandomString(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random rnd = Random(DateTime.now().millisecondsSinceEpoch);
    String result = '';
    for (var i = 0; i < length; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  //Store htmlFile in firebase storage
  Future<String> UploadHtmlFile(String WebSiteURL , String WebSiteCode) async {
    String FileURL ="";

    // Parse the URL using the Uri class
    Uri uri = Uri.parse(WebSiteURL);
    // Get the host (domain) from the parsed URI
    String domain = uri.host;
    // Remove trailing slashes if they exist
    WebSiteURL = domain.endsWith('/') ? domain.substring(0, domain.length - 1) : domain;

    try {
      final Reference ref = storage.ref().child('ClonnedWebSites').child('$WebSiteURL.html');
      await ref.putString(WebSiteCode).whenComplete(() async {
        FileURL = await ref.getDownloadURL();
        }).catchError((error, stackTrace) {
          print(error.toString());
          FileURL = "";
        });

    } catch (e) {
      print("error uploading htmlFile");
      print(e.toString());
    }
    return FileURL;
  }


}