import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/register_page.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:flutter_application_1/widgets/alert_widget.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:flutter_application_1/widgets/screen_texts.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    var title = "Hoşgeldiniz!";
    var subtitle = "Lütfen öncelikle giriş yapınız👋";
    var email = "Email";
    var sifre = "Şifre";
    var forgotPassword = "Şifremi Unuttum";
    var textLabel2 = 'abc@xyz.com';
    var textLabel3 = 'Şifrenizi Girin';
    var loginWithAccount = 'Hesabınızla Giriş Yapın';
    var dontHaveAccount = 'Henüz bir hesabınız yok mu?';
    var emailAlert = "E-Posta Alanı Boş Bırakılamaz!";
    var emailAlertSubtitle = "Lütfen e-postanızı girin.";
    var passwordAlert = "Şifre Alanı Boş Bırakılamaz!";
    var passwordAlertSubtitle = "Lütfen şifrenizi girin.";
    var userNotFound = "Kullanıcı Bulunamadı!";
    var userNotFoundSubtitle =
        "Hesabınız yoksa aşağıdaki kayıt ol butonunu kullanarak kayıt olabilirsiniz.";
    var wrongPassword = "Şifre Yanlış!";
    var wrongPasswordSubtitle =
        "Şifrenizi yanlış girdiniz, lütfen tekrar deneyin...";
    var resetPassword = "Şifre Sıfırlama";
    var enterEmailHint = "E-posta adresinizi girin.";
    var enterEmail =
        "Şifresini sıfırlamak istediğiniz hesabınızın e-mail adresini girin:";
    var checkEmail = 'E-posta adresinizi kontrol edin.';
    var invalidEmail = "Geçersiz E-Mail Adresi!";
    var invalidEmailSubtitle = "Lütfen geçerli bir E-Mail adresi girin.";

    final _authService = Provider.of<IAuthService>(context, listen: false);
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _resetEmailController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
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
                  height: 70,
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
                    height: 70,
                    maxLines: 1),
                Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                  title: Text(resetPassword),
                                  content: Builder(
                                    builder: (context) {
                                      var height =
                                          MediaQuery.of(context).size.height;
                                      var width =
                                          MediaQuery.of(context).size.width;

                                      return SizedBox(
                                        height: height / 6,
                                        width: width - 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ScreenTexts(
                                                title: enterEmail,
                                                theme: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                                fontW: FontWeight.w400,
                                                textPosition: TextAlign.left),
                                            ScreenTextField(
                                              controller: _resetEmailController,
                                              height: 70,
                                              maxLines: 1,
                                              obscure: false,
                                              textLabel: enterEmailHint,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          try {
                                            await _authService.resetPassword(
                                                email:
                                                    _resetEmailController.text);
                                            SmartDialog.showToast(checkEmail);
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code == 'user-not-found') {
                                              SmartDialog.showToast(
                                                  userNotFound);
                                            } else if (e.code ==
                                                'invalid-email') {
                                              SmartDialog.showToast(
                                                  invalidEmailSubtitle);
                                            }
                                          }
                                        },
                                        child: const Text('Onayla')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('İptal Et')),
                                  ],
                                );
                              });
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
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertWidget(
                                      alertApprove: "Kapat",
                                      alertTitle: emailAlert,
                                      alertSubtitle: emailAlertSubtitle);
                                });
                          } else if (_passwordController.text == "") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertWidget(
                                      alertApprove: "Kapat",
                                      alertTitle: passwordAlert,
                                      alertSubtitle: passwordAlertSubtitle);
                                });
                          } else {
                            try {
                              await _authService.signInEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertWidget(
                                          alertApprove: "Kapat",
                                          alertTitle: userNotFound,
                                          alertSubtitle: userNotFoundSubtitle);
                                    });
                              } else if (e.code == 'wrong-password') {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertWidget(
                                          alertApprove: "Kapat",
                                          alertTitle: wrongPassword,
                                          alertSubtitle: wrongPasswordSubtitle);
                                    });
                              } else if (e.code == 'invalid-email') {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertWidget(
                                          alertApprove: "Kapat",
                                          alertTitle: invalidEmail,
                                          alertSubtitle: invalidEmailSubtitle);
                                    });
                              }
                            }
                          }
                        },
                        child: const Text("Giriş Yap"))),
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
                    Text(dontHaveAccount),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text("Kayıt Ol!"))
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
