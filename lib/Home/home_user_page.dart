import 'dart:convert';
import 'dart:io';
import 'package:aph/Utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../AddScreen/add_screen.dart';
import '../Live/home_page.dart';
import '../Live/live_page.dart';
import '../Model/popup_choices.dart';
import '../NotificationScreen/notification.dart';
import '../ProfileScreen/profile_screen.dart';
import '../ProfileScreen/update_profile.dart';
import '../RegisterPage/pages/auth/login_page.dart';
import '../Settings/settings.dart';
import '../Utils/string.dart';
import '../baseurlp/baseurl.dart';
import '../chatAdminUser/chat_controller.dart';
import '../chatAdminUser/chat_screen_user.dart';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';
import 'home.dart';
import 'package:http/http.dart' as http;


class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  _BottomNavBarDemoState createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String id = '';
  String userId = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String userEmail = '';
  int _currentIndex = 0;
  bool _isLoading = false;
  final liveTextCtrl ='1234';

  final List<Widget> _children = [
    // AllPosts(),
    HomeScreen(),
    NotificationScreen(),
    AddScreen(),
    SettingScreen(),
    UpdateProfileScreen(),
  ];

  final List<PopupChoices> choices = <PopupChoices>[
    PopupChoices(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    readLocal();
    fetchProfileData();

  }

  Widget buildPopupMenu() {
    return PopupMenuButton<PopupChoices>(
      onSelected: onItemMenuPress,
      itemBuilder: (BuildContext context) {
        return choices.map((PopupChoices choice) {
          return PopupMenuItem<PopupChoices>(
              value: choice,
              child: Row(
                children: <Widget>[
                  Icon(
                    choice.icon,
                    color:  Colors.orangeAccent,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    choice.title,
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ],
              ));
        }).toList();
      },
    );
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<void> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: ColorConstants.themeColor,
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: ColorConstants.primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Cancel',
                      style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: ColorConstants.primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Yes',
                      style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }


  Future<void> logoutApi(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing dialog
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
      // Replace 'your_token_here' with your actual token
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final Uri uri = Uri.parse(logout);
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      final response = await http.post(uri, headers: headers);

      Navigator.pop(context); // Close the progress dialog

      if (response.statusCode == 200) {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('isLoggedIn',);
        prefs.remove('admin',);
        prefs.remove('adminButton',);



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
  void onItemMenuPress(PopupChoices choice) {
    if (choice.title == 'Log out') {
      logoutApi(context);

    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
  }


  Future<void> readLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString(FirestoreConstants.id) ?? "";
      nickname = prefs.getString(FirestoreConstants.nickname) ?? "";
      photoUrl = prefs.getString(FirestoreConstants.photoUrl) ?? "";
      userEmail = prefs.getString(FirestoreConstants.userEmail) ?? "";
    });


  }


  Future<void> fetchProfileData() async {

    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
      'token',
    );
    final Uri uri =
    Uri.parse(getProfile);
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      _isLoading =
      false; // Set loading state to false after registration completes
    });
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      setState(() {
        userId = jsonData['user']['id'].toString();
        nickname = jsonData['user']['name'];
        userEmail = jsonData['user']['email'];
        photoUrl = jsonData['user']['picture_data'];
      });
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSelect.bhagva,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorSelect.bhagva,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: SizedBox(
                width: 50,
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, object, stackTrace) {
                              return  ClipRRect(
                                borderRadius: BorderRadius.circular(30), // Half of width/height for perfect circle
                                child: Image.asset(
                                  'assets/astro_black.png',
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              );
                            },
                          )
                      )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child:  Text.rich(TextSpan(
                        text: AppConstants.appLogoName,
                        style: GoogleFonts.sansitaSwashed(
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: AppConstants.appLogoName2,
                            style: GoogleFonts.sansitaSwashed(
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.orange),
                            ),
                          )
                        ],
                      )),




                    ),
                  ),

                ),
              ),
            ),


            GestureDetector(
              onTap: () {
                if (ZegoUIKitPrebuiltLiveStreamingController()
                    .minimize
                    .isMinimizing) {
                  /// when the application is minimized (in a minimized state),
                  /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                  return;
                }

                jumpToLivePage(
                  context,
                  liveID: '12345',
                  isHost: false, userName: nickname, userId: userId, userImage: photoUrl,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Card(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppConstants.live,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: ColorSelect.textcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.chat), // This line adds the chat icon
          //   onPressed: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) {
          //     //       return ChatPage();
          //     //     },
          //     //   ),
          //     // );
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) {
          //     //       return ChatScreenRavi();
          //     //     },
          //     //   ),
          //     // );
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: buildPopupMenu(),
          ),
        ],
      ),
      body: SafeArea(
        child: WillPopScope(
          child: _children[_currentIndex],
          onWillPop: onBackPress,
        ),
      ),
      bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: ColorSelect.bhagva,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: ColorSelect.black,
            unselectedItemColor: ColorSelect.textcolor,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppConstants.home,
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: AppConstants.notification,
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Container(),
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: AppConstants.settings,
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: AppConstants.profile,
              ),
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorSelect.textcolor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChangeNotifierProvider(
                  create: (_) => ChatController(),
                  child:  ChatUserScreen(),
                );
              },
            ),
          );



        },
        child: Icon(Icons.chat, color: ColorSelect.black),
        shape: CircleBorder(),
      ),
    );
  }


  void jumpToLivePage(BuildContext context,
      {required String liveID, required bool isHost,required String userName,required String userId,required String userImage}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(liveID: liveID, isHost: isHost, userName: userName, userId: userId, userImage: userImage,),
      ),
    );
  }

}
