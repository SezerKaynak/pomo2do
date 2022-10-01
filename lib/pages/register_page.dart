import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);

    var register = "Kayıt Ol";
    var subtitle = "Aşağıdaki alanları doldurarak kaydolabilirsiniz.🙂";
    var name = "Ad";
    var surname = "Soyad";
    var email = "Email";
    var password = "Şifre";
    var yourName = "Adınız";
    var yourSurname = "Soyadınız";

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  ModalRoute.withName("/Home"));
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.blueGrey[300])),
      ),
      body: Padding(
        padding: ScreenPadding().screenPadding,
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
                title: yourName,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: name,
                obscure: false,
                controller: Controllers()._nameController),
            ScreenTexts(
                title: yourSurname,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: surname,
                obscure: false,
                controller: Controllers()._surnameController),
            ScreenTexts(
                title: email,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: email,
                obscure: false,
                controller: Controllers()._emailController),
            ScreenTexts(
                title: password,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: password,
                obscure: false,
                controller: Controllers()._passwordController),
            Container(height: 30),
            SizedBox(
                width: 400,
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    // onPressed: () async {
                    //   await _authService.signInEmailAndPassword(
                    //       email: Controllers()._emailController.text,
                    //       password: Controllers()._passwordController.text);
                    // },
                    onPressed: () async {
                      await _authService.createUserWithEmailAndPassword(
                          email: "deneme1@gmail.com", password: "12345678");
                    },
                    child: const Text("Kayıt Ol"))),
          ],
        ),
      ),
    );
  }
}

class Controllers {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
}
