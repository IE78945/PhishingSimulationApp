import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/models/campaign_model.dart';
import 'package:phishing_simulation_app/repository/campaign_repository.dart';

import 'campaign_card.dart';

class CampaignReports extends StatefulWidget {
  const CampaignReports({Key? key}) : super(key: key);

  @override
  State<CampaignReports> createState() => _CampaignReportsState();
}

class _CampaignReportsState extends State<CampaignReports> {

  final campaignRepo = Get.put(CampaignRepository());


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
                  "Reports",
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                 

                Expanded(
                  child:
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                    child:StreamBuilder<List<CampaignModel>>(
                              stream: campaignRepo.getAllCampagnes(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var  _data = snapshot.data;
                                  print ("campaigns are fetched" + _data.toString());
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                      maxCrossAxisExtent: 400, // Maximum width for each cell
                                      childAspectRatio: 1 / 0.7, // Width / Height ratio for cells
                                    ),
                                    itemCount: _data?.length,
                                    itemBuilder: (context, index) {
                                      return CampaignCard(
                                        data: _data![index],
                                      );
                                    },
                                  );;
                                }
                                else if (snapshot.hasError) {
                                  return Text('Error snapshot: ${snapshot.error}');
                                } else {
                                  return CircularProgressIndicator();
                                }}
                          ),
                )),


              ],
            ),
          )
        ),
      ),
    );
  }
}
