import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phishing_simulation_app/models/department_model.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'employee_repository.dart';

class DepartmentRepository extends GetxController{
  static DepartmentRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final employeeRepo = Get.put(EmployeeRepository());

  //Store Department in firestore
  Future<bool> AddDepartment(DepartmentModel department) async {
    bool result = false;
    await _db.collection("Departments").doc(department.id).set(department.toJason()).whenComplete(() => {
    Get.snackbar(
    "success",
    "Department have been added successfully",
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


  // Fetch All departments in firestore
  Stream<List<DepartmentModel>> getAllDepartments() {
    var _ref = _db.collection("Departments");
    return _ref.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return DepartmentModel.fromSnapshot(doc);
      }).toList();
    });
  }

  Future<List<DepartmentModel>> getAllDepartmentsList() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('Departments').get();
      return querySnapshot.docs.map((doc) => DepartmentModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print("Error fetching departments: $e");
      return []; // Return an empty list or handle the error as needed
    }
  }

  //delete department
  Future<void> deleteDepartment(DepartmentModel department) async {
    try {
      // Get the document reference
      DocumentReference Ref = _db.collection('Departments').doc(department.id);

      // delete department's employees
      List<EmployeeModel> employees = await employeeRepo.getEmployeesByDepartment(department.departmentName);
      employees.forEach((EmployeeModel employee) async {
        await employeeRepo.deleteEmployee(employee.id!);
      });
      // Delete department
      await Ref.delete();

      Get.snackbar(
        "success",
        "Department have been deleted successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.green,
      );
      print('Department deleted successfully');
    } catch (e) {
      Get.snackbar(
        "Error",
        "Couldn't delete department. Please retry later",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.red,
      );
      print('Error deleting department: $e');
    }
  }


  //Search department
  Stream<List<DepartmentModel>> searchDepartment(String query) {
    // Get the original stream from getAllEmployee()
    var originalStream = getAllDepartments();

    // Create a new stream that filters employees based on the query
    var filteredStream = originalStream.map((departments) {
      if (query.isEmpty) {
        return departments;
      } else {
        return departments.where((department) =>
        department.departmentName.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });

    return filteredStream;
  }

}