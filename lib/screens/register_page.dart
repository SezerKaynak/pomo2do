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
import 'package:flutter_application_1/assets/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _birthdayController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _birthdayController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);

    return Scaffold(
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
                  title: subtitle2,
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
                              confirmBtnText: confirmButtonText);
                        } else if (_passwordController.text == "") {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: surnameAlert,
                              text: surnameAlertSubtitle,
                              confirmBtnText: confirmButtonText);
                        } else if (_nameController.text == "") {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: emailAlert,
                              text: emailAlertSubtitle,
                              confirmBtnText: confirmButtonText);
                        } else if (_surnameController.text == "") {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: passwordAlert,
                              text: passwordAlertSubtitle,
                              confirmBtnText: confirmButtonText);
                        } else if (_birthdayController.text == "") {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: birthdayAlert,
                              text: birthdayAlertSubtitle,
                              confirmBtnText: confirmButtonText);
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
                                  confirmBtnText: confirmButtonText);
                            } else if (e.code == 'email-already-in-use') {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: emailAlreadyInUse,
                                  text: emailAlreadyInUseSubtitle,
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
