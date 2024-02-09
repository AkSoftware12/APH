import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Auth/auth_service.dart';
import 'DemoChat/helper/helper_function.dart';
import 'DemoChat/pages/auth/login_page.dart';
import 'DemoChat/pages/home_page.dart';
import 'DemoChat/shared/constants.dart';
import 'Home/home_page.dart';
import 'Login/login.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
Future main() async {
  HttpOverrides.global = MyHttpOverrides();
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
  runApp(MyApp());

}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key,});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home:  AuthenticationWrapper(),
//       // home:   MyHomePage(),
//     );
//   }
// }
// class AuthenticationWrapper extends StatelessWidget {
//   @override
//
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: AuthService().isUserLoggedIn(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Show a loading indicator while the Future is still running
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // Handle error case
//           return Text('Error: ${snapshot.error}');
//         } else {
//           // Use the result of the Future to determine UI
//           bool isLoggedIn = snapshot.data ?? false;
//           return isLoggedIn ? MyHomePage() : LoginScreen();
//         }
//       },
//     );
//   }
// }



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Constants().primaryColor,
          scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const MyHomePage() : const LoginPage(),


    );
  }
}