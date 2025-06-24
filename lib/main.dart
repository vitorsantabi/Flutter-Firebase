import 'package:app_login/login.dart';
import 'package:app_login/interna.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Root()));
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
      if (snapshot.hasData) {
        return const BoasVindas();
      } else {
        return const Login();
      }
    });
  }
}
