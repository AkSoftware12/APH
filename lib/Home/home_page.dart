import 'dart:io';

import 'package:aph/Login/login.dart';
import 'package:aph/Utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AddScreen/add_screen.dart';
import '../Auth/auth_service.dart';
import '../Chat/chat.dart';
import '../Model/popup_choices.dart';
import '../NotificationScreen/notification.dart';
import '../ProfileScreen/profile_screen.dart';
import '../Settings/settings.dart';
import '../Utils/string.dart';
import '../constants/color_constants.dart';
import 'home.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,});


  @override
  _BottomNavBarDemoState createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  AuthService _authService = AuthService();

  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeScreen(),
    NotificationScreen(),
    AddScreen(),
    SettingScreen(),
    ProfileScreen(),
  ];

  final List<PopupChoices> choices = <PopupChoices>[
    PopupChoices(title: 'Log out', icon: Icons.exit_to_app),
  ];
  @override
  void initState() {
    super.initState();

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
                    color: ColorConstants.primaryColor,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    choice.title,
                    style: TextStyle(color: ColorConstants.primaryColor),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                      style: TextStyle(color: ColorConstants.primaryColor, fontWeight: FontWeight.bold),
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
                      style: TextStyle(color: ColorConstants.primaryColor, fontWeight: FontWeight.bold),
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
  void onItemMenuPress(PopupChoices choice) {
    if (choice.title == 'Log out') {
      _showProgressBar(context);
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSelect.background,
        title: const Text(AppConstants.appName,style: TextStyle(color: ColorSelect.black),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chat),  // This line adds the chat icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatPage();
                  },
                ),
              );
            },
          ),
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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorSelect.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorSelect.bottomSelColor,
        unselectedItemColor: ColorSelect.bottomUnSelColor,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items:   [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppConstants.home,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: AppConstants.notification,
          ),
          BottomNavigationBarItem(
            label: '', icon: Container(),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorSelect.textcolor,
        onPressed:(){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChatPage();
              },
            ),
          );

        },
        child:  Icon(Icons.chat,color: ColorSelect.black),
        shape: CircleBorder(),
      ),
    );
  }
}

