import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/register_page.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:flutter_application_1/widgets/screen_texts.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter_application_1/assets/constants.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _resetEmailController;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _resetEmailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _authService = Provider.of<IAuthService>(context, listen: false);

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: ScreenPadding().screenPadding,
            child: Column(
              children: [
                ScreenTexts(
                    title: title,
                    theme: Theme.of(context).textTheme.headline4,
                    fontW: FontWeight.w600,
                    textPosition: TextAlign.left),
                ScreenTexts(
                    title: subtitle,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w400,
                    textPosition: TextAlign.left),
                const SizedBox(height: 40),
                ScreenTexts(
                    title: email,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                  textLabel: textLabel2,
                  obscure: false,
                  controller: _emailController,
                  maxLines: 1,
                ),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: sifre,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: textLabel3,
                    obscure: true,
                    controller: _passwordController,
                    maxLines: 1),
                Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.custom,
                              showCancelBtn: true,
                              title: enterEmail,
                              confirmBtnText: 'Onayla',
                              cancelBtnText: 'İptal Et',
                              widget: ScreenTextField(
                                  textLabel: enterEmailHint,
                                  obscure: false,
                                  controller: _resetEmailController,
                                  maxLines: 1),
                              onConfirmBtnTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                try {
                                  await _authService.resetPassword(
                                      email: _resetEmailController.text);
                                  SmartDialog.showToast(checkEmail);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    SmartDialog.showToast(userNotFound);
                                  } else if (e.code == 'invalid-email') {
                                    SmartDialog.showToast(invalidEmailSubtitle);
                                  }
                                }
                              },
                              onCancelBtnTap: () => Navigator.pop(context));
                        },
                        child: Text(forgotPassword,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(fontWeight: FontWeight.w300)))),
                const SizedBox(height: 50),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          if (_emailController.text == "") {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: emailAlert,
                                text: emailAlertSubtitle,
                                confirmBtnText: confirmButtonText);
                          } else if (_passwordController.text == "") {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: passwordAlert,
                                text: passwordAlertSubtitle,
                                confirmBtnText: confirmButtonText);
                          } else {
                            try {
                              await _authService.signInEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: userNotFound,
                                    text: userNotFoundSubtitle,
                                    confirmBtnText: confirmButtonText);
                              } else if (e.code == 'wrong-password') {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: wrongPassword,
                                    text: wrongPasswordSubtitle,
                                    confirmBtnText: confirmButtonText);
                              } else if (e.code == 'invalid-email') {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: invalidEmail,
                                    text: invalidEmailSubtitle,
                                    confirmBtnText: confirmButtonText);
                              }
                            }
                          }
                        },
                        child: const Text(login))),
                const SizedBox(height: 40),
                ScreenTexts(
                    title: loginWithAccount,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w300,
                    textPosition: TextAlign.center),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 30,
                      child: InkWell(
                          onTap: () {},
                          child: Image.asset("assets/google.png",
                              fit: BoxFit.fitHeight))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(dontHaveAccount),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text(register))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class ScreenPadding {
  final EdgeInsets screenPadding = const EdgeInsets.fromLTRB(30, 40, 30, 20);
}
