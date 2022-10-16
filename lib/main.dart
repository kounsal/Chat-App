import 'package:chat_app/pages/homepage.dart';
import 'package:chat_app/shared/contants.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './helper/helper_function.dart';
import './pages/loginpage.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: Constants.apiKey,
          appId: Constants.appId,
          messagingSenderId: Constants.messagingSenderId,
          projectId: Constants.projectId),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _isSignedIn ? const Homepage() : const LoginPage());
  }
}

AlertDialog showAlert(BuildContext context, FirebaseRemoteConfig remoteConfig) {
  Widget cancel = MaterialButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget update = MaterialButton(
    child: const Text("Update"),
    onPressed: () {},
  );

  return AlertDialog(
    title: Text(remoteConfig.getString('title')),
    content: Text(remoteConfig.getString('message')),
    actions: [
      cancel,
      update,
    ],
  );
}
