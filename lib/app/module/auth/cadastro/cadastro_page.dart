import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokedesk/app/module/auth/checagem/checagem_page.dart';

import '../../../../_colors.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D6DF7),
        elevation: 0,
        toolbarHeight: 200,
        flexibleSpace: Container(
          padding: EdgeInsets.only(top: 30.0),
          child: Center(
            child: Image.asset(
              "assets/logo.png",
              height: 150,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
      Container(
      decoration: const BoxDecoration(
      gradient: LinearGradient(
      begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [MinhasCores.azulEscuro, MinhasCores.azulClaro])),
    ),
          ListView(
            padding: EdgeInsets.all(12),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(label: Text('Nome Completo')),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(label: Text('E-mail')),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(label: Text('PassWord')),
              ),
              ElevatedButton(
                  onPressed: () {
                    cadastrar();
                  },
                  child: Text('Cadastrar'))
            ],
          ),
        ],
      ),
    );
  }

  cadastrar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential != null) {
        userCredential.user!.updateDisplayName(_nameController.text);
        Navigator.pushAndRemoveUntil(
            context as BuildContext,
            MaterialPageRoute(
              builder: (context) => ChecagemPage(),
            ),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if(e.code == 'weak-password'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha Fraca!'),
            backgroundColor: Colors.redAccent,
          ),
        );

      }else if(e.code== 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail já cadastrado!'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

    }
  }
}
