import 'dart:convert';

import 'package:aph/Home/home_user_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RegisterPage/widgets/widgets.dart';
import '../baseurlp/baseurl.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> passwordChangeApi(BuildContext context) async {
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



      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        final password = _newPasswordController.text;
        final confirmpassword = _confirmPasswordController.text;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('token');

        final response = await http.post(
          Uri.parse(changePassword),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'password': password,'confirm_password':confirmpassword }),
        );
        setState(() {
          _isLoading =
          false; // Set loading state to false after registration completes
        });
        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ),
          );

          print('Change Password successfully!');
          // print(token);
          print(response.body);
        } else {
          // Registration failed
          // You may handle the error response here, e.g., show an error message
          print('password failed!');
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
        title: Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
              key: _formKey,
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
                            child: Image.asset("assets/otp.png")),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 240.0),
                          child: Column(
                            children: [
                              Text.rich(TextSpan(
                                text: 'Change ',
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


                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: "New Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.orange,
                            )),
                        validator: (val) {

                          if(val!.isEmpty){
                            return 'Please enter new password';
                          } else if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },

                        style: TextStyle(
                            color: Colors.black
                        ),
                        // onChanged: (val) {
                        //   setState(() {
                        //     password = val;
                        //   });
                        // },
                      ),


                      SizedBox(height: 20.0),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: "Confirm New Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.orange,
                            )),
                        validator: (val) {

                          if(val!.isEmpty){
                            return 'Please confirm new password';
                          } else   if (val != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }

                          else if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },

                        style: TextStyle(
                            color: Colors.black
                        ),
                        // onChanged: (val) {
                        //   setState(() {
                        //     password = val;
                        //   });
                        // },
                      ),


                    ],
                  ),


                  const SizedBox(
                    height: 80,
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
                        "Change Password",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {

                          // _handleChangePassword();
                          passwordChangeApi(context);

                        }

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => OTPVerification()),
                        // );
                      },
                    ),
                  ),


                ],
              )),
        ),
      ),



    );
  }

  void _handleChangePassword() {
    // Perform password change logic
    // You can implement your own logic here, such as calling an API
    // or updating local storage with the new password.

    // Clear text fields after password change
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    // Show success message
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Success'),
        content: Text('Password changed successfully.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
