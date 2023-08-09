import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/Components/CustomButtonForm.dart';

class EditEmployeeForm extends StatefulWidget {

  EmployeeModel employee;

  EditEmployeeForm({ Key? key,  required this.employee}) : super(key: key);

  @override
  State<EditEmployeeForm> createState() => _EditEmployeeFormState();
}

class _EditEmployeeFormState extends State<EditEmployeeForm> {

  final employeeRepo = Get.put(EmployeeRepository());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  Uint8List? _selectedImageBytes;
  String? _selectedDepartment;
  PlatformFile? pickedFile;
  bool isLoading = false;
  late EmployeeModel editedEmployee;


  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void ClearFormField(){
    setState(() {
      isLoading = false;
      _selectedDepartment = null;
    });
    _emailController.clear();
    _fullNameController.clear();
  }

  void EditEmployee(BuildContext context) async{
    if (_formKey.currentState!.validate()) {
      // All fields are valitade
      //...... Do something :
      setState(() {
        isLoading = true;
      });

      // admin have picked a photo
      if (pickedFile!.bytes! != null){
        //delete old photo from firebase storage if it's not null
        if (widget.employee.photoName != null)
          await employeeRepo.deletePicture(widget.employee.photoName!);
        //upload the new image to firebase storage
        List<String> pictureData = await employeeRepo.uploadPicture(pickedFile!.bytes!);
        // Save changes
        editedEmployee = EmployeeModel(
          id: widget.employee.id,
          fullName: _fullNameController.text,
          email: _emailController.text,
          department: _selectedDepartment,
          photoURL : pictureData[0],
          photoName: pictureData[1],
        );

      }

      // admin haven't picked a new photo
      else {

        // if employee have already a saved photo
          if (widget.employee.photoName != null ){
            editedEmployee = EmployeeModel(
              id: widget.employee.id,
              fullName: _fullNameController.text,
              email: _emailController.text,
              department: _selectedDepartment,
              photoName: widget.employee.photoName,

            );
          }

        //if employee don't have a saved photo
          else{
            editedEmployee = EmployeeModel(
              id: widget.employee.id,
              fullName: _fullNameController.text,
              email: _emailController.text,
            );
          }

      }


      // Save employee
      Future<bool> isEmployeeEdited=  employeeRepo.editEmployee(editedEmployee);
      // if employee was added successflly
      if (await isEmployeeEdited)
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
  }

  @override
  Widget build(BuildContext context) {

    _emailController.text = widget.employee.email;
    _fullNameController.text  = widget.employee.fullName;
    _selectedDepartment = widget.employee.department;

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
                                : widget.employee.photoURL != null 
                                  ? Image.network(widget.employee.photoURL!, fit: BoxFit.cover,)
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: DropdownButtonFormField<String>(
                          value: _selectedDepartment,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDepartment = newValue!;
                            });
                          },
                          items: ['HR', 'Finance', 'IT', 'Marketing']
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
                      ),



                    ]

                ),

                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: CustomButtonForm(
                    context,
                    BtnAction: () { 
                      EditEmployee(context);
                      },
                    textBtn: 'Save',
                    icon: Icons.save,
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
