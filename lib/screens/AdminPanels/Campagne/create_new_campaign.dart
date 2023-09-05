import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:phishing_simulation_app/models/campaign_model.dart';
import 'package:phishing_simulation_app/models/department_model.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/models/simulation_model.dart';
import 'package:phishing_simulation_app/models/traking_data_model.dart';
import 'package:phishing_simulation_app/repository/campaign_repository.dart';
import 'package:phishing_simulation_app/repository/department_repository.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';
import 'package:phishing_simulation_app/repository/simulation_repository.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/Campagne/view_email.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/Campagne/view_web_site.dart';
import 'package:phishing_simulation_app/screens/Components/CustomButtonForm.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:html';


class CreateNewCampagne extends StatefulWidget {
  const CreateNewCampagne({Key? key}) : super(key: key);

  @override
  State<CreateNewCampagne> createState() => _CreateNewCampagneState();
}

class _CreateNewCampagneState extends State<CreateNewCampagne> {
  // form
  final GlobalKey<FormState> _formKey_createcampagne = GlobalKey<FormState>();

  // Campaign variables
  TextEditingController _campaignNameController = TextEditingController();
  final campaignRepo = Get.put(CampaignRepository());

  // selecting department and employees variables
  final departmentRepo = Get.put(DepartmentRepository());
  final EmployeeRepo = Get.put(EmployeeRepository());
  List<DepartmentModel> departments = [];
  List<DepartmentModel> SelectedDepartments = [];
  List<EmployeeModel> employees = [];
  List<EmployeeModel> SelectedEmployees = [];

  // simulations variables
  final _SimulationRepo = Get.put(SimulationRepository());
  List<SimulationModel> simulations = []; // List to store fetched simulations
  TextEditingController searchController = TextEditingController();
  SimulationModel initSimulation = SimulationModel(
      SimulationName: "",
      EmailTemplateFileDownloadUrl: "",
      WebSiteFileDownloadUrl: "",
      WebSiteURL: "",
      Object: "",
      SenderEmail: "",
      SenderName: ""
  ) ;
  late SimulationModel selectedSimulation;

  //button varables
  bool isLoadingForm = false;

  //selected items
  String SelectedEmailCode ="";

  @override
  void initState() {
    super.initState();
    fetchDepartmentsFromFirebase();
    fetchEmployeesFromFirebase();
    fetchSimulations(); // Fetch simulations when the screen loads
    //init selected simulation
    setState(() {
      selectedSimulation = initSimulation;
    });
  }

