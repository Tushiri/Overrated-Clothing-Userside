import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isloading = false.obs;

  //textcontrollers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var forgotController = TextEditingController();

  final googleSignIn = GoogleSignIn();
  final logger = Logger();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  //login method

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //signup method

  Future<UserCredential?> singupMethod({email, password, context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //storing data method
  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set(
      {
        'name': name,
        'password': password,
        'email': email,
        'imageUrl': '',
        'id': currentUser!.uid,
        'cart_count': "00",
        'wishlist_count': "00",
        'order_count': "00",
      },
    );
  }

  //signout method

  signoutMethod(context) async {
    try {
      await auth.signOut();
      Get.reset();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  //forgot password method

  forgetPassword({email, context}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  //google signup method

  Future<UserCredential?> googleLogin({context}) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      // Store user data in the database
      await storeUserData(
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        password: '', // Google Sign-In doesn't provide password
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
      return null;
    }
  }

  Future<void> googleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      logger.e('Error signing out: $e');
    }
  }
}
