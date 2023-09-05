import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/home_page.dart';

import '../../constant.dart';
import '../../repository/authentication_repository.dart';
import '../Components/dialog_box.dart';


class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _authRepo = Get.put(AuthentificationRepository());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  late TextEditingController _emailController = TextEditingController();


  void ForgotPassword(BuildContext context) async {

        if (_formKey.currentState!.validate()) {
          //si les champs sont validées alors ...
          Future<bool>test = AuthentificationRepository.instance.ForgotPassword(_emailController.text.trim());
          if (await test){
            Future.delayed(
              const Duration(seconds: 2),
                  () {
                // Navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
              },
            );
          }
        }

  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text
                Text("Don't worry! Stuff happens. Just enter your email address below and we'll send you a link to restart your password.", style: TextFieldTitle,),

                SizedBox(height: 20.0,),
                //Email
                const Text(
                  "Email",
                  style: TextFieldTitle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide( width: 3, color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                        child: Icon(Icons.email_rounded),
                      ),
                    ),
                  ),
                ),

                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                     // Reset password  code.......
                      ForgotPassword(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyLightBlue,
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      CupertinoIcons.arrow_right,
                      color: MyWhite,
                    ),
                    label: const Text("Reset password"),
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}

