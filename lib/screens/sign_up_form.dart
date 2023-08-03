import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/screens/home_page.dart';
import '../constant.dart';
import '../repository/authentication_repository.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final _authRepo = Get.put(AuthentificationRepository());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _PasswordController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();


  bool _isObscureConfirmPassword = true;
  String _password="";
  bool _isObscure = true;
  late String _confirmpassword;




  void signUp(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 1),
            () async {
          if (_formKey.currentState!.validate()) {
            Future<bool> isFirebaseAuthentificationAccountCreated;
            isFirebaseAuthentificationAccountCreated =
                AuthentificationRepository.instance
                    .CreateUserWithEmailAndPassword(
                    _emailController.text.trim(),
                    _PasswordController.text.trim());

            if (await isFirebaseAuthentificationAccountCreated) {
              Future.delayed(
                const Duration(seconds: 2),
                    () {
                  // Navigate
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  });
                },
              );
            }

          }
        }
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
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
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

                //confirm password
                const Text(
                  "Confirm Password",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: TextFormField(
                    obscureText: _isObscureConfirmPassword,
                    onChanged: (value){
                      setState(() {
                        _password = _PasswordController.text;
                        _confirmpassword = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      } else if (_password != value) {
                        return 'Passwords do not match';
                      }
                      return null;
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
                            _isObscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: _isObscureConfirmPassword ? Colors.grey : MyLightBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscureConfirmPassword = !_isObscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                     // Sign Up code.......
                      signUp(context);
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
                    label: const Text("Sign Up"),
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

