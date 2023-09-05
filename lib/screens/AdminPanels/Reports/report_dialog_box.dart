import 'package:flutter/material.dart';
import 'package:phishing_simulation_app/models/campaign_model.dart';

import 'campaign_details_form.dart';



void showReportsDetailsDialog(BuildContext context, {required ValueChanged onValue , required  CampaignModel? data}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: FractionallySizedBox(
          widthFactor: 0.7,
          heightFactor: 0.8,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 30),
                  blurRadius: 60,
                ),
                const BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 30),
                  blurRadius: 60,
                ),
              ],
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              body: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Campaign Details",
                              style: TextStyle(
                                fontSize: 34,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: campaignDetailsForm(data: data,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);

      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
  ).then(onValue);
}
