import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:pomotodo/core/service/i_auth_service.dart';
import 'package:pomotodo/core/service/mixin_user.dart';

class AuthService with ConvertUser implements IAuthService {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  PomotodoUser _getUser(User? user) {
    return PomotodoUser(userId: user!.uid, userMail: user.email!);
  }

  @override
  Future<PomotodoUser> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    var _tempUser = await _authInstance.createUserWithEmailAndPassword(
        email: email, password: password);
    return convertUser(_tempUser);
  }

  @override
  Stream<PomotodoUser?> get onAuthStateChanged =>
      _authInstance.authStateChanges().map(_getUser);

  @override
  Future<PomotodoUser> signInEmailAndPassword(
      {required String email, required String password}) async {
    var _tempUser = await _authInstance.signInWithEmailAndPassword(
        email: email, password: password);
    return convertUser(_tempUser);
  }

  @override
  Future<PomotodoUser> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    //googleUser?.clearAuthCache();
    UserCredential userCredential =
        await _authInstance.signInWithCredential(credential);
    if(userCredential.user != null){
      
      if (userCredential.additionalUserInfo!.isNewUser) {
      }
    }

    var _tempUser = await _authInstance.signInWithCredential(credential);

    return convertUser(_tempUser);
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _authInstance.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _authInstance.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> editPassword(
      TextEditingController oldPasswordController) {
    AuthCredential authCredential = EmailAuthProvider.credential(
      email: _authInstance.currentUser!.email!,
      password: oldPasswordController.text,
    );
    return _authInstance.currentUser!
        .reauthenticateWithCredential(authCredential);
  }
}
