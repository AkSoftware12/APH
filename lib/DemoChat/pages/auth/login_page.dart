
import 'package:aph/Admin/home_admin.dart';
import 'package:aph/DemoChat/pages/auth/register_page.dart';
import 'package:aph/DemoChat/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../Auth/auth_service.dart';
import '../../../CommonCalling/Common.dart';
import '../../../ForgotPassword/forgotPassword.dart';
import '../../../Home/home_page.dart';
import '../../../Utils/string.dart';
import '../../helper/helper_function.dart';
import '../../service/database_service.dart';
import '../../widgets/widgets.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CommonMethod common = CommonMethod();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          AppConstants.appName,
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text("Login now to see what they are talking!",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        Container(
                            height: 400,
                            child: Container(
                                height: 250,width: 250,
                                child: Image.asset("assets/astro_black.png"))),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.orange,
                              )),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },

                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.orange,
                              )),
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,),
                            child: GestureDetector(
                              onTap: () {
                                // nextScreenReplace(context,  ForgotPassword());
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),

                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        // Add the "Forgot Password?" text below
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: const Text(
                              "Sign In",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                await authService.loginWithUserNameandPassword(email, password).then((value) async {
                                  if (value == true) {
                                    QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
                                    String userRole = snapshot.docs[0]['role']; // Assuming 'role' is the field representing user role in your database

                                    // Saving the values to shared preferences
                                    await HelperFunctions.saveUserLoggedInStatus(true);
                                    await HelperFunctions.saveUserEmailSF(email);
                                    await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

                                    if (userRole == 'admin') {
                                      nextScreenReplace(context, const AdminPage());
                                    } else {
                                      nextScreenReplace(context, const MyHomePage());
                                    }
                                  } else {
                                    showSnackbar(context, Colors.red, value);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                                );
                              }

                              // login();
                            },
                          ),
                        ),


                        // SizedBox(height: 15,),
                        // Text(
                        //   "- - - - - - - - - - - - OR - - - - - - - - - - - -".toUpperCase(),
                        //   style: TextStyle(
                        //       color: Colors.black,
                        //       fontSize:
                        //       18 // Change the color to your desired color
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 35,
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       primary: Colors.orange, // Set the background color here
                        //     ),
                        //
                        //     onPressed: () async {
                        //       common.login(context);
                        //
                        //     },
                        //
                        //
                        //     child: Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         ClipRRect(
                        //             borderRadius: BorderRadius.circular(10.0),
                        //             child: Image.asset(
                        //               'assets/gmail.png',
                        //               // Replace with your image path
                        //               height:
                        //               20, // Adjust the height as needed
                        //             )),
                        //         SizedBox(width: 8.0),
                        //         // Add some space between image and text
                        //         Text(
                        //           "Social Login".toUpperCase(),
                        //           style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize:
                        //               18 // Change the color to your desired color
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Register here",
                                style: const TextStyle(
                                    color: Colors.orangeAccent,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const RegisterPage());
                                  }),
                          ],
                        )),




                      ],
                    )),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNameandPassword(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          String userRole = snapshot.docs[0]['role']; // Assuming 'role' is the field representing user role in your database

          // Saving the values to shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

          if (userRole == 'admin') {
            nextScreenReplace(context, const AdminPage());
          } else {
            nextScreenReplace(context, const MyHomePage());
          }
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
