import 'package:aph/CommonCalling/Common.dart';
import 'package:aph/Utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Login/login.dart';
import '../About/about_us.dart';
import '../Auth/auth_service.dart';
import '../DemoChat/pages/auth/login_page.dart';
import '../ProfileScreen/profile_screen.dart';
import 'package:http/http.dart' as http;

import '../constants/color_constants.dart';
import 'dart:io';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});


  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<SettingScreen> {
  CommonMethod common = CommonMethod();

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String userEmail = '';

  bool isLoading = false;
  File? avatarImageFile;

  @override
  void initState() {
    super.initState();

  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing dialog
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                    color: Colors.orangeAccent
                ),
                SizedBox(width: 16.0),
                Text("Logging out..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Replace 'your_token_here' with your actual token
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final Uri uri = Uri.parse('https://api.astropanditharidwar.in/api/logout');
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      final response = await http.post(uri, headers: headers);

      Navigator.pop(context); // Close the progress dialog

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          ),
        );
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Navigator.pop(context); // Close the progress dialog
      // Handle errors appropriately
      print('Error during logout: $e');
      // Show a snackbar or display an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to log out. Please try again.'),
      ));
    }
  }

  void _onShareButtonPressed(BuildContext context) {
    String title = "musicService.title";
    String subtitle =" musicService.subtitle";
    String url = "musicService.url";
    String imagePath =" musicService.getImageUrl()";

    Share.share(
      '$title\n$subtitle\n $url',
      // subject: musicService.title,

      sharePositionOrigin: Rect.fromCircle(
        center: Offset(0, 0),
        radius: 100,
      ),
      // shareRect: Rect.fromCircle(
      //   center: Offset(0, 0),
      //   radius: 100,
      // ),
      // imageUrl: 'file:///$imagePath',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  ColorSelect.background,
        // backgroundColor: Color(0xEE2B2E2F),

        body: ListView(
          children: <Widget>[
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // This makes the card edges non-rounded
              ),
              child:Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Container(
                  height: 100,
                  color:  ColorSelect.background,
                  // Controls the shadow depth
                  // Card elevation
                  child: ListTile(
                    title:
                    Text(
                      'nickname',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Text(
                      'userEmail',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    leading: Container(
                      child: avatarImageFile == null
                          ? photoUrl.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          'photoUrl',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: 90,
                              color: ColorConstants.greyColor,
                            );
                          },
                          loadingBuilder: (BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.themeColor,
                                  value: loadingProgress
                                      .expectedTotalBytes !=
                                      null
                                      ? loadingProgress
                                      .cumulativeBytesLoaded /
                                      loadingProgress
                                          .expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                          : Icon(
                        Icons.account_circle,
                        size: 90,
                        color: ColorConstants.greyColor,
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.file(
                          avatarImageFile!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProfileScreen();
                          },
                        ),
                      );
                    },
                  ), // Margin around the card
                ),
              ),

            ),


            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // This makes the card edges non-rounded
              ),
              child: SizedBox(
                height: 60,
                child: Column(children: [


                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 58,
                      color:  ColorSelect.background, // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title:Text(
                          'Share',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color:  ColorSelect.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        // leading: Icon(
                        //   Icons.logout,
                        //   color: Colors.white,
                        // ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 23,
                              color:  ColorSelect.black,
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.share,
                                size: 23,
                                color: ColorSelect.black,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _onShareButtonPressed(context);
                        },
                      ), // Margin around the card
                    ),
                  ),
                  // Divider(height: 1,thickness: 1,color:  ColorSelect.black,),

                ]),
              ),
            ),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // This makes the card edges non-rounded
              ),
              child: SizedBox(
                height: 60,
                child: Column(children: [


                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 58,
                      color:  ColorSelect.background, // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title:Text(
                          'Contact Us',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color:  ColorSelect.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        // leading: Icon(
                        //   Icons.logout,
                        //   color: Colors.white,
                        // ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 23,
                              color:ColorSelect.black,
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.connect_without_contact,
                                size: 23,
                                color: ColorSelect.black,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutUsScreen(title: '',)),
                          );
                        },
                      ), // Margin around the card
                    ),
                  ),
                  // Divider(height: 1,thickness: 1,color: ColorSelect.black,),

                ]),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // This makes the card edges non-rounded
              ),
              child: SizedBox(
                height: 60,
                child: Column(children: [


                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 58,
                      color: ColorSelect.background, // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title:Text(
                          'Help & FAQ',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color:ColorSelect.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        // leading: Icon(
                        //   Icons.logout,
                        //   color: Colors.white,
                        // ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 23,
                              color: ColorSelect.black,
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.help,
                                size: 23,
                                color: ColorSelect.black,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutUsScreen(title: '',)),
                          );
                        },
                      ), // Margin around the card
                    ),
                  ),
                  // Divider(height: 1,thickness: 1,color:ColorSelect.black,),

                ]),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // This makes the card edges non-rounded
              ),
              child: SizedBox(
                height: 60,
                child: Column(children: [


                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 58,
                      color: ColorSelect.background, // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title:Text(
                          'Rate on Google Play',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: ColorSelect.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        // leading: Icon(
                        //   Icons.logout,
                        //   color: Colors.white,
                        // ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 23,
                              color: ColorSelect.black,
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.rate_review,
                                size: 23,
                                color: ColorSelect.black,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          // _handleSignOut();
                        },
                      ), // Margin around the card
                    ),
                  ),
                  // Divider(height: 1,thickness: 1,color: ColorSelect.black,),

                ]),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // This makes the card edges non-rounded
              ),
              child: SizedBox(
                height: 60,
                child: Column(children: [


                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 58,
                      color: ColorSelect.background, // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title:Text(
                          'Terms & Privacy',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color:ColorSelect.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        // leading: Icon(
                        //   Icons.logout,
                        //   color: Colors.white,
                        // ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 23,
                              color:ColorSelect.black,
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.privacy_tip_outlined,
                                size: 23,
                                color: ColorSelect.black,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutUsScreen(title: '',)),
                          );                        },
                      ), // Margin around the card
                    ),
                  ),
                  // Divider(height: 1,thickness: 1,color: ColorSelect.black,),

                ]),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // This makes the card edges non-rounded
              ),
              child: SizedBox(
                height: 60,
                child: Column(children: [


                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 58,
                      color: ColorSelect.background, // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title:Text(
                          'About Us',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color:ColorSelect.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        // leading: Icon(
                        //   Icons.logout,
                        //   color: Colors.white,
                        // ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 23,
                              color:ColorSelect.black,
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.privacy_tip_outlined,
                                size: 23,
                                color: ColorSelect.black,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutUsScreen(title: '',)),
                          );

                        },
                      ), // Margin around the card
                    ),
                  ),
                  // Divider(height: 1,thickness: 1,color: ColorSelect.black,),

                ]),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // This makes the card edges non-rounded
              ),
              child: SizedBox(
                height: 60,
                child: Column(children: [


                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 58,
                      color: ColorSelect.background, // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title:Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: ColorSelect.bhagva,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        // leading: Icon(
                        //   Icons.logout,
                        //   color: Colors.white,
                        // ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 23,
                              color: ColorSelect.bhagva,
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 23,
                                color:ColorSelect.bhagva,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {

                          logout(context);
                        },
                      ), // Margin around the card
                    ),
                  ),
                  // Divider(height: 1,thickness: 1,color: ColorSelect.black,),

                ]),
              ),
            ),



          ],
        ));
  }
}
