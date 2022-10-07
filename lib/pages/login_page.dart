import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/register_page.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
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
    final _authService = Provider.of<IAuthService>(context, listen: false);
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

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
                ScreenTexts(
                    title: forgotPassword,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w300,
                    textPosition: TextAlign.right),
                const SizedBox(height: 50),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          try {
                            await _authService.signInEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print(
                                  'Bu email adresiyle ilişkilendirilmiş bir kullanıcı bulunamadı.');
                            } else if (e.code == 'wrong-password') {
                              print('Yanlış şifre girdiniz.');
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
                BottomText(dontHaveAccount: dontHaveAccount),
              ],
            ),
          ),
        ));
  }
}

class BottomText extends StatelessWidget {
  const BottomText({
    Key? key,
    required this.dontHaveAccount,
  }) : super(key: key);

  final String dontHaveAccount;

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(dontHaveAccount),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: const Text("Kayıt Ol!"))
      ],
    );
  }
}

class ScreenTextField extends StatelessWidget {
  const ScreenTextField({
    Key? key,
    required this.textLabel,
    required this.obscure,
    required this.controller,
    required this.height,
    required this.maxLines,
  }) : super(key: key);
  final textLabel;
  final bool obscure;
  final TextEditingController controller;
  final double height;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: TextFormField(
          maxLines: maxLines,
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: textLabel,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}

class ScreenTexts extends StatelessWidget {
  const ScreenTexts({
    Key? key,
    required this.title,
    required this.theme,
    required this.fontW,
    required this.textPosition,
  }) : super(key: key);
  final String title;
  final TextStyle? theme;
  final FontWeight fontW;
  final TextAlign textPosition;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(title,
              textAlign: textPosition,
              style: theme?.copyWith(fontWeight: fontW, color: Colors.black)),
        ));
  }
}

class ScreenPadding {
  final EdgeInsets screenPadding = const EdgeInsets.fromLTRB(30, 40, 30, 20);
}
