
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/models/department_model.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/department_repository.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';

import 'edit_employee_form.dart';
class DepartmentsTable extends StatefulWidget {
  String SearchText;
  
  DepartmentsTable( {Key? key , required this.SearchText}) : super(key: key);

  @override
  State<DepartmentsTable> createState() => _DepartmentsTableState();
}

class _DepartmentsTableState extends State<DepartmentsTable> {

  final _DepartmentRepo = Get.put(DepartmentRepository());
  late TextEditingController searchController;
  bool isShowEditEmployeesDialog = false;
  RxString NewQuery = ''.obs;


  void deleteDepartment(DepartmentModel department) {

    // Show a confirmation dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete this department and all his employees?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  } , // Close the dialog
                  child: Text('Cancel'),
                ),
                TextButton(
                    onPressed: () {
                      _DepartmentRepo.deleteDepartment(department); // Delete the employee
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    child: Text('Delete'),
                  ),
                ],
           );
          },
          );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height* 0.5 ,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height* 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Departments",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            StreamBuilder<List<DepartmentModel>>(
              stream: _DepartmentRepo.searchDepartment(widget.SearchText),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var  deparments = snapshot.data;
                  return DataTable(
                    columns: [
                      //DataColumn(label: Text('Photo')),
                      DataColumn(label: Text('Department Name')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: deparments!.map((department) {
                      //print(employee.photoURL!);
                      return DataRow(
                        cells: [
                          DataCell(Text(department.departmentName)),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete,color: Colors.red, ),
                                onPressed: () {
                                  deleteDepartment(department);
                                },
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            )

          ],
        ),
      ),
    );
  }


  Widget tableHeader(text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
