import 'package:firebase_auth/firebase_auth.dart';

import '../models/pomotodo_user.dart';

mixin ConvertUser{
  PomotodoUser convertUser(UserCredential user){
    return PomotodoUser(userId: user.user!.uid, userMail: user.user!.email!);
  }
}