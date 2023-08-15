import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/EmployeePage/add_department_form.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/EmployeePage/employee_grid.dart';
import 'package:phishing_simulation_app/screens/Components/CostumButtonForInterfaces.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';
import 'add_employee_form.dart';
import 'departments_grid.dart';

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
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width* 0.02),
      child:
      Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _buildToggleButton('Employees'),
                  SizedBox(width:MediaQuery.of(context).size.width* 0.02 ),
                _buildToggleButton('Departments'),
              ],
            ),
          ),
          Expanded(
            flex: 11,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height* 0.02),
              child: selectedOption == 'Employees'
                  ? _EmployeesSubInterface()
                  : _GroupsSubInterface(),
            ),
          ),

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
          Expanded(
            child: Row(
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
          ),
          Expanded(
              flex : 9,
              child: Padding(
                padding:EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height* 0.02,horizontal:  MediaQuery.of(context).size.height* 0.02),
                child:
                //EmployeeTable(SearchText: searchTextEmployee,),
                      SingleChildScrollView(
                      child : EmployeeGrid(SearchText: searchTextEmployee),
                      ),
              )),
        ],
      );

  }

  Widget _GroupsSubInterface() {
    return Column(
      children: [
        Expanded(
          child: Row(
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
        ),
        //DepartmentsTable(SearchText: searchTextDepartments,),
        Expanded(
            flex : 9,
            child: Padding(
              padding:EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height* 0.02,horizontal:  MediaQuery.of(context).size.height* 0.02),
              child:
              SingleChildScrollView(
                child : DepartmentsGrid(SearchText: searchTextDepartments),
              ),
            )),
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


