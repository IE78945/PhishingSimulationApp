import 'dart:convert';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/models/department_model.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/clonnedWebSite_repository.dart';
import 'package:phishing_simulation_app/repository/department_repository.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/screens/Components/CostumButtonForInterfaces.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';


class CustomSimulation extends StatefulWidget {
  const CustomSimulation({Key? key}) : super(key: key);

  @override
  State<CustomSimulation> createState() => _CustomSimulationState();
}

class _CustomSimulationState extends State<CustomSimulation> {
  TextEditingController _WebPageController = TextEditingController();
  bool isLoading = false, isClonningEnd = false, isClonningResult = false ;
  String clonedHtml = ''; // Store the fetched and saved HTML content
  final WebSiteRepo = Get.put(ClonnedWebSitesRepository());
  final departmentRepo = Get.put(DepartmentRepository());
  final EmployeeRepo = Get.put(EmployeeRepository());
  List<DepartmentModel> departments = [];
  List<DepartmentModel> SelectedDepartments = [];
  List<EmployeeModel> employees = [];
  List<EmployeeModel> SelectedEmployees = [];
  @override
  void initState() {
    super.initState();
    fetchDepartmentsFromFirebase();
    fetchEmployeesFromFirebase();
  }

  Future<void> fetchDepartmentsFromFirebase() async {
    List<DepartmentModel> fetchedDepartments = await departmentRepo.getAllDepartmentsList();
    setState(() {
      departments = fetchedDepartments;
    });
  }

  Future<void> fetchEmployeesFromFirebase() async {
    List<EmployeeModel> fetchedEmployees = (await EmployeeRepo.getAllEmployeeList());
    setState(() {
      employees = fetchedEmployees;
    });
  }



  Future<void> CloneWebPage(BuildContext context) async {
    String WebSiteURL = _WebPageController.text;
    final url = Uri.parse('http://localhost:3000/proxy?url=$WebSiteURL');

    // show loading sign
    setState(() {
      isLoading = true;
    });

    // get website code from proxy
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // web site clonned by proxy server successfully

      clonedHtml = response.body;
      // Save clonned page code to firebase storage
      String DownloadFileURL = await WebSiteRepo.UploadHtmlFile(WebSiteURL,clonedHtml);
      if (DownloadFileURL != ""){
        // html file has been saved succesfuly
        // Save DowloadFileURL in firestore

        // dispaly  a success mark instead of the button
        setState(() {
          isClonningEnd = true; isClonningResult = true;
        });
      }

      else {
        //  there has been an error and the app couldn't store the file in storage

        // display a failure mark
        setState(() {
          isClonningEnd = true; isClonningResult = false ;
        });
      }



    }
    else
      {
        // something went wrong with the proxy server : connexion , ....

        print("Error: ${response.statusCode} - ${response.body}");
        // display a failure mark
        setState(() {
          isClonningEnd = true; isClonningResult = false ;
        });
      }


  }
  @override
  Widget build(BuildContext context) {
    var _multiSelectKey;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              /*
              //mini title
              Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(width: 2, color: Colors.black)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Web Site",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:  Colors.black,
                    ),
                  ),
                ),
              ),
          //Web page to clone URL

            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                              controller: _WebPageController,
                              decoration: InputDecoration(
                                hintText: 'https://www.exemple.com',
                                border: InputBorder.none,
                              ),
                            ),
                    ),
                        ),
                ),
                SizedBox(width: 5),

                //Button
                isClonningEnd?
                Expanded(
                    flex: 1,
                    child: isClonningResult?
                    Icon(Icons.check_circle_outline,color: Colors.green,)
                        :Icon(Icons.cancel_outlined,color: Colors.red,),
                )
                :Expanded(
                  flex: 1,
                  child:  isLoading ?
                  CircularProgressIndicator(color: Colors.blue,)
                  :CustomButtonForInterfaces(
                    context,
                    BtnAction: () {
                      CloneWebPage(context);
                    },
                    textBtn: 'Clone',
                    icon: Icon(Icons.copy_all_outlined),
                    paddingsize: 12.0,
                  ),
                )


              ],
            ),


            // display web page
              Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: clonedHtml,
                  ),
                ),
            ),
               */

              //mini title : departments & employees
              Container(
                margin: EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(width: 2, color: Colors.black)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Departments and emplyees",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:  Colors.black,
                    ),
                  ),
                ),
              ),
              // department selection
              MultiSelectDialogField(
                      items: departments.map((department) {
                        return MultiSelectItem<DepartmentModel>(
                          department,
                          department.departmentName,
                        );
                      }).toList(),
                      title: Text("Departments"),
                      selectedColor: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      buttonIcon: Icon(
                        CupertinoIcons.building_2_fill,
                        color: Colors.blue,
                      ),
                      buttonText: Text(
                        "Select department",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16,
                        ),
                      ),
                      onConfirm: (results) {
                        SelectedDepartments = results as List<DepartmentModel>;
                      },
                      searchable: true,
                      dialogHeight: MediaQuery.of(context).size.width* 0.7,
                      dialogWidth: MediaQuery.of(context).size.width* 0.5,
                      chipDisplay: MultiSelectChipDisplay(
                        items: SelectedDepartments.map((e) => MultiSelectItem(e, e.departmentName as String)).toList(),
                        onTap: (value) {
                          setState(() {
                            SelectedDepartments.remove(value);
                          });
                        },
                      ),
                    ),
              //Employee selection
              SizedBox(height: 12.0,),
              MultiSelectDialogField(
                items: employees.map((employee) {
                  return MultiSelectItem<EmployeeModel>(
                    employee,
                    '${employee.fullName} - ${employee.department} department',
                  );
                }).toList(),
                title: Text("Employees"),
                selectedColor: Colors.blue,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                buttonIcon: Icon(
                  CupertinoIcons.person_2_fill,
                  color: Colors.blue,
                ),
                buttonText: Text(
                  "Select employees",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  //_selectedAnimals = results;
                  SelectedEmployees = results as List<EmployeeModel>;
                },
                searchable: true,
                dialogHeight: MediaQuery.of(context).size.width* 0.7,
                dialogWidth: MediaQuery.of(context).size.width* 0.5,
                chipDisplay: MultiSelectChipDisplay(
                  items: SelectedEmployees.map((e) => MultiSelectItem(e, e.fullName as String)).toList(),
                  onTap: (value) {
                    setState(() {
                      SelectedEmployees.remove(value);
                    });
                  },
                ),
              ),

              //mini title : emails templates
              Container(
                margin: EdgeInsets.only(bottom: 12.0, top: 12.0),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(width: 2, color: Colors.black)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "emails templates",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:  Colors.black,
                    ),
                  ),
                ),
              ),




        ]),
      ),
    );
  }
}
