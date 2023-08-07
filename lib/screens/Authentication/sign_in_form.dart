import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/screens/Authentication/sign_up_form.dart';
import 'package:phishing_simulation_app/screens/AdminPanels/home_page.dart';
import '../../repository/authentication_repository.dart';


import '../../constant.dart';
import '../Components/dialog_box.dart';
import 'forgot_password_form.dart';


class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  final _authRepo = Get.put(AuthentificationRepository());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _PasswordController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();


  bool isShowForgotPasswordDialog = false;
  bool isShowSignUpDialog = false;

  bool _isObscure = true;


  void signIn(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
          () async {
        if (_formKey.currentState!.validate()) {
          // login user in firebase
          Future<bool> isLoggedIn;
          isLoggedIn = AuthentificationRepository.instance.LoginUserWithEmailAndPassword(_emailController.text.trim(), _PasswordController.text.trim());
          if (await isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
            /*
            Future.delayed(
              const Duration(seconds: 2),
                  () {
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
              },
            );
             */
          }
          // else show failuare animation
          else {
            Get.snackbar(
              "Error",
              "Your email or password is incorrect, please verify your information.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.white.withOpacity(0.7),
              colorText: Colors.red,
            );
          }
        }
        else {
          Get.snackbar(
            "Error",
            "Your email or password is incorrect, please verify your information.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white.withOpacity(0.7),
            colorText: Colors.red,
          );
        }
      },
    );
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

                // password
                const Text(
                  "Password",
                  style: TextFieldTitle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 0),
                  child: TextFormField(
                    obscureText: _isObscure,
                    controller: _PasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                        return 'Please enter a valid password';
                      }
                      return null; // Return null if the input is valid
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide( width: 3, color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.lock),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility_off : Icons.visibility,
                            color: _isObscure ? Colors.grey : MyLightBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                //forgot password
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){
                        //show forgot password dialog
                        Future.delayed(
                          const Duration(milliseconds: 800),
                              () {
                            setState(() {
                              isShowForgotPasswordDialog = true;
                            });


                            showCustomDialog(
                              context,
                              onValue: (_) {
                                setState(() {
                                  isShowForgotPasswordDialog = false;
                                });
                              },
                              gif: 'assets/gif/ForgotPassword.gif',
                              title: 'Forgot password',
                              form: ForgotPasswordForm(),
                              widthFactor: 0.9,
                              heightFactor: 0.9,
                            );


                          },
                        );
                      },
                      child: Text("Forgot password?",style: TextFieldTitle,),
                    ),
                  ),
                ),

                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                     // Login to database code.......
                      signIn(context);
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
                    label: const Text("Sign In"),
                  ),
                ),

                //Sign Up
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 8),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: (){
                        //show forgot password dialog
                        Future.delayed(
                          const Duration(milliseconds: 800),
                              () {
                            setState(() {
                              isShowSignUpDialog = true;
                            });

                            showCustomDialog(
                              context,
                              onValue: (_) {
                                setState(() {
                                  isShowSignUpDialog = false;
                                });
                              },
                              gif: 'assets/gif/SignUp.gif',
                              title: 'Sign Up',
                              form: SignUpForm(),
                              widthFactor: 0.9,
                              heightFactor: 0.9,
                            );
                          },
                        );
                      },
                      child: Text("Don't have an account? Sign up now",style: TextFieldTitle,),
                    ),
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

