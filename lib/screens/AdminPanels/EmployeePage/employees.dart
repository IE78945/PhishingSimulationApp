import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/EmployeePage/add_department_form.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/EmployeePage/departments_table.dart';
import 'package:phishing_simulation_app/screens/Components/CostumButtonForInterfaces.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';

import '../../../constant.dart';
import 'add_employee_form.dart';
import 'employee_table.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);


  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  final _EmployeeRepo = Get.put(EmployeeRepository());
  String selectedOption = 'Employees';
  bool isShowAddEmployeesDialog = false;
  String searchTextEmployee = "";
  TextEditingController searchControllerEmployee = TextEditingController();
  bool isShowAddDepartmentsDialog = false;
  String searchTextDepartments = "";
  TextEditingController searchControllerDepartments = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Column(
        children: [
          Row(
            children: [
              _buildToggleButton('Employees'),

              _buildToggleButton('Departments'),
            ],
          ),
          SizedBox(height:MediaQuery.of(context).size.height* 0.05 ),
          selectedOption == 'Employees'
                ? _EmployeesSubInterface()
                : _GroupsSubInterface(),

        ],
      ),
    );
  }

  Widget _buildToggleButton(String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height* 0.01),
        decoration: BoxDecoration(
          border: selectedOption == option
              ? Border(bottom: BorderSide(width: 2, color: Colors.blue))
              : null,
        ),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: selectedOption == option ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _EmployeesSubInterface() {

    return Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SearchBarEmployee(),
              ),
              SizedBox(width: 5),
              Expanded(
                child: CustomButtonForInterfaces(
                    context,
                    BtnAction: () {
                      setState(() {
                        isShowAddEmployeesDialog = true;
                      });
                      showCustomDialog(
                        context,
                        onValue: (_) {
                          setState(() {
                            isShowAddEmployeesDialog = false;
                          });
                        },
                        title: 'Add Employee',
                        form: AddEmployeeForm(),
                        widthFactor: 0.6,
                        heightFactor: 0.9,

                      );

                    },
                    textBtn: 'New Employee',
                    icon: Icon(Icons.add),
                    paddingsize: 12.0),
              ),
            ],
          ),
          SizedBox(height:MediaQuery.of(context).size.height* 0.05),
          EmployeeTable(SearchText: searchTextEmployee,),
        ],
      );

  }

  Widget _GroupsSubInterface() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SearchBarDepartments(),
            ),
            SizedBox(width: 5),
            Expanded(
              child: CustomButtonForInterfaces(
                  context,
                  BtnAction: () {
                    setState(() {
                      isShowAddDepartmentsDialog = true;
                    });
                    showCustomDialog(
                      context,
                      onValue: (_) {
                        setState(() {
                          isShowAddDepartmentsDialog  = false;
                        });
                      },
                      title: 'Add Department',
                      form: AddDepartmentForm(),
                      widthFactor: 0.6,
                      heightFactor: 0.9,

                    );

                  },
                  textBtn: 'New Department',
                  icon: Icon(Icons.add),
                  paddingsize: 12.0),
            ),
          ],
        ),
        SizedBox(height:MediaQuery.of(context).size.height* 0.05),
        DepartmentsTable(SearchText: searchTextDepartments,),
      ],
    );
  }

  Widget SearchBarEmployee(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.height* 0.02),
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
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(Icons.search),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchControllerEmployee,
              onChanged: (query) {
                // Perform search when the text changes
                // You can call a search function here
                setState(() {
                  searchTextEmployee = searchControllerEmployee.text;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              searchControllerEmployee.clear();
              setState(() {
                searchTextEmployee = "";
              });
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
    );
  }


  Widget SearchBarDepartments(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.height* 0.02),
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
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(Icons.search),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchControllerDepartments,
              onChanged: (query) {
                // Perform search when the text changes
                // You can call a search function here
                setState(() {
                  searchTextDepartments = searchControllerDepartments.text;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              searchControllerDepartments.clear();
              setState(() {
                searchTextDepartments  = "";
              });
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
    );
  }
}


