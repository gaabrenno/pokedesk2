import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../home/home_page.dart';
import '../cadastro/cadastro_page.dart';

// 22
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _seePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pokedex',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              'Faça login e confira quais Pokemons estão disponiveis para você!',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: Text('E-mail'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe seu e-mail!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _seePassword,
              decoration: InputDecoration(
                label: Text('PassWord'),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _seePassword = !_seePassword;
                      });
                    },
                    icon: Icon(_seePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Insira sua senha!';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: Text('Entrar'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroPage(),
                    ),
                  );
                },
                child: Text('Cadastrar'))
          ],
        ),
      ),
    );
  }

  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não encontrado!'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha Incorreta!'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
