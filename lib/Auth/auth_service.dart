import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/firestore_constants.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final String _loggedInKey = 'loggedIn';






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

      // Write data to local storage

      SharedPreferences prefs = await SharedPreferences.getInstance();

      User? currentUser = firebaseUser;
      await prefs.setString(FirestoreConstants.id, currentUser!.uid);
      await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? "");
      await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
      await prefs.setString(FirestoreConstants.userEmail, currentUser.email ?? "");
      prefs.setBool(_loggedInKey, true);



    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }



  Future<void> logout() async {
    await _googleSignIn.signOut();

    // Clear login status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loggedInKey, false);
    prefs.remove(FirestoreConstants.id,);
    prefs.remove(FirestoreConstants.nickname,);
    prefs.remove(FirestoreConstants.photoUrl,);
    prefs.remove(FirestoreConstants.userEmail,);


  }

}
