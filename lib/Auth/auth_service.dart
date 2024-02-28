import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DemoChat/helper/helper_function.dart';
import '../DemoChat/service/database_service.dart';
import '../constants/firestore_constants.dart';

class AuthService {
  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  // bool isLoggedIn = false;
  //
  //
  //
  //
  //
  //
  // Future<bool> isUserLoggedIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool(isLoggedIn as String) ?? false;
  // }
  // // Future<bool?> loginWithGoogle() async {
  // //   try {
  // //     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  // //     final GoogleSignInAuthentication googleSignInAuthentication =
  // //     await googleSignInAccount!.authentication;
  // //
  // //     final AuthCredential credential = GoogleAuthProvider.credential(
  // //       accessToken: googleSignInAuthentication.accessToken,
  // //       idToken: googleSignInAuthentication.idToken,
  // //     );
  // //     User? firebaseUser = (await _auth.signInWithCredential(credential)).user;
  // //     // Write data to local storage
  // //
  // //     SharedPreferences prefs = await SharedPreferences.getInstance();
  // //
  // //     User? currentUser = firebaseUser;
  // //     await prefs.setString(FirestoreConstants.id, currentUser!.uid);
  // //     await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? "");
  // //     await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
  // //     await prefs.setString(FirestoreConstants.userEmail, currentUser.email ?? "");
  // //     prefs.setBool(_loggedInKey, true);
  // //
  // //     if (currentUser != null) {
  // //       // call our database service to update the user data.
  // //       await DatabaseService(uid: currentUser.uid).savingUserData(
  // //           FirestoreConstants.nickname, FirestoreConstants.photoUrl,
  // //       );
  // //       return true;
  // //     }
  // //
  // //   } catch (e) {
  // //     print(e.toString());
  // //     return null;
  // //   }
  // //   return null;
  // // }
  //
  //
  //
  // // Future<void> logout() async {
  // //   await _googleSignIn.signOut();
  // //
  // //   // Clear login status
  // //   SharedPreferences prefs = await SharedPreferences.getInstance();
  // //   prefs.setBool(_loggedInKey, false);
  // //   prefs.remove(FirestoreConstants.id,);
  // //   prefs.remove(FirestoreConstants.nickname,);
  // //   prefs.remove(FirestoreConstants.photoUrl,);
  // //   prefs.remove(FirestoreConstants.userEmail,);
  // //
  // //
  // // }
  // //
  // //
  // // // login
  // // Future loginWithUserNameandPassword(String email, String password) async {
  // //   try {
  // //     User user = (await firebaseAuth.signInWithEmailAndPassword(
  // //         email: email, password: password))
  // //         .user!;
  // //     SharedPreferences prefs = await SharedPreferences.getInstance();
  // //     prefs.setBool(_loggedInKey, true);
  // //
  // //     await prefs.setString(FirestoreConstants.id, user!.uid);
  // //     await prefs.setString(FirestoreConstants.nickname, user.uid ?? "");
  // //     await prefs.setString(FirestoreConstants.userEmail, user.email ?? "");
  // //     if (user != null) {
  // //       return true;
  // //     }
  // //   } on FirebaseAuthException catch (e) {
  // //     return e.message;
  // //   }
  // // }
  // //
  // // // register
  // // Future registerUserWithEmailandPassword(
  // //     String fullName, String email, String password) async {
  // //   try {
  // //     User user = (await firebaseAuth.createUserWithEmailAndPassword(
  // //         email: email, password: password))
  // //         .user!;
  // //
  // //
  // //
  // //     if (user != null) {
  // //       // call our database service to update the user data.
  // //       await DatabaseService(uid: user.uid).savingUserData(fullName, email);
  // //       SharedPreferences prefs = await SharedPreferences.getInstance();
  // //       prefs.setBool(_loggedInKey, true);
  // //
  // //       await prefs.setString(FirestoreConstants.id, user!.uid);
  // //       await prefs.setString(FirestoreConstants.nickname, user.uid ?? "");
  // //       await prefs.setString(FirestoreConstants.userEmail, user.email ?? "");
  // //       return true;
  // //     }
  // //   } on FirebaseAuthException catch (e) {
  // //     return e.message;
  // //   }
  // // }
  // //
  // // // signout
  // // Future signOut() async {
  // //   try {
  // //     await HelperFunctions.saveUserLoggedInStatus(false);
  // //     await HelperFunctions.saveUserEmailSF("");
  // //     await HelperFunctions.saveUserNameSF("");
  // //     await firebaseAuth.signOut();
  // //
  // //
  // //     SharedPreferences prefs = await SharedPreferences.getInstance();
  // //     prefs.setBool(_loggedInKey, false);
  // //     prefs.remove(FirestoreConstants.id,);
  // //     prefs.remove(FirestoreConstants.nickname,);
  // //     prefs.remove(FirestoreConstants.userEmail,);
  // //
  // //   } catch (e) {
  // //     return null;
  // //   }
  // // }
  //



}
