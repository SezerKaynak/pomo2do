import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return PomotodoUser(
        userId: user!.uid,
        userMail: user.email!,
        userPhotoUrl: user.photoURL,
        loginProviderData:
            user.providerData.map((e) => e.providerId).contains('google.com'));
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

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    OAuthCredential? credential;
    UserCredential? _tempUser;

    try {
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      _tempUser = await _authInstance.signInWithCredential(credential);
      var peopleApi =
          PeopleServiceApi((await _googleSignIn.authenticatedClient())!);

      Person person =
          await peopleApi.people.get("people/me", personFields: 'birthdays');

      Birthday birthday = person.birthdays!.first;

      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');

      await users.doc(FirebaseAuth.instance.currentUser!.uid).set({
        'email': googleUser!.email,
        'name': googleUser.displayName!.split(' ')[0],
        'surname': googleUser.displayName!.split(' ').length > 1
            ? googleUser.displayName!.split(' ')[1]
            : "",
        'birthday':
            '${birthday.date!.day}.${birthday.date!.month}.${birthday.date!.year}',
        'userPhotoUrl': _tempUser.user!.photoURL
      });

      return convertUser(_tempUser);
    } on FirebaseAuthException catch (_) {
      googleUser!.clearAuthCache();
      throw PlatformException(code: "Lütfen tekrar giriş yapmayı deneyin.");
    } catch (e) {
      throw Exception("Giriş yapılamadı");
    }
  }

  @override
  Future<void> signOut() async {
    await _authInstance.signOut().then((_) {
      _googleSignIn.signOut();
    });
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
