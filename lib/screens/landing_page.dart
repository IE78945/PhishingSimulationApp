import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/screens/sign_in_form.dart';

import 'dialog_box.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  bool isShowSignInDialog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
            children: [
              //Background Image
              Image.asset(
                'assets/backgrounds/landing_page_pg.jpg',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              //Animated GIF
              Positioned(
                top:  MediaQuery.of(context).size.height*0.1,
                left: MediaQuery.of(context).size.width*0.01,
                child: Image.asset(
                  'assets/gif/landing_page.gif',
                  height: MediaQuery.of(context).size.height*0.8,
                  width: MediaQuery.of(context).size.width*0.4,
                ),
              ),
              //Title
              Positioned(
                top:  MediaQuery.of(context).size.height*0.1,
                bottom: MediaQuery.of(context).size.height*0.6,
                left: MediaQuery.of(context).size.width*0.4,
                right: MediaQuery.of(context).size.width*0.1,
                child: FittedBox(
                  child: const Text(
                  'Welcome to our Phishing Simulation Training App!',
                    style: landingPageTitle,
                  ),
                ),
              ),
              //Text
              Positioned(
                top:  MediaQuery.of(context).size.height*0.3,
                left: MediaQuery.of(context).size.width*0.4,
                right: MediaQuery.of(context).size.width*0.1,
                child: FittedBox(
                    child : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "we understand the critical importance of cybersecurity awareness in today's digital landscape.\nThat's why we are proud to introduce our cutting-edge Phishing Simulation Training : a comprehensive\nsolution to safeguard your organization against the ever-evolving threat of phishing attacks.\n\nOur platform offers a personalized and engaging training experience for your employees, tailored to\ntheir individual risk levels and knowledge gaps.\nThrough a series of simulated phishing campaigns, we empower your staff to recognize and respond\neffectively to deceptive email tactics, suspicious links, and social engineering techniques.\nSign up for a free or reach out to our dedicated team for more information.\nTogether, let's build a safer and more secure digital future.",
                          style: landingPageText,
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height:MediaQuery.of(context).size.height*0.06 ,),
                        AnimatedButton(
                          width: 200,
                          height: 30,
                          text: "Let's get started !",
                          borderRadius: MediaQuery.of(context).size.width*0.01,
                          selectedTextColor: MyWhite,
                          transitionType: TransitionType.LEFT_TO_RIGHT,
                          backgroundColor: MyDarkBlue,
                          selectedGradientColor: MyGradient,
                          textStyle: landingPageButtonText,
                          animatedOn: AnimatedOn.onTap,
                          onPress: () {
                            //Get.to( ()=> LoginPage() , transition: Transition.zoom , duration: Duration(milliseconds: 1000), );
                            Future.delayed(
                              const Duration(milliseconds: 80),
                                  () {
                                setState(() {
                                  isShowSignInDialog = true;
                                });
                                showCustomDialog(
                                  context,
                                  onValue: (_) {
                                    setState(() {
                                      isShowSignInDialog = false;
                                    });
                                  },
                                  title: 'Sign In',
                                  form: SignInForm(),
                                  gif: 'assets/gif/SignIn.gif',

                                );
                              },
                            );

                          },
                        ),
                      ],
                    ),
                ),
              ),


            ],
          )
      ),
    );
  }
}
