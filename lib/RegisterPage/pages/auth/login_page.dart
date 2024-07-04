
import 'dart:convert';

import 'package:aph/Admin/home_admin.dart';
import 'package:aph/RegisterPage/pages/auth/register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ForgotPassword/forgotPassword.dart';
import '../../../Home/home_user_page.dart';
import '../../../LoginServices/login_service.dart';
import '../../../Utils/string.dart';
import '../../../baseurlp/baseurl.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../widgets/widgets.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;


  Future<void> loginUser(BuildContext context) async {
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
            ],
          ),
        );
      },
    );

    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      String? deviceToken = await _firebaseMessaging.getToken();
      print('Device id: $deviceToken');

      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        String apiUrl = login; // Replace with your API endpoint

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'email': emailController.text,
            'password': passwordController.text,
            'device_id': deviceToken, // Pass device token to your API
          },
        );
        setState(() {
          _isLoading = false; // Set loading state to false after registration completes
        });
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String token = responseData['token'];
          final String name = responseData['data']['name'];
          final String userid = responseData['data']['id'].toString();
          final String userImage = responseData['data']['picture_data'];
          // Save token using shared_preferences
          await prefs.setString('token', token);
          await prefs.setString('name', name);
          await prefs.setString('userId', userid);
          // await prefs.setString('userImage', userImage);

          loginCall(
            userID: userid,
            userName: name,
          ).then((value) {
            onUserLogin();


          });

          print(token);

          if (email == 'admin@gmail.com') {
            prefs.setBool('admin', true);
            await prefs.setString('adminButton', 'adminButton');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPage(),
              ),
            );
          } else {
            prefs.setBool('isLoggedIn', true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          }



          print('User registered successfully!');
          print(token);
          print(response.body);
        } else {

          Navigator.pop(context);
          // Registration failed
          // You may handle the error response here, e.g., show an error message
          print('Registration failed!');
          Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be displayed
            gravity: ToastGravity.BOTTOM, // Toast gravity
            timeInSecForIosWeb: 1, // Time in seconds for iOS and web
            backgroundColor: Colors.black.withOpacity(0.8), // Background color of the toast
            textColor: Colors.white, // Text color of the toast
            fontSize: 16.0, // Font size of the toast message
          );
        }
      }
    } catch (e) {
      emailController.clear();
      passwordController.clear();
      Navigator.pop(context); // Close the progress dialog
      // Handle errors appropriately
      print('Error during login: $e');
      // Show a snackbar or display an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to log in. Please try again.'),
      ))
      ;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
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
                            height: 250,width: 250,
                            child: Image.asset("assets/astro_black.png")),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 210.0),
                          child:  Text.rich(TextSpan(
                            text: AppConstants.appLogoName,
                            style: GoogleFonts.sansitaSwashed(
                              textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.black),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: AppConstants.appLogoName2,
                                style: GoogleFonts.sansitaSwashed(
                                  textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.orange),
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

                    style: TextStyle(
                        color: Colors.black
                    ),

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
                    controller: passwordController,
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

                    style: TextStyle(
                        color: Colors.black
                    ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()),
                          );
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


                          loginUser(context);

                        }
                      },
                    ),
                  ),



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
                              fontSize: 20,
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


}
