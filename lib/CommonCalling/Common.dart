
import 'package:aph/Admin/home_admin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Auth/auth_service.dart';
import '../DemoChat/pages/auth/login_page.dart';
import '../Home/home_page.dart';
import '../Login/login.dart';
import '../UploadImage/all_post.dart';
import '../Utils/color.dart';
import '../constants/firestore_constants.dart';

class CommonMethod{
  AuthService _authService = AuthService();


  // logout
  Future<void > showProgressBar(BuildContext context) async {
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return Center(
           child: CircularProgressIndicator(
             valueColor: AlwaysStoppedAnimation<Color>(ColorSelect.buttonColor),
           ), // Progress bar widget
         );
       },
     );
     // Simulate a delay before hiding the progress bar
     Future.delayed(Duration(seconds: 5), () async {

       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => LoginPage()),
       ); // Close the progress bar dialog
     });
   }


   // login
  Future<void > login(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorSelect.buttonColor),

          ),
        );
      },
    );

  }


// check Autho login



 }