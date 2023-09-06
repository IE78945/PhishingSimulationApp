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

  // get how many campaigns an employee have taken
  Future<int> getCampaignTotalNumberForEachEmployee(String employeeID) async {
    try {
      // Reference to the Firestore collection group "TrackingDetails"
      var queryRef = FirebaseFirestore.instance.collectionGroup('TrakingDetails');

      // Perform a query to get documents where 'employeeID' matches the desired ID
      var querySnapshot = await queryRef.where('employeeID', isEqualTo: employeeID).get();

      // Get the count of documents in the query result
      int totalCampaigns = querySnapshot.size;

      print(totalCampaigns);
      return totalCampaigns;
    } catch (e) {
      print("Error counting campaigns for employee $employeeID: $e");
      return 0; // Handle the error as needed
    }
  }

  // get total number of clicked link for each employee
  Future<int> getClickLinkCountForEachEmployee(String employeeID) async {
    int linkClickCount = 0;

    try {
      // Reference to the Firestore collection group "TrackingDetails"
      var queryRef = FirebaseFirestore.instance.collectionGroup('TrakingDetails');

      // Perform a query to get documents where 'employeeID' matches the desired ID
      // and 'isEmailOpened' is equal to true
      var querySnapshot = await queryRef
          .where('employeeID', isEqualTo: employeeID)
          .where('isWebSiteLinkClicked', isEqualTo: true)
          .get();

      // Get the count of documents in the query result
      linkClickCount = querySnapshot.size;
      print("clicked link count for employee id : "+employeeID + "is : "+linkClickCount.toString());
    } catch (e) {
      print("Error counting link clicked for employee $employeeID: $e");
    }

    return linkClickCount;
  }

  // get total number of opened emails for each employee
  Future<int> getOpenEmailsCountForEachEmployee(String employeeID) async {
    int openEmailsCount = 0;

    try {
      // Reference to the Firestore collection group "TrackingDetails"
      var queryRef = FirebaseFirestore.instance.collectionGroup('TrakingDetails');

      // Perform a query to get documents where 'employeeID' matches the desired ID
      // and 'isEmailOpened' is equal to true
      var querySnapshot = await queryRef
          .where('employeeID', isEqualTo: employeeID)
          .where('isEmailOpened', isEqualTo: true)
          .get();

      // Get the count of documents in the query result
      openEmailsCount = querySnapshot.size;
      print("opened email count for employee id : "+employeeID + "is : "+openEmailsCount.toString());
    } catch (e) {
      print("Error counting opened emails for employee $employeeID: $e");
    }

    return openEmailsCount;
  }

  Future<List<CampaignModel>> getCampaignsForEmployee(String employeeID) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('TrakingDetails')
          .where('employeeID', isEqualTo: employeeID)
          .get();

      final List<CampaignModel> campaignsList = [];

      for (final DocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
        // You might want to extract campaign data from the document or reference
        // and then fetch the campaign details from the 'Campaigns' collection.
        // Assuming 'campaignID' is a field in your 'TrackingDetails' subcollection.
        final String campaignID = document['campaignID'];
        final DocumentSnapshot<Map<String, dynamic>> campaignDocument = await FirebaseFirestore.instance
            .collection('Campaigns')
            .doc(campaignID)
            .get();

        if (campaignDocument.exists) {
          final CampaignModel campaign = CampaignModel.fromSnapshot(campaignDocument);
          campaignsList.add(campaign);
        }
      }

      return campaignsList;
    } catch (e) {
      print('Error fetching campaigns for employee: $e');
      return [];
    }
  }





  Future<List<TrakingDataModel>> getTrackingDataForCampaign(String campaignID, String employeeID) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('Campaigns') // Replace with your collection name
          .doc(campaignID)
          .collection('TrakingDetails')
          .where('employeeID', isEqualTo: employeeID)
          .get();

      final List<TrakingDataModel> trackingDataList = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> document) {
        return TrakingDataModel.fromSnapshot(document);
      })
          .toList();

      return trackingDataList;
    } catch (e) {
      print('Error fetching tracking data for campaign: $e');
      return [];
    }
  }


}