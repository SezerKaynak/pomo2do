import 'package:firebase_auth/firebase_auth.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';

mixin ConvertUser{
  PomotodoUser convertUser(UserCredential user){
    return PomotodoUser(userId: user.user!.uid, userMail: user.user!.email!, userPhotoUrl: user.user!.photoURL, loginProviderData: false);
  }
}