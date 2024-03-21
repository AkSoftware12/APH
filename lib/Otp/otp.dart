import 'dart:convert';
import 'package:aph/Otp/text_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Home/home_user_page.dart';
import '../../../baseurlp/baseurl.dart';
import 'package:http/http.dart' as http;

import '../Change Password/change_password.dart';

class OTPVerification extends StatefulWidget {
  final String email;

  const OTPVerification({Key? key, required this.email}) : super(key: key);

  @override
  State<OTPVerification> createState() => _LoginPageState();
}

class _LoginPageState extends State<OTPVerification> {
  TextEditingController _otpController1 = TextEditingController();
  TextEditingController _otpController2 = TextEditingController();
  TextEditingController _otpController3 = TextEditingController();
  TextEditingController _otpController4 = TextEditingController();

  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;

  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;

  Future<void> verifyOtpApi(BuildContext context) async {
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
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      String? deviceToken = await _firebaseMessaging.getToken();
      print('Device id: $deviceToken');

      String otp = _otpController1.text.trim() +
          _otpController2.text.trim() +
          _otpController3.text.trim() +
          _otpController4.text.trim();

      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        String apiUrl = verifyOtp; // Replace with your API endpoint

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'email': widget.email,
            'otp': otp,
            'device_id': deviceToken,
          },
        );
        setState(() {
          _isLoading =
              false; // Set loading state to false after registration completes
        });
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String token = responseData['token'];
          // Save token using shared_preferences
          await prefs.setString('token', token);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(),
            ),
          );

          print('verify otp successfully!');
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
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(4, (index) => TextEditingController());
    _focusNodes = List.generate(4, (index) => FocusNode());
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
        title: Text('OTP Verification'),
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
                            child: Image.asset("assets/otp.png")),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 240.0),
                          child: Column(
                            children: [
                              Text.rich(TextSpan(
                                text: 'Otp ',
                                style: GoogleFonts.sansitaSwashed(
                                  textStyle: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Verification',
                                    style: GoogleFonts.sansitaSwashed(
                                      textStyle: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    ),
                                  )
                                ],
                              )),
                              Text.rich(TextSpan(
                                text: 'Email :- ',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget.email,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 18,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => SizedBox(
                          width: 50,
                          child: Container(
                            height: 64.0,
                            width: 64.0,
                            child: Card(
                              color: Color.fromRGBO(173, 179, 191, 0.7),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  cursorColor: Theme.of(context).primaryColor,
                                  decoration: InputDecoration(
                                      hintText: "*",
                                      counterText: '',
                                      hintStyle: TextStyle(
                                          color: Colors.black, fontSize: 20.0)),
                                  onChanged: (value) {
                                    if (value.isEmpty && index > 0) {
                                      _focusNodes[index].unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_focusNodes[index - 1]);
                                    } else if (value.isNotEmpty && index < 3) {
                                      _focusNodes[index].unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_focusNodes[index + 1]);
                                    } else {
                                      _focusNodes[index].unfocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        "Verify OTP",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          verifyOtpApi(context);
                        }

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => OTPVerification()),
                        // );
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