  Future<void> fetchDepartmentsFromFirebase() async {
    List<DepartmentModel> fetchedDepartments = (await departmentRepo.getAllDepartmentsList());
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

  Future<void> fetchSimulations() async {
    // Fetch your simulations from storage (e.g., Firebase Storage)
    List<SimulationModel> fetchedSimulations = await _SimulationRepo.getAllSimulationList();

    // Update the simulations list with the fetched data
    setState(() {
      simulations = fetchedSimulations;
    });
  }

  Future<void> fetchEmail() async {
    // Fetch the content of the file using a network request
    final response = await http.get(Uri.parse(selectedSimulation.EmailTemplateFileDownloadUrl));
    // Update the simulations list with the fetched data
    if (response.statusCode == 200) {
      // Return the content of the file as a string
      setState(() {
        SelectedEmailCode = response.body;
      });
    } else {
      // Handle error
      throw Exception('Failed to read string from Firebase Storage');
    }
  }
  Future<void> startCampagne() async {


    // enable loading button
    setState(() {
      isLoadingForm= true;
    });
    if (_formKey_createcampagne.currentState!.validate()) {
      if (selectedSimulation!= initSimulation && (SelectedDepartments != [] || SelectedEmployees != []))
      {
        // get all selected employees
        for (var department in SelectedDepartments){
          SelectedEmployees.addAll(await EmployeeRepo.getEmployeesByDepartment(department.departmentName));
        }


        //Store campagne details to firebase firestore
          // create campagne model and save it to firestore
          CampaignModel campagne = CampaignModel(
            CampaignName: _campaignNameController.text,
            SimulationName: selectedSimulation.SimulationName,
            EmployeeTotalNumber: SelectedEmployees.length,
          );
          // store model in firestore
          String campaignID = await campaignRepo.createCampaign(campagne);

        // fetch email in selected simulation
        await fetchEmail();

        // treat every employee email
        for (var employee in SelectedEmployees){
          String? employeeID = employee.id;
          String webSiteURL = selectedSimulation.WebSiteURL;

            var senderEmail = selectedSimulation.SenderEmail;
            var senderName = selectedSimulation.SenderName;
            var recipient = employee.email;
            var subject = selectedSimulation.Object;
            var html = SelectedEmailCode;

          //Store tracking informations in firestore for each employee
            // Create a Firestore Timestamp with all zeros for date and time components
            Timestamp customTimestamp = Timestamp.fromMillisecondsSinceEpoch(0);
            //CreateModel
            TrakingDataModel model = new TrakingDataModel(
                isEmailOpened: false,
                EmailTimeOpening: customTimestamp,
                isWebSiteLinkClicked: false,
                WebSiteLinkClickTime: customTimestamp,
                EmployeeName: employee.fullName,
                departmentName: employee.department!,
            );
            //Store informations
            await campaignRepo.addTrakingDetailsForEmployee(campaignID,model,employee.id);

          //Replace the placeholders in email
          print('Before replacing: $SelectedEmailCode');
          SelectedEmailCode = SelectedEmailCode.replaceAll('[EMPLOYEE_NAME]', employee.fullName);
          SelectedEmailCode = SelectedEmailCode.replaceAll('[DEPARTMENT_NAME]', employee.department!);
          print('After replacing: $SelectedEmailCode');

          //Replace the website url in each email
          // Find the position of the existing anchor element
          int startIndex = SelectedEmailCode.indexOf('<a href="');
          int endIndex = SelectedEmailCode.indexOf('</a>', startIndex);

          if (startIndex != -1 && endIndex != -1) {
            // Extract the existing anchor element
            String existingAnchor = SelectedEmailCode.substring(startIndex, endIndex + 4);

            // Construct the new anchor element
            String newAnchor = '<a href="http://20.199.67.152:3001/page?campaignID=$campaignID&pageURL=$webSiteURL&employeeID=$employeeID">http://www.hat-websecurity.com/</a>';

            // Replace the existing anchor with the new one
            SelectedEmailCode = SelectedEmailCode.replaceFirst(existingAnchor, newAnchor);
          }



          print('After replacing link : $SelectedEmailCode');

            //Add the traking pixel in the email (to calculate open rate later)
              // Locate the position of </body> in the HTML content
              int bodyIndex = SelectedEmailCode.indexOf('</body>');

              // Check if </body> was found in the HTML content
              if (bodyIndex != -1) {
                // Construct the tracking pixel HTML
                String trackingPixelHtml =
                    '<img src="http://20.199.67.152:3001/trackingPixel?campaignID=$campaignID&employeeID=$employeeID" width="1" height="1" alt="" style="display:none" />';

                // Insert the tracking pixel HTML before </body>
                SelectedEmailCode =
                    SelectedEmailCode.substring(0, bodyIndex) +
                        trackingPixelHtml +
                        SelectedEmailCode.substring(bodyIndex);
              }
              else {
                SelectedEmailCode += '<img src="http://20.199.67.152:3001/trackingPixel?campaignID=$campaignID&employeeID=$employeeID" width="1" height="1" alt="" style="display:none" />';

              }
              print('After adding invisible pixel : $SelectedEmailCode');

                // send email through server
          // Define the request body as a map with the necessary data
          final Map<String, String> body = {
            'SenderName': senderName,
            'SenderEmail': senderEmail,
            'recipients': recipient,
            'subject': subject,
            'html': SelectedEmailCode,
          };
           var encodedBody = json.encode(body) ;

                final url = Uri.parse('http://localhost:3000/send-email');
                final response = await http.post(url, headers: {"Content-Type": "application/json"},body: encodedBody);
                if (response.statusCode == 200) {
                  // email have been sent
                  print ("ok");
                }
                else {
                  // something went wrong with the proxy server : connexion , ....
                  print("Error: ${response.statusCode} - ${response.body}");
                  Get.snackbar(
                    "Error",
                    "Something went wrong please retry later",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.white.withOpacity(0.7),
                    colorText: Colors.red,
                  );
                }


            }



        //disable loading button
        setState(() {
          isLoadingForm= false;
        });
      }
      else {
        Get.snackbar(
          "Error",
          "Please make sure you selected a simulation and a department or employees",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.red,
        );
        //disable loading button
        setState(() {
          isLoadingForm= false;
        });
      }
    }
    else {
      //disable loading button
      setState(() {
        isLoadingForm= false;
      });
      Get.snackbar(
        "Error",
        "Please make sure you selected a simulation.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.red,
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        height: MediaQuery.of(context).size.height ,
    width:MediaQuery.of(context).size.width  ,
    child: SafeArea(
    child: Padding(
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Text(
    "New Campaign",
    style: TextStyle(
    fontSize: 34,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w600,
    ),

    ),
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02),
          child: Form(
            key: _formKey_createcampagne,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //mini title : CampagneName
                Container(
                  margin: EdgeInsets.only(top: 12.0),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(width: 2, color: Colors.black)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Campagne Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.02),
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
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Campagne Name',
                            border: InputBorder.none,
                          ),
                          controller: _campaignNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field should not be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                    )),

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

                    setState(() {
                      SelectedDepartments = results as List<DepartmentModel>;
                    });

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
                  validator: (value) {
                    if (SelectedDepartments.isEmpty && SelectedEmployees.isEmpty ) {
                      return 'Please select at least one department or one employee.';
                    }
                    return null; // Return null if the selection is valid.
                  },
                ),

                //Employee selection
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                MultiSelectDialogField(
                  backgroundColor: Colors.white.withOpacity(0.95),
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
                    print(SelectedEmployees);
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
                  validator: (value) {
                    if (SelectedDepartments.isEmpty && SelectedEmployees.isEmpty) {
                      return 'Please select at least one employee orone department.';
                    }
                    return null; // Return null if the selection is valid.
                  },
                ),

                //mini title : simulations models
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(width: 2, color: Colors.black)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Simulation models",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:  Colors.black,
                      ),
                    ),
                  ),
                ),


                // Simulation table
                if (simulations.isNotEmpty)
                  Padding(
                    padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text("Select")),
                          DataColumn(label: Text("Simulation Name")),
                          DataColumn(label: Text("Sender Name")),
                          DataColumn(label: Text("Object")),
                          DataColumn(label: Text("Sender email address")),
                          DataColumn(label: Text("View Email")),
                          DataColumn(label: Text("View Website")),
                        ],
                        rows: simulations.map((simulation) {
                          return DataRow(cells: [
                            DataCell(
                              Radio<bool>(
                                value:  selectedSimulation == simulation,
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSimulation = simulation ;
                                  });
                                },
                              ),
                            ),
                            DataCell(Text(simulation.SimulationName)),
                            DataCell(Text(simulation.SenderName)),
                            DataCell(Text(simulation.Object)),
                            DataCell(Text(simulation.SenderEmail)),
                            DataCell(IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                showCustomDialog(
                                  context,
                                  onValue: (_) {},
                                  title: 'Email',
                                  form: ViewEmail(simulation: simulation),
                                  widthFactor: 0.9,
                                  heightFactor: 0.9,
                                );
                              },
                            )),
                            DataCell(IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                showCustomDialog(
                                  context,
                                  onValue: (_) {},
                                  title: 'WebSite',
                                  form: ViewWebSite(simulation: simulation),
                                  widthFactor: 0.9,
                                  heightFactor: 0.9,
                                );
                              },
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),



                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: CustomButtonForm(
                    context,
                    BtnAction: () {
                      startCampagne();
                    },
                    textBtn: 'Save',
                    icon: Icons.save,
                    widthBtn: double.maxFinite,
                    topLeftRadius: 25,
                    isLoading: isLoadingForm,
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    ])))));


  }
}



