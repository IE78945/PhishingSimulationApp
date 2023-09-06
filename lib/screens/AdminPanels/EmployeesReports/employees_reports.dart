import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/models/employee_model.dart';
import 'package:phishing_simulation_app/repository/campaign_repository.dart';
import 'package:phishing_simulation_app/repository/employee_repository.dart';

import 'employee_card.dart';

class EmployeesReports extends StatefulWidget {
  const EmployeesReports({Key? key}) : super(key: key);

  @override
  State<EmployeesReports> createState() => _EmployeesReportsState();
}

class _EmployeesReportsState extends State<EmployeesReports> {

  final campaignRepo = Get.put(CampaignRepository());
  final employeesRepo = Get.put(EmployeeRepository());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                    "Employees Reports",
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
                        child:StreamBuilder<List<EmployeeModel>>(
                            stream: employeesRepo.getAllEmployee(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var  _data = snapshot.data;
                                print ("employees are fetched" + _data.toString());
                                return GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                    maxCrossAxisExtent: 400, // Maximum width for each cell
                                    childAspectRatio: 1 / 1.3, // Width / Height ratio for cells
                                  ),
                                  itemCount: _data?.length,
                                  itemBuilder: (context, index) {
                                    return EmployeeCard(
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
