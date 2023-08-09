import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/models/department_model.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/department_repository.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/Components/CustomButtonForm.dart';

class AddDepartmentForm extends StatefulWidget {
  const AddDepartmentForm({Key? key}) : super(key: key);

  @override
  State<AddDepartmentForm> createState() => _AddDepartmentFormState();
}

class _AddDepartmentFormState extends State<AddDepartmentForm> {

  final departmentRepo = Get.put(DepartmentRepository());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _departmentNameController = TextEditingController();
  bool isLoading = false;


  @override
  void dispose() {
    _departmentNameController.dispose();
    super.dispose();
  }

  void ClearFormField(){
    setState(() {
      isLoading = false;
    });
    _departmentNameController.clear();
  }

  void AddNewDepartment(BuildContext context) {
    Future( () async {
        if (_formKey.currentState!.validate()) {
          // All fields are valitade
          //...... Do something : check is user already exists if not add to database
          setState(() {
            isLoading = true;
          });

            final department = DepartmentModel(
              departmentName: _departmentNameController.text,
            );

            Future<bool> isDepartmentAdded =  departmentRepo.AddDepartment(department);
            // if department was added successflly
            if (await isDepartmentAdded)
              ClearFormField();
            else{
              setState(() {
                isLoading = false;
              });
            }
          }


        // Form not valid
        else {
          Get.snackbar(
            "Error",
            "Please verify informations",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white.withOpacity(0.7),
            colorText: Colors.red,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      //Full Name
                      const Text(
                        "Department name",
                        style: TextFieldTitle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: TextFormField(
                          controller: _departmentNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a full name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide( width: 3, color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                              child: Icon(Icons.person),
                            ),
                          ),
                        ),
                      ),

                    ]

                ),

                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: CustomButtonForm(
                    context,
                    BtnAction: () { print ('hi');AddNewDepartment(context); },
                    textBtn: 'Add',
                    icon: CupertinoIcons.add,
                    widthBtn: 100,
                    topLeftRadius: 25,
                    isLoading: isLoading,
                  ),
                ),


              ],
            ),
          ),
        ),

      ],
    );
  }
}
