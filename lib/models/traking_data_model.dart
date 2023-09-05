
import 'package:cloud_firestore/cloud_firestore.dart';

class TrakingDataModel{
  final String? id;
  final bool isEmailOpened;
  final Timestamp EmailTimeOpening;
  final bool isWebSiteLinkClicked;
  final Timestamp WebSiteLinkClickTime;
  final String EmployeeName;
  final String departmentName;


  const TrakingDataModel({
    this.id,
    required this.isEmailOpened,
    required this.EmailTimeOpening,
    required this.isWebSiteLinkClicked,
    required this.WebSiteLinkClickTime,
    required this.EmployeeName,
    required this.departmentName,
  });

  toJason(){
    return{
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
      isEmailOpened: data["isEmailOpened"],
      EmailTimeOpening : data["EmailTimeOpening"],
      isWebSiteLinkClicked : data["isWebSiteLinkClicked"],
      WebSiteLinkClickTime : data["WebSiteLinkClickTime"],
      EmployeeName : data["EmployeeName"],
      departmentName : data["departmentName"],
    );
  }




}