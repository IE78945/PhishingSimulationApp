import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/models/campaign_model.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/models/simulation_model.dart';
import 'package:phishing_simulation_app/models/traking_data_model.dart';
import 'package:phishing_simulation_app/repository/campaign_repository.dart';
import 'package:phishing_simulation_app/repository/simulation_repository.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/CeateCampaign/view_email.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/CeateCampaign/view_web_site.dart';
import 'package:phishing_simulation_app/screens/Components/CustomButtonForm.dart';
import 'package:intl/intl.dart';
import 'package:phishing_simulation_app/screens/Components/dialog_box.dart';


class employeeCampaignDetailsForm extends StatefulWidget {
  const employeeCampaignDetailsForm({Key? key, this.data,}) : super(key: key);
  final EmployeeModel? data;

  @override
  State<employeeCampaignDetailsForm> createState() => _campaignDetailsFormState();
}

class _campaignDetailsFormState extends State<employeeCampaignDetailsForm> {
  Color buttonColor = Colors.grey;
  late SimulationModel simulationModel;
  List<CampaignModel> CampaignsList = [];
  List<TrakingDataModel> TrakingDetails = [];

  final _SimulationRepo = Get.put(SimulationRepository());
  final campaignRepo = Get.put(CampaignRepository());

  @override
  void initState() {
    super.initState();
    getTableData();
  }


  Future<void> getTableData() async {
    List<CampaignModel> result = await campaignRepo.getCampaignsForEmployee(widget.data!.id!);

    setState(() {
      CampaignsList = result;
    });

    for (var campaign in CampaignsList){
      List<TrakingDataModel> result = await campaignRepo.getTrackingDataForCampaign(campaign.id!,widget.data!.id!);
      List<SimulationModel> fetchedSimulations = await _SimulationRepo.getSimulationByNameList(campaign.SimulationName);
      SimulationModel simulationModel = fetchedSimulations[0];
      for(var trakingDataModel in result){
        setState(() {
          trakingDataModel.CampaignName = campaign.CampaignName;
          trakingDataModel.simulation = simulationModel;
          TrakingDetails.add(trakingDataModel);
        });
      }
    }


  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
             children: [

               //Campaigns details
               const Text(
                 "Campaigns details",
                 style: TextFieldTitle,
               ),

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:DataTable(
                  columns: [
                    DataColumn(label: Text("Campaign name")),
                    DataColumn(label: Text("View email")),
                    DataColumn(label: Text("View web site")),
                    DataColumn(label: Text("Email opened")),
                    DataColumn(label: Text("Time")),
                    DataColumn(label: Text("Link clicked")),
                    DataColumn(label: Text("Time")),
                  ],
                  rows: TrakingDetails.map((detail) {
                    return DataRow(cells: [
                      DataCell(Text(detail.CampaignName!)),
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
                            form: ViewEmail(simulation: detail.simulation!),
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
                            form: ViewWebSite(simulation: detail.simulation!),
                            widthFactor: 0.9,
                            heightFactor: 0.9,
                          );
                        },
                      )),

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
