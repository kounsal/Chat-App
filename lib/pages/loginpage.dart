import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'registerpage.dart';
import '../helper/helper_function.dart';
import 'homepage.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  bool _isloading = false;
  String email = "";
  String password = "";

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Center(
        child: _isloading
            ? const CircularProgressIndicator(
                color: Colors.amber,
              )
            : SingleChildScrollView(
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
                          "Login Now",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
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
                              login();
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            nextScreen(context, const RegisterPage());
                          },
                          child: Text(
                            "New here? Create account",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
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

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      await authService
          .loginUserwithEmaiandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snap =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
//saving the values  to shared pref
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);

          await HelperFunction.saveUserNameSF(snap.docs[0]["fullname"]);

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
        prefixIcon: Icon(
          Icons.lock,
          color: Theme.of(context).primaryColor,
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
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).primaryColor,
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
}
