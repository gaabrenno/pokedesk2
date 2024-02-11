import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedesk/app/module/home/home_page.dart';
import 'package:pokedesk/app/module/auth/login/login_page.dart';

class ChecagemPage extends StatefulWidget {
  const ChecagemPage({Key? key}) : super(key: key);

  @override
  State<ChecagemPage> createState() => _ChecagemPageState();
}

class _ChecagemPageState extends State<ChecagemPage> {

  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();

   streamSubscription = FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(context,
          MaterialPageRoute(
            builder: (context)=> const LoginPage(),
          ),
        );
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(
            builder: (context)=> const HomePage(),
            ),
        );
      }
    });
  }

  @override
  void dispose(){
    streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
