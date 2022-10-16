import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/homepage.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import "loginpage.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  bool _isloading = false;
  String email = "";
  String password = "";
  String name = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            )
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        const Text(
                          "Message app",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Register Now",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        space(15),
                        namefield(),
                        space(15),
                        emailfield(),
                        space(15),
                        passfield(),
                        space(15),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              register();
                            }
                          },
                          color: const Color.fromARGB(255, 179, 14, 14),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(153, 255, 255, 255)),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            nextScreen(context, const LoginPage());
                          },
                          child: const Text(
                            "Already Have a Account ? Login Here",
                            style: TextStyle(
                                color: Color.fromARGB(255, 179, 14, 14)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      await authService
          .registerUserwithEmaiandPassword(name, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUserNameSF(name);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Homepage()),
              (route) => false);
        } else {
          showSnackBar(context, Colors.red, value);

          setState(() {
            _isloading = false;
          });
        }
      });
    }
  }

  Widget passfield() {
    return TextFormField(
      obscureText: true,
      decoration: textInputDecoration.copyWith(
        labelText: "Password",
        prefixIcon: const Icon(
          Icons.lock,
          color: Color.fromARGB(255, 179, 14, 14),
        ),
      ),
      onChanged: (value) {
        password = value;
      },
      validator: (value) {
        if (value!.length < 6) {
          return "Password must be atleast 6 characters";
        } else {
          return null;
        }
      },
    );
  }

  Widget emailfield() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(
        labelText: "Email",
        prefixIcon: const Icon(
          Icons.email,
          color: Color.fromARGB(255, 179, 14, 14),
        ),
      ),
      onChanged: (value) {
        email = value;
      },
      validator: (value) {
        if (!value!.contains("@")) {
          return "Enter valid Password";
        } else {
          return null;
        }
      },
    );
  }

  Widget namefield() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(
        labelText: "Name",
        prefixIcon: const Icon(
          Icons.person,
          color: Color.fromARGB(255, 179, 14, 14),
        ),
      ),
      onChanged: (value) {
        name = value;
      },
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return "Enter valid Password";
        }
      },
    );
  }
}
