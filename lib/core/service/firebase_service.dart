import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:pomotodo/core/service/i_auth_service.dart';
import 'package:pomotodo/core/service/mixin_user.dart';
import 'package:googleapis/people/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

final FirebaseAuth _authInstance = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn =
    GoogleSignIn(scopes: [PeopleServiceApi.userBirthdayReadScope]);

class AuthService with ConvertUser implements IAuthService {
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
    final googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    var _tempUser = await _authInstance.signInWithCredential(credential);

    var peopleApi =
        PeopleServiceApi((await _googleSignIn.authenticatedClient())!);

    var birthday =
        await peopleApi.people.get("people/me", personFields: 'birthdays');

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'email': googleUser!.email,
      'name': googleUser.displayName!.split(' ')[0],
      'surname': googleUser.displayName!.split(' ').length > 1
          ? googleUser.displayName!.split(' ')[1]
          : "",
      'birthday':
          '${birthday.birthdays![0].date!.day}.${birthday.birthdays![0].date!.month}.${birthday.birthdays![0].date!.year}'
    });
    googleUser.clearAuthCache();
    return convertUser(_tempUser);
  }

  @override
  Future<void> signOut() async {
    if (_googleSignIn.currentUser != null) {
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint("olmadı");
      }
    }
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
