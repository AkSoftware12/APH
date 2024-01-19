import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firestore_constants.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final String _loggedInKey = 'loggedIn';

   final String _userNameKey = 'userName';
  final String _userEmailKey = 'userEmail';
  final String _userImageKey = 'userImage';




  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }
  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      User? firebaseUser = (await _auth.signInWithCredential(credential)).user;

      // final UserCredential authResult = await _auth.signInWithCredential(credential);
      // final User? user = authResult.user;

      // assert(user!.email != null);
      // assert(user!.displayName != null);
      // assert(user!.photoURL != null);



      // Write data to local storage

      SharedPreferences prefs = await SharedPreferences.getInstance();

      User? currentUser = firebaseUser;
      await prefs.setString(FirestoreConstants.id, currentUser!.uid);
      await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? "");
      await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
      await prefs.setString(FirestoreConstants.userEmail, currentUser.email ?? "");

      // print('Signed in: ${user?.displayName}');


      // Store user details
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('userEmail', user!.displayName!);
      // prefs.setString(_userEmailKey, user.email!);
      // prefs.setString(_userImageKey, user.photoURL!);
      prefs.setBool(_loggedInKey, true);


      // Perform additional tasks if needed (e.g., exchange token with server)

      // Store login status

      // return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // Future<void> loginWithGoogle() async {
  //   try {
  //     GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //
  //     if (googleUser == null) {
  //       // User cancelled the sign-in
  //       return;
  //     }
  //
  //     // Perform additional tasks if needed (e.g., exchange token with server)
  //
  //     // Store login status
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setBool(_loggedInKey, true);
  //   } catch (error) {
  //     // Handle errors
  //     print('Error signing in with Google: $error');
  //   }
  // }

  Future<void> logout() async {
    await _googleSignIn.signOut();

    // Clear login status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loggedInKey, false);


  }

  Future<String?> getUserDisplayName() async {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    return user?.displayName;
  }

  Future<String?> getUserEmail() async {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    return user?.email;
  }

  Future<String?> getUserProfileImage() async {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    return user?.photoUrl;
  }

}
