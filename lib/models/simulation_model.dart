

import 'package:cloud_firestore/cloud_firestore.dart';

class SimulationModel{

  final String? id;
  final String SimulationName;
  final String EmailTemplateFileDownloadUrl;
  final String WebSiteFileDownloadUrl;
  final String WebSiteURL;
  final String Object;
  final String SenderEmail ;
  final String SenderName;


  const SimulationModel({
    this.id,
    required this.SimulationName,
    required this.EmailTemplateFileDownloadUrl,
    required this.WebSiteFileDownloadUrl,
    required this.WebSiteURL,
    required this.Object,
    required this.SenderEmail,
    required this.SenderName,
  });

  toJason(){
    return{
      "SimulationName" : SimulationName,
      "EmailTemplateFileDownloadUrl": EmailTemplateFileDownloadUrl,
      "WebSiteFileDownloadUrl" : WebSiteFileDownloadUrl,
      "WebSiteURL" : WebSiteURL,
      "Object": Object,
      "SenderEmail": SenderEmail,
      "SenderName" : SenderName,
    };
  }

  //Map user fetched fromFirebase to UserModel
  factory SimulationModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return SimulationModel(
      id: document.id,
      SimulationName: data["SimulationName"],
      EmailTemplateFileDownloadUrl : data["EmailTemplateFileDownloadUrl"],
      WebSiteFileDownloadUrl : data["WebSiteFileDownloadUrl"],
      WebSiteURL : data["WebSiteURL"],
      Object : data["Object"],
      SenderEmail :data["SenderEmail"],
        SenderName : data["SenderName"],
    );
  }




}