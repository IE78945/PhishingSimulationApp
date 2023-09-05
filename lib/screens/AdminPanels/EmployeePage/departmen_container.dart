import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/models/department_model.dart';
import 'package:phishing_simulation_app/repository/department_repository.dart';
class DepartmentContainer extends StatefulWidget {
  final DepartmentModel department;
  const DepartmentContainer({Key? key,required this.department}) : super(key: key);

  @override
  State<DepartmentContainer> createState() => _DepartmentContainerState();
}

class _DepartmentContainerState extends State<DepartmentContainer> {

  final _DepartmentRepo = Get.put(DepartmentRepository());

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
        child : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.department.departmentName),
            SizedBox(width: 5,),
            IconButton(
              icon: Icon(Icons.delete,color: Colors.red, ),
              onPressed: () {
                deleteDepartment(widget.department);
              },
            ),
          ],
        )
    );
  }
}
