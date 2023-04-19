import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/service/firebase_service.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:pomotodo/views/common/widgets/screen_text_field.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:pomotodo/views/sign_in_view/widgets/sign_in_widget.dart';
import 'package:quickalert/quickalert.dart';

class EditPasswordWidget extends StatefulWidget {
  const EditPasswordWidget({super.key});

  @override
  State<EditPasswordWidget> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPasswordWidget> {
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
    var l10n = L10n.of(context)!;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: ScreenPadding()
              .screenPadding
              .copyWith(top: 10, left: 20, right: 20),
          child: Column(
            children: [
              ScreenTexts(
                  title: l10n.changePassword,
                  theme: Theme.of(context).textTheme.headline4,
                  fontW: FontWeight.w600,
                  textPosition: TextAlign.left),
              ScreenTexts(
                  title: l10n.rePassword,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w400,
                  textPosition: TextAlign.left),
              ScreenTexts(
                  title: l10n.oldPassword,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: l10n.oldPasswordHint,
                  obscure: true,
                  controller: _oldpasswordController,
                  valid: (value) {
                    if (value == null) {
                      return l10n.passwordAlertSubtitle;
                    }
                    return null;
                  },
                  maxLines: 1),
              ScreenTexts(
                  title: l10n.newPasswordText,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: l10n.passwordHint,
                  obscure: true,
                  controller: _passwordController,
                  valid: (value) {
                    if (value == null) {
                      return l10n.passwordAlertSubtitle;
                    }
                    return null;
                  },
                  maxLines: 1),
              Container(height: 30),
              CustomElevatedButton(
                  onPressed: () async {
                    if (_oldpasswordController.text == "") {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: l10n.oldPassword,
                          text: l10n.oldPasswordAlertSubtitle,
                          confirmBtnText: l10n.confirmButtonText);
                    } else if (_passwordController.text == "") {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: l10n.newPasswordAlert,
                          text: l10n.newPasswordAlertSubtitle,
                          confirmBtnText: l10n.confirmButtonText);
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
                            title: l10n.passwordConfirmed,
                            text: l10n.passwordConfirmedSubtitle,
                            confirmBtnText: l10n.alertApprove,
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
                              title: l10n.weakPassword,
                              text: l10n.weakPasswordSubtitle,
                              confirmBtnText: l10n.confirmButtonText);
                        } else if (e.code == 'wrong-password') {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: l10n.wrongPassword,
                              text: l10n.wrongPasswordSubtitle,
                              confirmBtnText: l10n.confirmButtonText);
                        }
                      }
                    }
                  },
                  child: Text(l10n.changePassword))
            ],
          ),
        ),
      ),
    );
  }
}
