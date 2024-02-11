import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: Text('Cadastro Page'),
      ),
      body: ListView(
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
          ElevatedButton(onPressed: (){}, child: Text('Cadastrar'))
        ],
      ),
    );
  }
}
