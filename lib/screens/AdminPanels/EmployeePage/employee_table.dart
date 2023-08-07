
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';

import 'edit_employee_form.dart';
class EmployeeTable extends StatefulWidget {
  String SearchText;
  
  EmployeeTable( {Key? key , required this.SearchText}) : super(key: key);

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {

  final _EmployeeRepo = Get.put(EmployeeRepository());
  late TextEditingController searchController;
  bool isShowEditEmployeesDialog = false;
  RxString NewQuery = ''.obs;


  void deleteEmployee(EmployeeModel employee) {


    // Show a confirmation dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete this employee?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  } , // Close the dialog
                  child: Text('Cancel'),
                ),
                TextButton(
                    onPressed: () {
                        _EmployeeRepo.deleteEmployee(employee.id!); // Delete the employee
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    child: Text('Delete'),
                  ),
                ],
           );
          },
          );
}

  void editEmployee(EmployeeModel employee){
    setState(() {
      isShowEditEmployeesDialog = true;
    });
    showCustomDialog(
      context,
      onValue: (_) {
        setState(() {
          isShowEditEmployeesDialog = false;
        });
      },
      title: 'Add Employee',
      form: EditEmployeeForm( employee: employee,),
      widthFactor: 0.6,
      heightFactor: 0.9,

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
              "Employees",
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
            StreamBuilder<List<EmployeeModel>>(
              stream: _EmployeeRepo.searchEmployees(widget.SearchText),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var  employees = snapshot.data;
                  return DataTable(
                    columns: [
                      //DataColumn(label: Text('Photo')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Department')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: employees!.map((employee) {
                      //print(employee.photoURL!);
                      return DataRow(
                        cells: [
                          /*
                          DataCell(
                            ClipOval(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey, width: 2),
                                ),
                                child: Center(
                                  child: employee.photoURL != null
                                      ? Image.network(employee.photoURL!) // Use Image.network for loading image from URL
                                      : Icon(Icons.person), // Fallback icon when photoURL is null
                                ),
                              ),
                            ),
                          ),
                           */
                          DataCell(Text(employee.fullName)),
                          DataCell(Text(employee.email)),
                          DataCell(Text(employee.department!)),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Implement edit action
                                  editEmployee(employee);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteEmployee(employee);
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
