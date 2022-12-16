import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:flutter_application_1/widgets/screen_texts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

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
                textFieldInputType: TextInputType.none,
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
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: nameAlert,
                              text: nameAlertSubtitle,
                              confirmBtnText: "Kapat");
                        } else if (_passwordController.text == "") {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: surnameAlert,
                              text: surnameAlertSubtitle,
                              confirmBtnText: "Kapat");
                        } else if (_nameController.text == "") {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: emailAlert,
                              text: emailAlertSubtitle,
                              confirmBtnText: "Kapat");
                        } else if (_surnameController.text == "") {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: passwordAlert,
                              text: passwordAlertSubtitle,
                              confirmBtnText: "Kapat");
                        } else if (_birthdayController.text == "") {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: birthdayAlert,
                              text: birthdayAlertSubtitle,
                              confirmBtnText: "Kapat");
                        } else {
                          try {
                            await _authService.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: weakPassword,
                                  text: weakPasswordSubtitle,
                                  confirmBtnText: "Kapat");
                            } else if (e.code == 'email-already-in-use') {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: emailAlreadyInUse,
                                  text: emailAlreadyInUseSubtitle,
                                  confirmBtnText: "Kapat");
                            } else if (e.code == 'invalid-email') {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: invalidEmail,
                                  text: invalidEmailSubtitle,
                                  confirmBtnText: "Kapat");
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
