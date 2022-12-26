import 'package:pomotodo/core/models/pomotodo_user.dart';

abstract class IAuthService {
  Future<PomotodoUser> createUserWithEmailAndPassword(
      {required String email, required String password});
  Future<PomotodoUser> signInEmailAndPassword(
      {required String email, required String password});
  Future<void> signOut();
  Future<void> resetPassword({required String email});
  Stream<PomotodoUser?> get onAuthStateChanged;
}
