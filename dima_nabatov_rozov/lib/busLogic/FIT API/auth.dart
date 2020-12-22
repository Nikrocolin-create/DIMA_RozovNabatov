import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Multi subscription streams
  Observable<User> user;            // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  // constructor
  AuthService() {
    // it'll change every time user signs in or signs out
    user = Observable(_auth.authStateChanges());

    // get value of the user id
    // switchMap listens to the value of user Observable
    profile = user.switchMap((User u) {
      if (u != null) {
        // search for observable from this data for user
        // then we grap a document with user id, then grap the snapshot 
        // and then map actual snapshot to the actudal data 
        return _db.collection('users').doc(u.uid).snapshots().map((snap) => snap.data());
      } else {
        // if user is not in it
        // we'll return some observable data (empty object)
        return Observable.just({ });
      }
    });
  }

  // Will be used when user taps the button
  Future<User> googleSignIn() async {
    loading.add(true);
    // sign in with google
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    // pass it to the firebase

    AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    UserCredential authResult = await _auth.signInWithCredential(authCredential);

    User u = authResult.user;

    updateUserData(u);
    print("signed in " + u.displayName);

    loading.add(false);
    return u;
  }

  // will update the record in firestore
  void updateUserData(User user) async {
    // do the reference to the same document
    DocumentReference ref = _db.collection('users').doc(user.uid);

    return ref.set({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoURL,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, SetOptions(merge: true));
  }

  void signOut() {
    _auth.signOut();
  }
}

final AuthService authService = AuthService();