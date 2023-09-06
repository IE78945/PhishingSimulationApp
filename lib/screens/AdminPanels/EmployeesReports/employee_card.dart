import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/models/campaign_model.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/campaign_repository.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/CampaignReports/report_dialog_box.dart';

import 'employee_report_dialog_box.dart';

class EmployeeCard extends StatefulWidget {
  const EmployeeCard({
    Key? key,
    this.data,
  }) : super(key: key);


  final EmployeeModel? data;


  @override
  State<EmployeeCard> createState() => _CampaignCardState();
}

class _CampaignCardState extends State<EmployeeCard> {

  final campaignRepo = Get.put(CampaignRepository());
  late int OpenedEmailCount, ClickWebSiteLinkCount , CampaignTotalNumberForEachEmployee = 0;
  double linkClickRate = 0 , emailOpenRate = 0; // pourcentages
  Color buttonColor = Colors.grey;
  bool isShowCampaignDetailsDialog =false ;

  @override
  void initState() {
    super.initState();
    getCampaignData();
  }

  Future<void> getCampaignData() async {
    try {
      var result1 = await campaignRepo.getCampaignTotalNumberForEachEmployee(widget.data!.id!);
      var result2 = await campaignRepo.getOpenEmailsCountForEachEmployee(widget.data!.id!);
      var result3 = await campaignRepo.getClickLinkCountForEachEmployee(widget.data!.id!);

      setState(() {
        CampaignTotalNumberForEachEmployee = result1;
        OpenedEmailCount = result2;
        ClickWebSiteLinkCount = result3 ;
      });

      CalculatePourcentages();

    } catch (e) {
      print("Error fetching campaign data: $e");
    }
  }

  Future<void> CalculatePourcentages() async {

    setState(() {

      if (ClickWebSiteLinkCount != 0)
        linkClickRate = (ClickWebSiteLinkCount/CampaignTotalNumberForEachEmployee)*100 ;
      else
        linkClickRate = 0 ;

      if(OpenedEmailCount!=0)
        emailOpenRate = (OpenedEmailCount/CampaignTotalNumberForEachEmployee)*100;
      else
        emailOpenRate = 0 ;

      // Format linkClickRate and emailOpenRate to have 2 decimal places
      linkClickRate = double.parse(linkClickRate.toStringAsFixed(2));
      emailOpenRate = double.parse(emailOpenRate.toStringAsFixed(2));
    });

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
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment. center,
                  children: [
                    AspectRatio(
                      aspectRatio: 0.7/0.7,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: widget.data!.photoURL != null
                            ? ClipOval(child: Image.network( widget.data!.photoURL!,fit: BoxFit.cover,)) // Use Image.network for loading image from URL
                            : Center(child: Icon(Icons.person,size: 80,)), // Fallback icon when photoURL is null
                      ),
                    ),
                    Text(
                      widget.data!.fullName,
                      style:  TextStyle(fontSize: 34, fontFamily: "Poppins", fontWeight: FontWeight.w600,),
                    )
                  ],
                )
            ),
            Expanded(
              child:  Column(
              children: [
                Text(CampaignTotalNumberForEachEmployee.toString(),style:  TextStyle(fontSize: 30, fontFamily: "GreatVibes", fontWeight: FontWeight.w400,),),
                Text("Campaigns",style : TextStyle(fontSize: 16, fontFamily: "Poppins", fontWeight: FontWeight.w200,),)
              ],
            ),),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(emailOpenRate.toString(),style:  TextStyle(fontSize: 30, fontFamily: "GreatVibes", fontWeight: FontWeight.w400,),),
                      Text("Opened emails",style : TextStyle(fontSize: 16, fontFamily: "Poppins", fontWeight: FontWeight.w200,),)
                    ],
                  ),
                  Column(
                    children: [
                      Text(linkClickRate.toString(),style:  TextStyle(fontSize: 30, fontFamily: "GreatVibes", fontWeight: FontWeight.w400,),),
                      Text("Link clicked",style : TextStyle(fontSize: 16, fontFamily: "Poppins", fontWeight: FontWeight.w200,),)
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(emailOpenRate.toString()+" %",style:  TextStyle(fontSize: 30, fontFamily: "GreatVibes", fontWeight: FontWeight.w400,),),
                      Text("Open Rate",style : TextStyle(fontSize: 16, fontFamily: "Poppins", fontWeight: FontWeight.w200,),)
                    ],
                  ),
                  Column(
                    children: [
                      Text(linkClickRate.toString()+" %",style:  TextStyle(fontSize: 30, fontFamily: "GreatVibes", fontWeight: FontWeight.w400,),),
                      Text("Click Rate",style : TextStyle(fontSize: 16, fontFamily: "Poppins", fontWeight: FontWeight.w200,),)
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                        border: Border.all(color: buttonColor),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Implement your action here
                          setState(() {
                            isShowCampaignDetailsDialog = true;
                          });
                          showEmployeesReportsDetailsDialog(
                            context,
                            data: widget.data!,
                            onValue: (_) {
                              setState(() {
                                isShowCampaignDetailsDialog = false;
                              });
                            },

                          );
                        },
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            color: buttonColor,
                          ),
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            )

          ],
        )
    );

  }
}
