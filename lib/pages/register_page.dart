import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    var yourBirthday = "Doğum Tarihiniz";
    var weakPassword = "Güçsüz Şifre!";
    var weakPasswordSubtitle = "Girdiğiniz şifre minimum 6 haneden oluşmalı!";
    var emailAlreadyInUse = "Geçersiz E-Posta!";
    var emailAlreadyInUseSubtitle =
        "Girdiğiniz E-posta adresi başka bir hesaba bağlı!";
    var emailAlert = "E-Posta Alanı Boş Bırakılamaz!";
    var emailAlertSubtitle = "Lütfen e-postanızı girin.";
    var passwordAlert = "Şifre Alanı Boş Bırakılamaz!";
    var passwordAlertSubtitle = "Lütfen şifrenizi girin.";
    var nameAlert = "İsim Alanı Boş Bırakılamaz!";
    var nameAlertSubtitle = "Lütfen isminizi girin.";
    var surnameAlert = "Soy İsim Alanı Boş Bırakılamaz!";
    var surnameAlertSubtitle = "Lütfen soy isminizi girin.";
    var birthdayAlert = "Doğum Tarihi Alanı Boş Bırakılamaz!";
    var birthdayAlertSubtitle = "Lütfen doğum tarihinizi seçin.";
    var invalidEmail = "Geçersiz E-Mail Adresi!";
    var invalidEmailSubtitle = "Lütfen geçerli bir E-Mail adresi girin.";

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _surnameController = TextEditingController();
    final TextEditingController _birthdayController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.blueGrey[300])),
      ),
      body: SingleChildScrollView(
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
                  title: yourName,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: name,
                  obscure: false,
                  controller: _nameController,
                  height: 70,
                  maxLines: 1),
              ScreenTexts(
                  title: yourSurname,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: surname,
                  obscure: false,
                  controller: _surnameController,
                  height: 70,
                  maxLines: 1),
              ScreenTexts(
                  title: email,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: email,
                  obscure: false,
                  controller: _emailController,
                  height: 70,
                  maxLines: 1),
              ScreenTexts(
                  title: password,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: password,
                  obscure: true,
                  controller: _passwordController,
                  height: 70,
                  maxLines: 1),
              ScreenTexts(
                  title: yourBirthday,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                onTouch: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd.MM.yyyy').format(pickedDate);

                    _birthdayController.text = formattedDate;
                  } else {}
                },
                con: const Icon(Icons.calendar_today),
                textLabel: yourBirthday,
                obscure: false,
                controller: _birthdayController,
                height: 70,
                maxLines: 1,
              ),
              Container(height: 30),
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
                                    alertTitle: nameAlert,
                                    alertSubtitle: nameAlertSubtitle);
                              });
                        } else if (_passwordController.text == "") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertWidget(
                                    alertTitle: surnameAlert,
                                    alertSubtitle: surnameAlertSubtitle);
                              });
                        } else if (_nameController.text == "") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertWidget(
                                    alertTitle: emailAlert,
                                    alertSubtitle: emailAlertSubtitle);
                              });
                        } else if (_surnameController.text == "") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertWidget(
                                    alertTitle: passwordAlert,
                                    alertSubtitle: passwordAlertSubtitle);
                              });
                        } else if (_birthdayController.text == "") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertWidget(
                                    alertTitle: birthdayAlert,
                                    alertSubtitle: birthdayAlertSubtitle);
                              });
                        } else {
                          try {
                            await _authService.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertWidget(
                                        alertTitle: weakPassword,
                                        alertSubtitle: weakPasswordSubtitle);
                                  });
                            } else if (e.code == 'email-already-in-use') {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertWidget(
                                        alertTitle: emailAlreadyInUse,
                                        alertSubtitle:
                                            emailAlreadyInUseSubtitle);
                                  });
                            } else if (e.code == 'invalid-email') {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertWidget(
                                        alertTitle: invalidEmail,
                                        alertSubtitle: invalidEmailSubtitle);
                                  });
                            }
                          }
                          CollectionReference users =
                              FirebaseFirestore.instance.collection('Users');

                          users
                              // ignore: use_build_context_synchronously
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            'email': _emailController.text,
                            'name': _nameController.text,
                            'surname': _surnameController.text,
                            'birthday': _birthdayController.text
                          });
                        }
                      },
                      child: const Text("Kayıt Ol"))),
            ],
          ),
        ),
      ),
    );
  }
}
