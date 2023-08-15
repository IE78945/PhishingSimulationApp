import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';

import 'edit_employee_form.dart';
import 'employee_container.dart';

class EmployeeGrid extends StatefulWidget {
  String SearchText;

  EmployeeGrid( {Key? key , required this.SearchText}) : super(key: key);

  @override
  State<EmployeeGrid> createState() => _EmployeeGridState();
}

class _EmployeeGridState extends State<EmployeeGrid> {

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
              onPressed: () async {
                bool isImageDeleted = false;
                if (employee.photoName!.isNotEmpty){
                  isImageDeleted = await _EmployeeRepo.deletePicture(employee.photoName!);
                  if (isImageDeleted) {
                    _EmployeeRepo.deleteEmployee(employee.id!); // Delete the employee
                  }
                }
                else
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
      title: 'Edit Employee',
      form: EditEmployeeForm( employee: employee,),
      widthFactor: 0.6,
      heightFactor: 0.9,

    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EmployeeModel>>(
      stream: _EmployeeRepo.searchEmployees(widget.SearchText),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var  employees = snapshot.data;
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              maxCrossAxisExtent: 250, // Maximum width for each cell
              childAspectRatio: 1 / 1.6, // Width / Height ratio for cells
            ),
            itemCount: employees?.length,
            itemBuilder: (context, index) {
              return EmployeeContainer(employee: employees![index]);
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
