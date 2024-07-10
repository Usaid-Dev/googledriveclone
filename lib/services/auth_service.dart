import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //Google Sign in
  signInWithGoogle() async {
    //Begin interactive sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //Obtain auth details from request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //Create a new crendtial for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //Finally, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
