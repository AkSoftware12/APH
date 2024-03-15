import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ForgotPassword/forgotPassword.dart';
import '../../../Home/home_user_page.dart';
import '../../../Utils/string.dart';
import '../../../baseurlp/baseurl.dart';
import 'package:http/http.dart' as http;

import '../Otp/otp.dart';
import '../RegisterPage/widgets/widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _LoginPageState();
}

class _LoginPageState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;

  Future<void> forgotPasswordApi(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.orangeAccent,
              ),
              // SizedBox(width: 16.0),
              // Text("Logging in..."),
            ],
          ),
        );
      },
    );

    try {
      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        String apiUrl = forgotPassword; // Replace with your API endpoint

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'email': emailController.text,
          },
        );
        setState(() {
          _isLoading =
              false; // Set loading state to false after registration completes
        });
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ),
          );

         print('OTP Send successfully!');
          // print(token);
          print(response.body);
        } else {
          // Registration failed
          // You may handle the error response here, e.g., show an error message
          print('otp failed!');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading =
        false; // Set loading state to false after registration completes
      });
      // Navigator.pop(context); // Close the progress dialog
      // Handle errors appropriately
      print('Error during login: $e');
      // Show a snackbar or display an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to log in. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        // Adding a back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.of(context).pop();

          },
        ),
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // const Text(
                  //   AppConstants.appName,
                  //   style: TextStyle(
                  //       fontSize: 40, fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 10),
                  // const Text("Login now to see what they are talking!",
                  //     style: TextStyle(
                  //         fontSize: 15, fontWeight: FontWeight.w400)),
                  Stack(
                    children: [
                      Center(
                        child: Container(
                            height: 250,
                            width: 250,
                            child: Image.asset("assets/forgotpassword.jpg")),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 210.0),
                          child: Text.rich(TextSpan(
                            text: 'Forgot ',
                            style: GoogleFonts.sansitaSwashed(
                              textStyle: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Password',
                                style: GoogleFonts.sansitaSwashed(
                                  textStyle: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                              )
                            ],
                          )),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                  TextFormField(
                    controller: emailController,
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
                  // TextFormField(
                  //   controller: passwordController,
                  //   obscureText: true,
                  //   decoration: textInputDecoration.copyWith(
                  //       labelText: "Password",
                  //       prefixIcon: Icon(
                  //         Icons.lock,
                  //         color: Colors.orange,
                  //       )),
                  //   validator: (val) {
                  //     if (val!.length < 6) {
                  //       return "Password must be at least 6 characters";
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  //   onChanged: (val) {
                  //     setState(() {
                  //       password = val;
                  //     });
                  //   },
                  // ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //       vertical: 10,
                  //     ),
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         nextScreenReplace(context, ForgotPassword());
                  //       },
                  //       child: Text(
                  //         "Forgot Password?",
                  //         style: TextStyle(
                  //           color: Colors.orangeAccent,
                  //           decoration: TextDecoration.underline,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

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
                        "Send",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () async {
                        // if (formKey.currentState!.validate()) {
                        //   forgotPasswordApi(context);
                        //
                        // }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OTPVerification()),
                        );
                      },
                    ),
                  ),

                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Text.rich(TextSpan(
                  //   text: "Don't have an account? ",
                  //   style: const TextStyle(color: Colors.black, fontSize: 14),
                  //   children: <TextSpan>[
                  //     TextSpan(
                  //         text: "Register here",
                  //         style: const TextStyle(
                  //             fontSize: 20,
                  //             color: Colors.orangeAccent,
                  //             decoration: TextDecoration.underline),
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = () {
                  //             nextScreen(context, const RegisterPage());
                  //           }),
                  //   ],
                  // )),
                ],
              )),
        ),
      ),
    );
  }
}
