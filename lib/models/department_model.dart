

import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel{

  final String? id;
  final String departmentName;

  const DepartmentModel({
    this.id,
    required this.departmentName,
  });

  toJason(){
    return{
      "DepartmentName" : departmentName,
    };
  }

  //Map user fetched fromFirebase to UserModel
  factory DepartmentModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return DepartmentModel(
      id: document.id,
      departmentName: data["DepartmentName"],
    );
  }




}