import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGoogleService {

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Will be used when user taps the button
  Future<String> googleSignIn() async {

    // sign in with Google
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      return 'null user';
    } else {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // pass it to the firebase

      AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);

      return 'signInWithGoogle succeded';
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

}