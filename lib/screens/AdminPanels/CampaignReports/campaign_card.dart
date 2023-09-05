import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/models/campaign_model.dart';
import 'package:phishing_simulation_app/repository/campaign_repository.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/CampaignReports/report_dialog_box.dart';

class CampaignCard extends StatefulWidget {
  const CampaignCard({
    Key? key,
    this.data,
  }) : super(key: key);


  final CampaignModel? data;


  @override
  State<CampaignCard> createState() => _CampaignCardState();
}

class _CampaignCardState extends State<CampaignCard> {

  final campaignRepo = Get.put(CampaignRepository());
  late int OpenedEmailCount, ClickWebSiteLinkCount , EmployeeTotalNumber;
  double linkClickRate = 0 , emailOpenRate = 0; // pourcentages
  Color buttonColor = Colors.grey;
  bool isShowCampaignDetailsDialog =false ;

  @override
  void initState() {
    super.initState();
    // Use Future.wait to wait for both async functions to complete
    Future.wait([getOpenedEmailCount(), getClickWebSiteLinkCount()]).then((_) {
      // Both async functions are completed, now you can calculate percentages
      CalculatePourcentages();
    });

  }

  Future<void> getOpenedEmailCount() async {
    var number = await campaignRepo.getNumberOfOpenedEmails(widget.data!.id);
    setState(() {
      OpenedEmailCount = number ;
    });
  }

  Future<void> getClickWebSiteLinkCount() async {
    var number = await  campaignRepo.getNumberOfLinkClicking(widget.data!.id);
    setState(()  {
      ClickWebSiteLinkCount = number;
    });
  }

  Future<void> CalculatePourcentages() async {

    setState(() {
      EmployeeTotalNumber = widget.data!.EmployeeTotalNumber;

      if (ClickWebSiteLinkCount != 0)
        linkClickRate = (ClickWebSiteLinkCount/EmployeeTotalNumber)*100 ;
      else
        linkClickRate = 0 ;

      if(OpenedEmailCount!=0)
        emailOpenRate = (OpenedEmailCount/EmployeeTotalNumber)*100;
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
                child: Text(
                  widget.data!.CampaignName,
                  style:  TextStyle(fontSize: 34, fontFamily: "Poppins", fontWeight: FontWeight.w600,),
                )
            ),
            Expanded(
              flex: 2,
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
                          showReportsDetailsDialog(
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
