
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phishing_simulation_app/models/simulation_model.dart';

class TrakingDataModel{
  final String? id;
  final String campaignID;
  final String employeeID;
  final bool isEmailOpened;
  final Timestamp EmailTimeOpening;
  final bool isWebSiteLinkClicked;
  final Timestamp WebSiteLinkClickTime;
  final String EmployeeName;
  final String departmentName;
  String? CampaignName;
  SimulationModel? simulation;


   TrakingDataModel({
    this.id,
     required this.campaignID,
     required this.employeeID,
    required this.isEmailOpened,
    required this.EmailTimeOpening,
    required this.isWebSiteLinkClicked,
    required this.WebSiteLinkClickTime,
    required this.EmployeeName,
    required this.departmentName,
    this.CampaignName,
    this.simulation,
  });

  toJason(){
    return{
      "campaignID" : campaignID,
      "employeeID" : employeeID,
      "isEmailOpened" : isEmailOpened,
      "EmailTimeOpening" :EmailTimeOpening,
      "isWebSiteLinkClicked" :isWebSiteLinkClicked,
      "WebSiteLinkClickTime" : WebSiteLinkClickTime,
      "EmployeeName" : EmployeeName,
      "departmentName" : departmentName ,
    };
  }

  //Map user fetched fromFirebase to UserModel
  factory TrakingDataModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return TrakingDataModel(
      id: document.id,
      campaignID : data["campaignID"],
      employeeID : data["employeeID"],
      isEmailOpened: data["isEmailOpened"],
      EmailTimeOpening : data["EmailTimeOpening"],
      isWebSiteLinkClicked : data["isWebSiteLinkClicked"],
      WebSiteLinkClickTime : data["WebSiteLinkClickTime"],
      EmployeeName : data["EmployeeName"],
      departmentName : data["departmentName"],
    );
  }




}