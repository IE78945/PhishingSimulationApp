import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:phishing_simulation_app/models/campaign_model.dart';
import 'package:phishing_simulation_app/models/simulation_model.dart';
import 'package:phishing_simulation_app/models/traking_data_model.dart';

class CampaignRepository extends GetxController {
  static CampaignRepository get instance => Get.find();

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

  Future<String> createCampaign(CampaignModel campagne) async {
    try {
      final CollectionReference campaignsCollection = FirebaseFirestore.instance.collection('Campaigns');

      // Add the campaign to Firestore. Firestore will generate a unique ID.
      final DocumentReference newDocument = await campaignsCollection.add(campagne.toJason());

      // Retrieve the ID of the newly created document.
      final String newCampaignId = newDocument.id;

      return newCampaignId;
    } catch (e) {
      // Handle any errors that may occur during campaign creation.
      print('Failed to create campaign: $e');
      return "";
    }
  }


  // Fetch All campaigns models from firestore in List
  Future<List<CampaignModel>> getAllCampagnesList() async {
    var _ref = _db.collection("Campaigns").orderBy("CampaignName");
    try {
      QuerySnapshot querySnapshot = await _ref.get();
      return querySnapshot.docs.map((doc) => CampaignModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print("Error fetching simulation: $e");
      return []; // Return an empty list or handle the error as needed
    }
  }

  // Fetch All campaigns from firestore in stream
  Stream<List<CampaignModel>> getAllCampagnes() {
    var _ref = _db.collection("Campaigns").orderBy("CampaignName");
    return _ref.snapshots().map<List<CampaignModel>>((querySnapshot) {
      return querySnapshot.docs.map<CampaignModel>((doc) {
        return CampaignModel.fromSnapshot(doc);
      }).toList();
    });
  }


  Future<int> getNumberOfOpenedEmails(String? CampaignId) async {
    int result = 0 ;
    var _ref = _db.collection("Campaigns").doc(CampaignId).collection("TrakingDetails");

    try {
      var querySnapshot = await _ref.where("isEmailOpened", isEqualTo: true).get();
      result = querySnapshot.docs.length;
    }
    catch (e){
      print("Error getting opened emails number: $e");
    }

    return result;
  }

  Future<int> getNumberOfLinkClicking(String? CampaignId) async {
    int result = 0 ;
    var _ref = _db.collection("Campaigns").doc(CampaignId).collection("TrakingDetails");

    try {
      var querySnapshot = await _ref.where("isWebSiteLinkClicked", isEqualTo: true).get();
      result = querySnapshot.docs.length;
    }
    catch (e){
      print("Error getting web site LinkClicked: $e");
    }

    return result;
  }


  Future<void> addTrakingDetailsForEmployee(String? CampaignId, TrakingDataModel trakingDataModel , String? EmployeeId) async {
    var _ref = _db.collection("Campaigns").doc(CampaignId).collection("TrakingDetails").doc(EmployeeId);

    try {
        await _ref.set(trakingDataModel.toJason());
        print('traking details for employee have been added');
    } catch (e) {
      // Handle any errors that may occur during campaign creation.
      print('Failed to create campaign: $e');

    }
  }

  // Fetch All traking details models from firestore in List of a given campaign id
  Future<List<TrakingDataModel>> getAllTrakingDetailsList(String CampaignId) async {
    var _ref = _db.collection("Campaigns").doc(CampaignId).collection("TrakingDetails");
    try {
      QuerySnapshot querySnapshot = await _ref.get();
      return querySnapshot.docs.map((doc) => TrakingDataModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print("Error fetching simulation: $e");
      return []; // Return an empty list or handle the error as needed
    }
  }





}