import 'package:aph/Utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share/share.dart';
import '../../Login/login.dart';
import '../Auth/auth_service.dart';
import '../ProfileScreen/profile_screen.dart';



class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});


  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<SettingScreen> {
  AuthService _authService = AuthService();



  @override
  void initState() {
    super.initState();

  }


  void _showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Progress bar widget
        );
      },
    );
    // Simulate a delay before hiding the progress bar
    Future.delayed(Duration(seconds: 5), () async {
      await _authService.logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      ); // Close the progress bar dialog
    });
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
                          'Email Notification',
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
                                Icons.email,
                                size: 23,
                                color:  ColorSelect.black,
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
                          'Theme',
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
                                Icons.color_lens,
                                size: 23,
                                color:  ColorSelect.black,
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
                          // _handleSignOut();
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
                          'Logout',
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
                                Icons.logout,
                                size: 23,
                                color:ColorSelect.black,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _showProgressBar(context);
                          // _handleSignOut();
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
