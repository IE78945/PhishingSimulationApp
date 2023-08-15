import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';

import 'edit_employee_form.dart';

class EmployeeContainer extends StatefulWidget {
  final EmployeeModel employee;
  const EmployeeContainer({Key? key , required this.employee}) : super(key: key);

  @override
  State<EmployeeContainer> createState() => _EmployeeContainerState();
}

class _EmployeeContainerState extends State<EmployeeContainer> {
  final _EmployeeRepo = Get.put(EmployeeRepository());
  bool isShowEditEmployeesDialog = false;
  Color editIconColor = Colors.grey;
  Color deleteIconColor = Colors.grey;

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
                if (employee.photoName != null){
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
    return Container(
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
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 0.5/0.5,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: widget.employee.photoURL != null
                    ? ClipOval(child: Image.network( widget.employee.photoURL!,fit: BoxFit.cover,)) // Use Image.network for loading image from URL
                    : Center(child: Icon(Icons.person,size: 80,)), // Fallback icon when photoURL is null
              ),
            ),

            Expanded(child: Text(widget.employee.fullName,style: EmployeeNamesLayout)),
            Expanded(child: Text(widget.employee.department!,style: EmployeeDepartmentLayout,),),
            Expanded(child: Text(widget.employee.email,style: EmployeeEmailLayout,)),
            Expanded(child: SizedBox(height: MediaQuery.of(context).size.height* 0.02,),),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MouseRegion(
                    onHover: (event) {
                      // Handle hover state
                      setState(() {
                        editIconColor = Colors.blue; // Set the icon color
                      });
                    },
                    onExit: (event) {
                      // Handle exit state
                      setState(() {
                        editIconColor = Colors.grey; // Reset icon color
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: editIconColor),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit,color: editIconColor,),
                        onPressed: () {
                          // Implement edit action
                          editEmployee(widget.employee);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  MouseRegion(
                    onHover: (event) {
                      // Handle hover state
                      setState(() {
                        deleteIconColor = Colors.red; // Set the icon color
                      });
                    },
                    onExit: (event) {
                      // Handle exit state
                      setState(() {
                        deleteIconColor = Colors.grey; // Reset icon color
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: deleteIconColor),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete,color: deleteIconColor,size: 20, ),
                        onPressed: () {
                          deleteEmployee(widget.employee);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )

          ],
        )
    );
  }
}
