import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:flutter_application_1/service/mixin_user.dart';



class AuthService with ConvertUser implements IAuthService{
  final FirebaseAuth _authInstance = FirebaseAuth.instance;


  PomotodoUser _getUser(User? user){
    return PomotodoUser(userId: user!.uid, userMail: user.email!);
  }
  @override
  Future<PomotodoUser> createUserWithEmailAndPassword ({required String email, required String password}) async {
    var _tempUser = await _authInstance.createUserWithEmailAndPassword(email: email, password: password);
    return convertUser(_tempUser);
  }

  @override
  Stream<PomotodoUser?> get onAuthStateChanged => _authInstance.authStateChanges().map(_getUser);

  @override
  Future<PomotodoUser> signInEmailAndPassword({required String email, required String password}) async {
    var _tempUser = await _authInstance.signInWithEmailAndPassword(email: email, password: password);
    return convertUser(_tempUser);
  }

  @override
  Future<void> signOut() async {
    await _authInstance.signOut();
  }
  @override
  Future<void> resetPassword({required String email}) async {
    await _authInstance.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> editPassword(TextEditingController oldPasswordController) {
    AuthCredential authCredential = EmailAuthProvider.credential(
      email: _authInstance.currentUser!.email!,
      password: oldPasswordController.text,
    );
    return _authInstance.currentUser!.reauthenticateWithCredential(authCredential);
  }
}