import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/models/campaign_model.dart';
import 'package:phishing_simulation_app/models/simulation_model.dart';
import 'package:phishing_simulation_app/models/traking_data_model.dart';
import 'package:phishing_simulation_app/repository/campaign_repository.dart';
import 'package:phishing_simulation_app/repository/simulation_repository.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/Campagne/view_email.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/Campagne/view_web_site.dart';
import 'package:phishing_simulation_app/screens/Components/CustomButtonForm.dart';
import 'package:intl/intl.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';


class campaignDetailsForm extends StatefulWidget {
  const campaignDetailsForm({Key? key, this.data,}) : super(key: key);
  final CampaignModel? data;

  @override
  State<campaignDetailsForm> createState() => _campaignDetailsFormState();
}

class _campaignDetailsFormState extends State<campaignDetailsForm> {
  Color buttonColor = Colors.grey;
  late SimulationModel simulationModel;
  List<TrakingDataModel> TrakingDetails = [];

  final _SimulationRepo = Get.put(SimulationRepository());
  final campaignRepo = Get.put(CampaignRepository());

  @override
  void initState() {
    super.initState();
    getSimulation();
    getTableData();
  }

  Future<void> getSimulation() async {
    print("***************************"+widget.data!.SimulationName);
    var result = await _SimulationRepo.getSimulationByNameList(widget.data!.SimulationName);
    setState(() {
      simulationModel = result[0] ;
    });
  }

  Future<void> getTableData() async {
    var result = await campaignRepo.getAllTrakingDetailsList(widget.data!.id!);
    setState(() {
      TrakingDetails = result ;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               //Simulation details
               const Text(
                 "Simulation details",
                 style: TextFieldTitle,
               ),
               Padding(
                 padding: const EdgeInsets.only(top: 8, bottom: 16),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     MouseRegion(
                       onHover: (event) {
                         // Handle hover state
                         setState(() {
                           buttonColor = Colors.blue; // Set the icon color
                         });
                       },
                       onExit: (event) {
                         // Handle exit state
                         setState(() {
                           buttonColor = Colors.grey; // Reset icon color
                         });
                       },
                       child: Container(
                         width: MediaQuery.of(context).size.width * 0.1,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                           border: Border.all(color: buttonColor),
                         ),
                         child: TextButton(
                           onPressed: () {
                             // Implement your action here
                             showCustomDialog(
                               context,
                               onValue: (_) {},
                               title: 'Email',
                               form: ViewEmail(simulation: simulationModel,),
                               widthFactor: 0.9,
                               heightFactor: 0.9,
                             );
                           },
                           child: Text(
                             'View Email',
                             style: TextStyle(
                               color: buttonColor,
                             ),
                           ),
                         ),
                       ),
                     ),
                     MouseRegion(
                       onHover: (event) {
                         // Handle hover state
                         setState(() {
                           buttonColor = Colors.blue; // Set the icon color
                         });
                       },
                       onExit: (event) {
                         // Handle exit state
                         setState(() {
                           buttonColor = Colors.grey; // Reset icon color
                         });
                       },
                       child: Container(
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                           border: Border.all(color: buttonColor),
                         ),
                         child: TextButton(
                           onPressed: () {
                             // Implement your action here

                             showCustomDialog(
                               context,
                               onValue: (_) {},
                               title: 'Email',
                               form: ViewWebSite(simulation: simulationModel,),
                               widthFactor: 0.9,
                               heightFactor: 0.9,
                             );
                           },
                           child: Text(
                             'View Web Site',
                             style: TextStyle(
                               color: buttonColor,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 )
               ),
               //Employees details
               const Text(
                 "Employees details",
                 style: TextFieldTitle,
               ),

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:DataTable(
                  columns: [
                    DataColumn(label: Text("Employee Name")),
                    DataColumn(label: Text("Department")),
                    DataColumn(label: Text("Email opened")),
                    DataColumn(label: Text("Time")),
                    DataColumn(label: Text("Link clicked?")),
                    DataColumn(label: Text("Time")),
                  ],
                  rows: TrakingDetails.map((detail) {
                    return DataRow(cells: [
                      DataCell(Text(detail.EmployeeName)),
                      DataCell(Text(detail.departmentName)),
                      DataCell(Icon(
                        detail.isEmailOpened? CupertinoIcons.check_mark_circled_solid : Icons.cancel_rounded,
                        color: detail.isEmailOpened? Colors.green : Colors.red,
                      ),),
                      DataCell(Text(detail.isEmailOpened? DateFormat('yyyy-MM-dd HH:mm:ss').format(detail.EmailTimeOpening.toDate()):"-",)),
                      DataCell(Icon(
                        detail.isWebSiteLinkClicked? CupertinoIcons.check_mark_circled_solid : Icons.cancel_rounded,
                        color: detail.isWebSiteLinkClicked? Colors.green : Colors.red,
                      ),),
                      DataCell(Text(detail.isWebSiteLinkClicked? DateFormat('yyyy-MM-dd HH:mm:ss').format(detail.WebSiteLinkClickTime.toDate()):"-",)),



                    ]);
                  }).toList(),
                ),)
              ),

               //Button
               Padding(
                 padding: const EdgeInsets.only(top: 8, bottom: 24),
                 child: CustomButtonForm(
                   context,
                   BtnAction: () {
                     //
                     Navigator.of(context).pop();
                   },
                   textBtn: 'OK',
                   icon: CupertinoIcons.checkmark_alt,
                   widthBtn: double.maxFinite,
                   topLeftRadius: 25,
                   isLoading: false,
                 ),
               ),

             ],
            ),
        ),

      ],
    );
  }
}
