import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/service/firebase_service.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:flutter_application_1/widgets/screen_texts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter_application_1/assets/constants.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  String newPassword = " ";
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
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
            padding: ScreenPadding()
                .screenPadding
                .copyWith(top: 10, left: 20, right: 20),
            child: Column(
              children: [
                ScreenTexts(
                    title: changePassword,
                    theme: Theme.of(context).textTheme.headline4,
                    fontW: FontWeight.w600,
                    textPosition: TextAlign.left),
                ScreenTexts(
                    title: subtitle3,
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
                        return "Lütfen şifrenizi giriniz";
                      }
                      return null;
                    },
                    height: 70,
                    maxLines: 1),
                ScreenTexts(
                    title: newPasswordText,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: passwordHint,
                    obscure: true,
                    controller: _passwordController,
                    valid: (value) {
                      if (value == null) {
                        return "Lütfen şifrenizi giriniz";
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
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: oldPassword,
                                text: oldPasswordAlertSubtitle,
                                confirmBtnText: "Kapat");
                          } else if (_passwordController.text == "") {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: newPasswordAlert,
                                text: newPasswordAlertSubtitle,
                                confirmBtnText: "Kapat");
                          } else {
                            try {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  newPassword = _passwordController.text;
                                  isLoading = true;
                                });

                                await _authService
                                    .editPassword(_oldpasswordController);

                                await currentUser!.updatePassword(newPassword);

                                setState(() {
                                  isLoading = false;
                                });

                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  title: passwordConfirmed,
                                  text: newPasswordAlertSubtitle,
                                  confirmBtnText: "Onayla",
                                  onConfirmBtnTap: () {
                                    _authService.signOut();
                                  },
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              if (e.code == 'weak-password') {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: weakPassword,
                                    text: weakPasswordSubtitle,
                                    confirmBtnText: "Kapat");
                              } else if (e.code == 'wrong-password') {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: wrongPassword,
                                    text: wrongPasswordSubtitle,
                                    confirmBtnText: "Kapat");
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
}
