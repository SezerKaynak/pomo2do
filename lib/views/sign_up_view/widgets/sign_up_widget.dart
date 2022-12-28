import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/core/service/i_auth_service.dart';
import 'package:pomotodo/views/common/widgets/screen_text_field.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:pomotodo/views/sign_in_view/widgets/sign_in_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
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

    return SingleChildScrollView(
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
                controller: _nameController,
                maxLines: 1),
            ScreenTexts(
                title: yourSurname,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: surname,
                controller: _surnameController,
                maxLines: 1),
            ScreenTexts(
                title: email,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: email,
                controller: _emailController,
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
              controller: _birthdayController,
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
    );
  }
}
