import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/project_theme_options.dart';
import 'package:flutter_application_1/service/firebase_service.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final _formKey = GlobalKey<FormState>();
  var newPassword = " ";
  var register = "Şifreyi Değiştir";
  var subtitle =
      "Aşağıdaki alanları doldurarak şifrenizi yenileyebilirsiniz 🙂";
  var oldPassword = "Eski Şifre";
  var oldPasswordHint = "Eski Şifrenizi Girin";
  var password = "Yeni Şifre";
  var passwordHint = "Yeni Şifrenizi Girin";
  var oldPasswordAlert = "Eski Şifre Alanı Boş Bırakılamaz!";
  var oldPasswordAlertSubtitle = "Lütfen eski şifrenizi girin.";
  var passwordAlert = "Yeni Şifre Alanı Boş Bırakılamaz!";
  var passwordAlertSubtitle = "Lütfen yeni şifrenizi girin.";
  var passwordConfirmed = 'Şifreniz Başarıyla Değiştirildi.';
  var passwordConfirmedSubtitle =
      'Lütfen yeni şifrenizi kullanarak tekrar giriş yapınız.';
  var weakPassword = "Güçsüz Şifre!";
  var weakPasswordSubtitle = "Girdiğiniz şifre minimum 6 haneden oluşmalı!";
  var wrongPassword = "Yanlış Şifre";
  var wrongPasswordSubtitle = "Eski şifrenizi yanlış girdiniz!";
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.blueGrey[300])),
        actions: [
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child:
                      CircularProgressIndicator(color: Colors.blueGrey[300])),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: ScreenPadding().screenPadding.copyWith(top: 0),
            child: Column(
              children: [
                ScreenTexts(
                    title: register,
                    theme: Theme.of(context).textTheme.headline4,
                    fontW: FontWeight.w600,
                    textPosition: TextAlign.left),
                ScreenTexts(
                    title: subtitle,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w400,
                    textPosition: TextAlign.left),
                ScreenTexts(
                    title: oldPassword,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: oldPasswordHint,
                    obscure: true,
                    controller: _oldpasswordController,
                    valid: (value) {
                      if (value == null) {
                        return "Please enter password";
                      }
                      return null;
                    },
                    height: 70,
                    maxLines: 1),
                ScreenTexts(
                    title: password,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: passwordHint,
                    obscure: true,
                    controller: _passwordController,
                    valid: (value) {
                      if (value == null) {
                        return "Please enter password";
                      }
                      return null;
                    },
                    height: 70,
                    maxLines: 1),
                Container(height: 30),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          if (_oldpasswordController.text == "") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertWidget(
                                      alertTitle: oldPasswordAlert,
                                      alertSubtitle: oldPasswordAlertSubtitle);
                                });
                          } else if (_passwordController.text == "") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertWidget(
                                      alertTitle: passwordAlert,
                                      alertSubtitle: passwordAlertSubtitle);
                                });
                          } else {
                            try {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  newPassword = _passwordController.text;
                                  isLoading = true;
                                });

                                await editPassword();

                                await currentUser!.updatePassword(newPassword);

                                setState(() {
                                  isLoading = false;
                                });
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        title: Text(passwordConfirmed),
                                        content: Text(passwordAlertSubtitle),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              _authService.signOut();
                                            },
                                            child: Text(
                                              "Kapat",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  ?.copyWith(
                                                      color:
                                                          ProjectThemeOptions()
                                                              .backGroundColor),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              if (e.code == 'weak-password') {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertWidget(
                                          alertTitle: weakPassword,
                                          alertSubtitle: weakPasswordSubtitle);
                                    });
                              } else if (e.code == 'wrong-password') {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertWidget(
                                          alertTitle: wrongPassword,
                                          alertSubtitle: wrongPasswordSubtitle);
                                    });
                              }
                            }
                          }
                        },
                        child: const Text("Şifreyi Değiştir"))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> editPassword() {
    AuthCredential authCredential = EmailAuthProvider.credential(
      email: currentUser!.email ?? '',
      password: _oldpasswordController.text,
    );
    return currentUser!.reauthenticateWithCredential(authCredential);
  }
}
