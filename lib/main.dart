import 'dart:io';

import 'package:aph/Admin/home_admin.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'Auth/auth_service.dart';
import 'DemoChat/helper/helper_function.dart';
import 'DemoChat/pages/auth/login_page.dart';
import 'DemoChat/pages/home_page.dart';
import 'DemoChat/shared/constants.dart';
import 'Home/home_page.dart';
import 'Login/login.dart';

// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }
Future main() async {
  // HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ? await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid
        ? const FirebaseOptions(
      apiKey: 'AIzaSyDJhqaxbFUoEouW04cpYcdaMCdQgdtVb98',
      appId: '1:279206444482:android:8b2ca8492f538f17ab6a5b',
      messagingSenderId: '279206444482',
      projectId: 'aph-9bada',
      storageBucket: "aph-9bada.appspot.com",
    )
        : null,
  ) : await Firebase.initializeApp();





  await FirebaseAppCheck.instance.activate();
  ZegoUIKit().initLog().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  AuthenticationWrapper(),
      // home:   PhoneAuthScreen(),
    );
  }
}


class AuthenticationWrapper extends StatefulWidget {


  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if user credentials exist
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (loggedIn) {
      // If user is logged in, navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      // If user is not logged in, navigate to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // You can show a loading indicator or splash screen here
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


