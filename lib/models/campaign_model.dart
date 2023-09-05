

import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel{

  final String? id;
  final String CampaignName;
  final String SimulationName;
  final int EmployeeTotalNumber;

  const CampaignModel({
    this.id,
    required this.CampaignName,
    required this.SimulationName,
    required this.EmployeeTotalNumber,
  });

  toJason(){
    return{
      "CampaignName" : CampaignName,
      "SimulationName" :SimulationName,
      "EmployeeTotalNumber" :EmployeeTotalNumber,
    };
  }

  //Map user fetched fromFirebase to UserModel
  factory CampaignModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data() as Map<String, dynamic>;

    return CampaignModel(
        id: document.id,
        CampaignName: data["CampaignName"],
        SimulationName : data["SimulationName"],
        EmployeeTotalNumber : data["EmployeeTotalNumber"],
    );
  }




}