import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomotodo/core/providers/dark_theme_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/core/service/i_auth_service.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:pomotodo/views/common/widgets/screen_text_field.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pomotodo/views/sign_up_view/sign_up.view.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
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
    var l10n = L10n.of(context)!;
    final _authService = Provider.of<IAuthService>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: ScreenPadding.screenPadding,
        child: Column(
          children: [
            ScreenTexts(
                title: l10n.welcome,
                theme: Theme.of(context).textTheme.headline4,
                fontW: FontWeight.w600,
                textPosition: TextAlign.left),
            ScreenTexts(
                title: l10n.firstSignIn,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w400,
                textPosition: TextAlign.left),
            const SizedBox(height: 40),
            ScreenTexts(
                title: l10n.email,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
              textLabel: l10n.emailText,
              controller: _emailController,
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            ScreenTexts(
                title: l10n.password,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: l10n.enterPassword,
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
                          title: l10n.enterEmail,
                          confirmBtnText: l10n.alertApprove,
                          cancelBtnText: l10n.alertReject,
                          backgroundColor:
                              context.read<DarkThemeProvider>().darkTheme
                                  ? Colors.black
                                  : Colors.white,
                          titleColor:
                              context.read<DarkThemeProvider>().darkTheme
                                  ? Colors.white
                                  : Colors.black,
                          widget: ScreenTextField(
                            textLabel: l10n.enterEmailHint,
                            controller: _resetEmailController,
                            maxLines: 1,
                          ),
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
                          onCancelBtnTap: () {
                            _resetEmailController.clear();
                            Navigator.pop(context);
                          });
                    },
                    child: Text(l10n.forgotPassword,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontWeight: FontWeight.w300)))),
            const SizedBox(height: 50),
            CustomElevatedButton(
                onPressed: () async {
                  if (_emailController.text == "") {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: l10n.emailAlert,
                        text: l10n.emailAlertSubtitle,
                        confirmBtnText: l10n.confirmButtonText);
                  } else if (_passwordController.text == "") {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: l10n.passwordAlert,
                        text: l10n.passwordAlertSubtitle,
                        confirmBtnText: l10n.confirmButtonText);
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
                            title: l10n.userNotFound,
                            text: l10n.userNotFoundSubtitle,
                            confirmBtnText: l10n.confirmButtonText);
                      } else if (e.code == 'wrong-password') {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: l10n.wrongPassword,
                            text: l10n.wrongPasswordSubtitle,
                            confirmBtnText: l10n.confirmButtonText);
                      } else if (e.code == 'invalid-email') {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: l10n.invalidEmail,
                            text: l10n.invalidEmailSubtitle,
                            confirmBtnText: l10n.confirmButtonText);
                      }
                    }
                  }
                },
                child: Text(l10n.login)),
            const SizedBox(height: 40),
            ScreenTexts(
                title: l10n.loginWithAccount,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w300,
                textPosition: TextAlign.center),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 30,
                  child: InkWell(
                      onTap: () async {
                        try {
                          await _authService.signInWithGoogle();
                        } on PlatformException catch (e) {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: l10n.failedSignIn,
                              text: e.code,
                              confirmBtnText: l10n.confirmButtonText);
                        } catch (e) {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: l10n.failedSignIn,
                              text: l10n.noSignIn,
                              confirmBtnText: l10n.confirmButtonText);
                        }
                      },
                      child: Image.asset("assets/images/google.png",
                          fit: BoxFit.fitHeight))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.dontHaveAccount),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpView()),
                      );
                    },
                    child: Text(l10n.register))
              ],
            )
          ],
        ),
      ),
    );
  }
}
