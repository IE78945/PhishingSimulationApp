

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel{

  final String? id;
  final String fullName;
  final String email;
  //final String? photoURL;
  final String? department;

  const EmployeeModel({
    this.id,
    required this.fullName,
    required this.email,
    //this.photoURL,
    this.department,
  });

  toJason(){
    return{
      "FullName" : fullName,
      "Email" : email,
      //"PhotoURL" : photoURL,
      "Department" : department,
    };
  }

  //Map user fetched fromFirebase to UserModel
  factory EmployeeModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return EmployeeModel(
      id: document.id,
      fullName: data["FullName"],
      email: data["Email"],
      //photoURL: data["PhotoURL"],
      department: data["Department"],
    );
  }




}