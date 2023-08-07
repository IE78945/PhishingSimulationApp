import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EmployeeRepository extends GetxController{
  static EmployeeRepository get instance => Get.find();

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

  //Store photo in firebase storage

  Future<String> uploadPicture(Uint8List imageBytes) async {
    String pictureURL = "";

    try {
      final String randomName = getRandomString(10);
      final Reference ref = storage.ref().child('EmployeesPictures').child('$randomName.jpg');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg', // Change this to the appropriate content type
      );
      if (kIsWeb) {
        // For web platform, use putData instead of putBlob
        await ref.putData(imageBytes,metadata).whenComplete(() async {
          pictureURL = await ref.getDownloadURL();
        }).catchError((error, stackTrace) {
          print(error.toString());
          pictureURL = "";
        });
      } else {
        // For mobile platform, use putBlob
        final Blob imageBlob = Blob(imageBytes);

        await ref.putBlob(imageBlob,metadata).whenComplete(() async {
          pictureURL = await ref.getDownloadURL();
        }).catchError((error, stackTrace) {
          print(error.toString());
          pictureURL = "";
        });
      }
    } catch (e) {
      print(e.toString());
      pictureURL = "";
    }

    return pictureURL;
  }

  //Store Employee in firestore
  Future<bool> AddEmployee(EmployeeModel employee) async {
    bool result = false;
    await _db.collection("Employee").doc(employee.id).set(employee.toJason()).whenComplete(() => {
    Get.snackbar(
    "success",
    "Employee have been added successfully",
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


  // Fetch All employees in firestore
  Stream<List<EmployeeModel>> getAllEmployee() {
    var _ref = _db.collection("Employee").orderBy("FullName");
    return _ref.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return EmployeeModel.fromSnapshot(doc);
      }).toList();
    });
  }

  //delete employee
  Future<void> deleteEmployee(String employeeId) async {
    try {
      // Get the document reference
      DocumentReference employeeRef = _db.collection('Employee').doc(employeeId);

      // Delete the document
      await employeeRef.delete();
      Get.snackbar(
        "success",
        "Employee have been deleted successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.green,
      );
      print('Employee deleted successfully');
    } catch (e) {
      Get.snackbar(
        "Error",
        "Couldn't delete employee. Please retry later",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.red,
      );
      print('Error deleting employee: $e');
    }
  }

  //Edit employee
  Future<bool> editEmployee(EmployeeModel employee) async {
    bool result = false;
    await _db.collection("Employee").doc(employee.id).update({
      "FullName" : employee.fullName,
      "Email" : employee.email,
      //"PhotoURL" : employee.photoURL,
      "Department" : employee.department,
    }).whenComplete(() => {
      Get.snackbar(
        "success",
        "Changes has been saved",
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

  //Search employee
  Stream<List<EmployeeModel>> searchEmployees(String query) {
    // Get the original stream from getAllEmployee()
    var originalStream = getAllEmployee();

    // Create a new stream that filters employees based on the query
    var filteredStream = originalStream.map((employees) {
      if (query.isEmpty) {
        return employees;
      } else {
        return employees.where((employee) =>
        employee.fullName.toLowerCase().contains(query.toLowerCase()) ||
            employee.email.toLowerCase().contains(query.toLowerCase()) ||
            employee.department!.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });

    return filteredStream;
  }

}