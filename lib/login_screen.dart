import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Pomo',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 60.0,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 23,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        print('Forgotted Password!');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: MaterialButton(
                    onPressed: () => print("Successul Login."),
                    color: Colors.blue,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Colors.black,
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '''Don't have an account? ''',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print('Sign Up');
                      },
                      child: Text('Register Now'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}