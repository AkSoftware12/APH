import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import '../Auth/auth_service.dart';
import '../Home/home_page.dart';
import 'package:firebase_auth_platform_interface/src/auth_provider.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.onTap});

  final Function? onTap;

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<LoginScreen> {
  AuthService _authService = AuthService();

  TextEditingController _userphoneController = TextEditingController();

  bool _progressVisible = false;

  bool _isLoggedIn = false;

  // MySingleton mySingleton = MySingleton.instance;
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';


  bool showOTPField = false;
  bool showSendOTPButton = true;
  bool showProgressBar = false;




  final FirebaseAuth? _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = "";
  late String smsOTP="";


  Future<void> _sendOTP() async {
    try {
      await _auth!.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval of OTP timed out
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      await _auth!.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
      // Authentication successful, perform necessary actions
    } catch (e) {
      print(e.toString());
      // Show a pop-up indicating wrong OTP
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid OTP'),
            content: Text('The OTP entered is incorrect.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkAutoLogin();
  }

  Future<void> checkAutoLogin() async {
    bool isLoggedIn = await _authService.isUserLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
      print('Auto-Login Successful');
    }
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor:  Colors.black,

        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 98.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: GestureDetector(
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue, // Set the border color here
                                width: 0.0, // Set the border width
                              ),
                              color: Colors.white, // Container background color
                              borderRadius: BorderRadius.circular(150),
                              // Optional: Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.2),
                                  // Shadow color
                                  spreadRadius: 5,
                                  // Spread radius
                                  blurRadius: 10,
                                  // Blur radius
                                  offset:
                                  Offset(0, 3), // Offset from the top-left
                                ),
                              ],
                            ),

                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset('assets/mobile.png')),

                            // slider banner ad close
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: const Column(
                      children: [
                        Text(
                          'Mobile Number',
                          style: TextStyle(
                            color: Colors.white,
                            // Text color
                            fontSize: 25.0,
                            // Font size
                            fontWeight: FontWeight.normal,
                            // Font weight
                            fontStyle: FontStyle.normal,
                            // Font style
                            fontFamily: 'Roboto', // Custom font family
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 17.0),
                          child: Text(
                            'We need to send OTP to authenticate your number',
                            style: TextStyle(
                              color: Colors.white70,
                              // Text color
                              fontSize: 16.0,
                              // Font size
                              fontWeight: FontWeight.normal,
                              // Font weight
                              fontStyle: FontStyle.normal,
                              // Font style
                              fontFamily: 'Roboto', // Custom font family
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 410,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      // bottomLeft: Radius.circular(60),
                      // bottomRight: Radius.circular(60),
                    ),
                    color: Colors.white,
                  ),
                  child: Container(
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0,left: 25,right: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IntlPhoneField(
                                    controller: _phoneNumberController,
                                    flagsButtonPadding: const EdgeInsets.all(8),
                                    dropdownIconPosition: IconPosition.trailing,
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF222B40),
                                      ),
                                      fillColor: Colors.black,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF222B40),
                                        ),
                                      ),
                                    ),
                                    initialCountryCode: 'IN',
                                    onChanged: (phone) {
                                      print(phone.completeNumber);
                                    },
                                  ),
                                  SizedBox(height: 5),
                                  Visibility(
                                    visible: showSendOTPButton,
                                    child:Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0.0, right: 0, top: 5),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 55,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.black, // Set the background color here
                                          ),

                                          onPressed: () {
                                            // Simulating sending OTP by showing a progress indicator for 3 seconds
                                            setState(() {
                                              showSendOTPButton = false;
                                              showProgressBar = true;
                                            });

                                            Future.delayed(Duration(seconds: 3), () {
                                              setState(() {
                                                showProgressBar = false;
                                                showOTPField = true;
                                              });
                                            });

                                            _sendOTP();
                                          },


                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Add some space between image and text
                                              Text(
                                                "Send Otp".toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                    18 // Change the color to your desired color
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Visibility(
                                    visible: showProgressBar,
                                    child: CircularProgressIndicator(),
                                  ),
                                  Visibility(
                                    visible: showOTPField,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(right: 20.0, left: 20.0),
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 10.0),
                                              PinCodeTextField(
                                                autofocus: false,
                                                controller: _otpController,
                                                hideCharacter: false,
                                                highlight: true,
                                                highlightColor: Colors.black,
                                                defaultBorderColor: Colors.white,
                                                hasTextBorderColor: Colors.orange,
                                                maxLength: 6,
                                                pinBoxRadius: 20,
                                                onDone: (text) {
                                                  SystemChannels.textInput
                                                      .invokeMethod('TextInput.hide');
                                                  _verificationId = text;
                                                  smsOTP = text as String;
                                                },
                                                pinBoxWidth: 40,
                                                pinBoxHeight: 40,
                                                hasUnderline: false,
                                                wrapAlignment: WrapAlignment.spaceAround,
                                                pinBoxDecoration: ProvidedPinBoxDecoration
                                                    .roundedPinBoxDecoration,
                                                pinTextStyle: TextStyle(fontSize: 22.0),
                                                pinTextAnimatedSwitcherTransition:
                                                ProvidedPinBoxTextAnimation.scalingTransition,
                                                pinTextAnimatedSwitcherDuration:
                                                Duration(milliseconds: 300),
                                                highlightAnimationBeginColor: Colors.black,
                                                highlightAnimationEndColor: Colors.white12,
                                                keyboardType: TextInputType.number,
                                              ),
                                              SizedBox(height: 15.0),
                                              const SizedBox(height: 10.0),

                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 10),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0, right: 0, top: 5),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 55,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.black, // Set the background color here
                                              ),

                                              onPressed: () {
                                                // Simulate verification with a progress indicator for 3 seconds
                                                setState(() {
                                                  showProgressBar = true;
                                                });

                                                // Simulate verification delay with a Future
                                                Future.delayed(Duration(seconds: 3), () {
                                                  // Navigate back to the home screen and hide progress indicator
                                                  setState(() {
                                                    showProgressBar = false;
                                                    showOTPField = false;
                                                    showSendOTPButton =
                                                    true; // Show send OTP button again
                                                  });

                                                  _signInWithOTP();
                                                });
                                              },


                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Add some space between image and text
                                                  Text(
                                                    "Verify".toUpperCase(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                        18 // Change the color to your desired color
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 20),
                              child: SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black, // Set the background color here
                                  ),

                                  onPressed: () async {
                                    // Show circular progress indicator
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    );


                                    User? user = await _authService.loginWithGoogle();

                                    // Perform login with Google
                                    if (user != null) {
                                      print('Logged in user: ${user.displayName}');
                                    }


                                    // Perform Google login
                                    await _authService.loginWithGoogle();
                                    // Hide circular progress indicator
                                    Navigator.pop(context);

                                    // Navigate to home page if logged in
                                    if (await _authService.isUserLoggedIn()) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyHomePage()),
                                      );
                                    }
                                  },




                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(20.0),
                                          child: Image.asset(
                                            'assets/gmail.png',
                                            // Replace with your image path
                                            height:
                                            30, // Adjust the height as needed
                                          )),
                                      SizedBox(width: 8.0),
                                      // Add some space between image and text
                                      Text(
                                        "Social Login".toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            18 // Change the color to your desired color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}
