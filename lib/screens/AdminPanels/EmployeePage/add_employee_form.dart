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

class AddEmployeeForm extends StatefulWidget {
  const AddEmployeeForm({Key? key}) : super(key: key);

  @override
  State<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {

  final employeeRepo = Get.put(EmployeeRepository());
  final departmentRepo = Get.put(DepartmentRepository());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  Uint8List? _selectedImageBytes;
  String? _selectedDepartment;
  PlatformFile? pickedFile;
  bool isLoading = false;
  List<String> DepartmentListNames =[] ;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> fetchDepartments() async {
    Stream<List<DepartmentModel>> departmentsStream = departmentRepo.getAllDepartments();

    List<DepartmentModel> departmentsList = await departmentsStream.first;
    DepartmentListNames = departmentsList.map((department) => department.departmentName).toList();

    print(DepartmentListNames);
  }

  void ClearFormField(){
    setState(() {
      isLoading = false;
      _selectedImageBytes = null;
      _selectedDepartment = null;
    });
    _emailController.clear();
    _fullNameController.clear();
  }

  void AddNewEmployee(BuildContext context) async{
    if (_formKey.currentState!.validate()) {
      // All fields are valitade
      //...... Do something : check is user already exists if not add to database
      setState(() {
        isLoading = true;
      });


      //Store employee picture if it's not null
      if (pickedFile!= null){
        List<String> pictureData = await employeeRepo.uploadPicture(pickedFile!.bytes!);
        print("image non null");
        // image stored, Store employee
        if (pictureData != ""){
          final employee = EmployeeModel(
            fullName: _fullNameController.text,
            email: _emailController.text,
            department: _selectedDepartment,
            photoURL : pictureData[0] ,
            photoName: pictureData[1],
          );

          Future<bool> isEmployeeAdded =  employeeRepo.AddEmployee(employee);
          // if employee was added successflly
          if (await isEmployeeAdded)
            ClearFormField();
          else{
            //I should delete the image .....

            setState(() {
              isLoading = false;
            });
          }

        }
        //else image is not stored , user should retry
        else {
          setState(() {
            isLoading = false;
          });
          Get.snackbar(
            "Error",
            "Something went Wrong; Please retry later",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white.withOpacity(0.7),
            colorText: Colors.red,
          );
        }
      }

      // Admin didn't enter an image

      final employee = EmployeeModel(
        fullName: _fullNameController.text,
        email: _emailController.text,
        department: _selectedDepartment,
      );

      Future<bool> isEmployeeAdded =  employeeRepo.AddEmployee(employee);
      // if employee was added successflly
      if (await isEmployeeAdded){
        ClearFormField();
        Navigator.of(context).pop();
      }

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

                //upload Image
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );

                    if (result != null) {
                      setState(() {
                        _selectedImageBytes = result.files.single.bytes;
                        pickedFile = result.files.first;
                      });
                    }
                  },
                  child: Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _selectedImageBytes != null
                                ? Image.memory(
                              _selectedImageBytes!,
                              fit: BoxFit.cover,
                            )
                                : Container(
                                color: Colors.grey,
                                child: Icon(Icons.person, size: 40,color: MyWhite,)
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: MyLightBlue,
                              ),
                              child: const Icon(
                                CupertinoIcons.camera_fill,
                                color: MyWhite,
                                size: 20,
                              ),
                            )
                        )
                      ]
                  ),
                ),


                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      //Full Name
                      const Text(
                        "Full name",
                        style: TextFieldTitle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: TextFormField(
                          controller: _fullNameController,
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

                      //Email
                      const Text(
                        "Email",
                        style: TextFieldTitle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide( width: 3, color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                              child: Icon(Icons.email_rounded),
                            ),
                          ),
                        ),
                      ),

                      //Department
                      const Text(
                        "Department",
                        style: TextFieldTitle,
                      ),
                      FutureBuilder<void>(
                        future: fetchDepartments(),
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 16),
                              child: DropdownButtonFormField<String>(
                                value: _selectedDepartment,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedDepartment = newValue!;
                                  });
                                },
                                items: DepartmentListNames
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration:  InputDecoration(
                                  border: OutlineInputBorder(borderSide: BorderSide( width: 3, color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                ),
                                validator: (value) {
                                  // Since the field is not required, no need to validate it
                                  return null;
                                },
                              ),
                            );
                          } else {
                            // Display a loading indicator or placeholder if the snapshot is not done yet
                            return CircularProgressIndicator();
                          }
                        },
                      )



                    ]

                ),

                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: CustomButtonForm(
                    context,
                    BtnAction: () { AddNewEmployee(context); },
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
