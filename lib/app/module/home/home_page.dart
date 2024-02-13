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
  String user = '';
  String email = '';

  @override
  void initState() {
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      //o Scaffold traz todos os recursos necessarios para dar a aparencia do app, appBar, body, icons, funções...
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
                    items: [
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text(
                            user,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            email,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          title: Text('Sair'),
                          leading: Icon(Icons.exit_to_app),
                          onTap: () {
                            sair();
                          },
                        ),
                      ),
                    ],
                  );
                },
                child: Row(
                  children: [
                    // Ícone do usuário
                    // Espaçamento entre o ícone e o texto
                    Text(
                      user,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        title: const Center(
            child: Text(
          'My Pokemon',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        )),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: FutureBuilder<dynamic>(
          future: pegarPokemon(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!['results'].length,
                itemBuilder: (context, index) {
                  var pokemon = snapshot.data!['results'][index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amberAccent,
                          child: Text(
                            pokemon['name'][0].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          pokemon['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          pokemon['url'],
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  getUser() async {
    User? usuario = await _firebaseAuth.currentUser;
    if (usuario != null) {
      setState(
        () {
          user = usuario.displayName!;
        },
      );
    }
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
