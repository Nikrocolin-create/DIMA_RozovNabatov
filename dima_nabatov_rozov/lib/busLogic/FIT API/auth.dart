//import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:rxdart/rxdart.dart';

class AuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email'
      'https://www.googleapis.com/auth/fitness.activity.read'
      'https://www.googleapis.com/auth/fitness.activity.write',
      'https://www.googleapis.com/auth/fitness.body.read',
      'https://www.googleapis.com/auth/fitness.body.write	',
      'https://www.googleapis.com/auth/fitness.location.read',
      'https://www.googleapis.com/auth/fitness.location.write'
    ]
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
   // Will be used when user taps the button
  Future<String> googleSignIn() async {
    
   // await Firebase.initializeApp();

    // sign in with google
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    // pass it to the firebase

    AuthCredential authCredential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    final FirebaseUser user = await _auth.signInWithCredential(authCredential);
    //final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}