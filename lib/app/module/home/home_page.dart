import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedesk/app/module/auth/checagem/checagem_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //o Scaffold traz todos os recursos necessarios para dar a aparencia do app, appBar, body, icons, funções...
      appBar: AppBar(
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  sair();
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ],
        title: const Text('Pokemon'),
      ),
      body: FutureBuilder<dynamic>(
        future: pegarPokemon(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!['results'].length,
              itemBuilder: (context, index) {
                var pokemon = snapshot.data!['results'][index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(pokemon['name'].toString()),
                  ),
                  title: Text(pokemon['name']),
                  subtitle: Text(pokemon['url']),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  sair() async {
    await _firebaseAuth.signOut().then(
          (user) => Navigator.pushReplacement(
            context as BuildContext,
            MaterialPageRoute(
              builder: (context) => ChecagemPage(),
            ),
          ),
        );
  }

  pegarPokemon() async {
    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=151');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Não foi possivel carregar os Pokemon');
    }
  }
}
