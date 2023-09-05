
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/models/department_model.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/department_repository.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';

import 'departmen_container.dart';
import 'edit_employee_form.dart';
class DepartmentsGrid extends StatefulWidget {
  String SearchText;
  
  DepartmentsGrid( {Key? key , required this.SearchText}) : super(key: key);

  @override
  State<DepartmentsGrid> createState() => _DepartmentsGridState();
}

class _DepartmentsGridState extends State<DepartmentsGrid> {

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
    return StreamBuilder<List<DepartmentModel>>(
              stream: _DepartmentRepo.searchDepartment(widget.SearchText),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var  departments = snapshot.data;
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      maxCrossAxisExtent: 250, // Maximum width for each cell
                      childAspectRatio: 3 / 1, // Width / Height ratio for cells
                    ),
                    itemCount: departments?.length,
                    itemBuilder: (context, index) {
                      return DepartmentContainer(department: departments![index]);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
  }

}
