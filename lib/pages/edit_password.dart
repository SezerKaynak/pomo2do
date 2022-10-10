import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/person_info.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final _formKey = GlobalKey<FormState>();
  var newPassword = " ";
  var register = "Şifreyi Değiştir";
  var subtitle =
      "Aşağıdaki alanları doldurarak şifrenizi yenileyebilirsiniz 🙂";
  var password = "Yeni Şifre";

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  // changePassword() async {
  //   try {
  //     await currentUser!.updatePassword(newPassword);
  //     FirebaseAuth.instance.signOut();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const LoginPage(),
  //       ),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.black26,
  //         content: Text("Your password has been changed...Login again!")));
  //   } catch (error) {}
  // }

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: _formKey,
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
                    title: password,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: password,
                    obscure: true,
                    controller: _passwordController,
                    valid: (value) {
                      if (value == null) {
                        return "Please enter password";
                      }
                      return null;
                    },
                    height: 70,
                    maxLines: 1),
                Container(height: 30),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              newPassword = _passwordController.text;
                            });
                            await currentUser!.updatePassword(newPassword);
                            FirebaseAuth.instance.signOut();
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                ModalRoute.withName("/Login"));
                          }
                        },
                        child: const Text("Şifreyi Değiştir"))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
