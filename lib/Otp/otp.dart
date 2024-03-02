import 'dart:convert';
import 'package:aph/Otp/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Auth/auth_service.dart';
import '../../../CommonCalling/Common.dart';
import '../../../Home/home_page.dart';
import '../../../baseurlp/baseurl.dart';
import 'package:http/http.dart' as http;
import '../DemoChat/widgets/widgets.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({Key? key}) : super(key: key);

  @override
  State<OTPVerification> createState() => _LoginPageState();
}

class _LoginPageState extends State<OTPVerification> {
  TextEditingController _otpController1 = TextEditingController();
  TextEditingController _otpController2 = TextEditingController();
  TextEditingController _otpController3 = TextEditingController();
  TextEditingController _otpController4 = TextEditingController();
  CommonMethod common = CommonMethod();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  // Future<void> forgotPasswordApi(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             CircularProgressIndicator(
  //               color: Colors.orangeAccent,
  //             ),
  //             // SizedBox(width: 16.0),
  //             // Text("Logging in..."),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //
  //   try {
  //     if (formKey.currentState!.validate()) {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //       String apiUrl = forgotPassword; // Replace with your API endpoint
  //
  //       final response = await http.post(
  //         Uri.parse(apiUrl),
  //         body: {
  //           'email': emailController.text,
  //         },
  //       );
  //       setState(() {
  //         _isLoading =
  //         false; // Set loading state to false after registration completes
  //       });
  //       if (response.statusCode == 200) {
  //         final Map<String, dynamic> responseData = json.decode(response.body);
  //
  //
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => MyHomePage(),
  //           ),
  //         );
  //
  //         print('OTP Send successfully!');
  //         // print(token);
  //         print(response.body);
  //       } else {
  //         // Registration failed
  //         // You may handle the error response here, e.g., show an error message
  //         print('otp failed!');
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading =
  //       false; // Set loading state to false after registration completes
  //     });
  //     // Navigator.pop(context); // Close the progress dialog
  //     // Handle errors appropriately
  //     print('Error during login: $e');
  //     // Show a snackbar or display an error message
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Failed to log in. Please try again.'),
  //     ));
  //   }
  // }

  @override
  void dispose() {
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    super.dispose();
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
                          padding: const EdgeInsets.only(top: 210.0),
                          child: Text.rich(TextSpan(
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
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0,right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 64.0,
                            width: 56.0,
                            child: Card(
                                color: Color.fromRGBO(173, 179, 191, 0.7),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: TextEditorForPhoneVerify(this._otpController1)
                                )
                            )
                        ),
                        Container(
                            height: 64.0,
                            width: 56.0,
                            child: Card(
                                color: Color.fromRGBO(173, 179, 191, 0.7),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: TextEditorForPhoneVerify(this._otpController2)
                                )
                            )
                        ),
                        Container(
                            height: 64.0,
                            width: 56.0,
                            child: Card(
                                color: Color.fromRGBO(173, 179, 191, 0.7),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: TextEditorForPhoneVerify(this._otpController3)
                                )
                            )
                        ),
                        Container(
                            height: 64.0,
                            width: 56.0,
                            child: Card(
                                color: Color.fromRGBO(173, 179, 191, 0.7),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: TextEditorForPhoneVerify(this._otpController4)
                                )
                            )
                        ),
                      ],
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
                        // if (formKey.currentState!.validate()) {
                        //   forgotPasswordApi(context);
                        //
                        // }

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
