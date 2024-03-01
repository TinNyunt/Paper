import 'package:flutter/material.dart';
import 'package:paper/Button/mybutton.dart';
import 'package:paper/pages/Auth/RegisterPage.dart';
import 'package:paper/services/Auth.dart';

import '../../widgets/RoutePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();

  Login() async {
    if (EmailController.text.isNotEmpty && PasswordController.text.isNotEmpty) {
      Auth()
          .LoginAccount(EmailController.text, PasswordController.text)
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoutePage(),
          ),
        );
      });
    } else {
      var snackBar = SnackBar(
        content: const Text('Please fill email and password'),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 10,
          left: 10,
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login Account',
                style: TextStyle(fontSize: 35),
              ),
              const SizedBox(
                height: 150,
              ),
              Column(
                children: [
                  TextFormField(
                    controller: EmailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusColor: Colors.black,
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: PasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusColor: Colors.black,
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyButton(
                    title: 'Login Account',
                    onTap: Login,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    title: 'Register Account',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    width: double.infinity,
                    color: Colors.black,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
