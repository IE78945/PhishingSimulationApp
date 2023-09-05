import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:phishing_simulation_app/models/simulation_model.dart';

class SimulationRepository extends GetxController {
  static SimulationRepository get instance => Get.find();

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

  //Store htmlFile (email template) in firebase storage
  Future<String> UploadEmailTemplate(String EmailTemplateHtmlCode) async {
    String FileURL ="";

    try {
      final Reference ref = storage.ref().child('EmailTemplates').child(getRandomString(10));
      await ref.putString(EmailTemplateHtmlCode).whenComplete(() async {
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

  //Store htmlFile (web site) in firebase storage
  Future<String> UploadWebSiteHtmlCode(String WebSiteURL , String WebSiteCode) async {
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

  //Store simulation in firestore
  Future<bool> AddSimulation(SimulationModel simulation) async {
    bool result = false;
    await _db.collection("Simulations").doc(simulation.SimulationName).set(simulation.toJason()).whenComplete(() => {
      Get.snackbar(
        "success",
        "simulation have been saved successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.green,
      ),
      result =true
    })
        .catchError((error, stackTrace){
      print(error.toString());
      Get.snackbar(
        "Error",
        "Something went wrong please retry later",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.red,
      );
      result = false;
    });
    return result;
  }


  // Fetch All simulations models from firestore in list
  Future<List<SimulationModel>> getAllSimulationList() async {
    var _ref = _db.collection("Simulations").orderBy("SimulationName");
    try {
      QuerySnapshot querySnapshot = await _ref.get();
      return querySnapshot.docs.map((doc) => SimulationModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print("Error fetching simulation: $e");
      return []; // Return an empty list or handle the error as needed
    }
  }

  // Fetch All simulations models from  firestore in stream
  Stream<List<SimulationModel>> getAllSimulation() {
    var _ref = _db.collection("Simulations").orderBy("SimulationName");
    return _ref.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return SimulationModel.fromSnapshot(doc);
      }).toList();
    });
  }

  //fetch a simulationby name
  Future<List<SimulationModel>> getSimulationByNameList(String SimulationName) async {
    var _ref = _db.collection("Simulations");
    try {
      QuerySnapshot querySnapshot = await _ref.where('SimulationName', isEqualTo: SimulationName).get();
      return querySnapshot.docs.map((doc) => SimulationModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print("Error fetching simulation: $e");
      return []; // Return an empty list or handle the error as needed
    }
  }

}