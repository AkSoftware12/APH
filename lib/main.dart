import 'dart:io';

import 'package:aph/Admin/home_admin.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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


class AuthenticationWrapper extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching user data
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else {
          // Retrieve user data from snapshot
          final userData = snapshot.data;
          // Check if user is logged in
          final bool isLoggedIn = userData != null;
          if (isLoggedIn) {
            // Check user role
            final String userRole = 'role'; // Assuming 'role' is a key in user data
            // Navigate based on user role
            switch (userRole) {
              case 'admin':
              // Navigate to admin page
                return AdminPage(); // Replace AdminHomePage with your admin page
              case '':
              // Navigate to user page
                return MyHomePage(); // Replace MyHomePage with your user page
              default:
              // If user role is not defined or unrecognized, handle it accordingly
                return LoginPage(); // Redirect to login page or any default page
            }
          } else {
            // If user is not logged in, show login page
            // return LoginPage();
            return LoginPage();
          }
        }
      },
    );
  }
}



