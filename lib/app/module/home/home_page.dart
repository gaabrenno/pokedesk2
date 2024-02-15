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
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      // Define a chave global para o Scaffold
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState
                  ?.openEndDrawer(); // Abre o endDrawer usando a chave global
            },
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.amberAccent,
        elevation: 0,
        toolbarHeight: 70,
        title: const Center(
          child: Text(
            'My Pokemon',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.amberAccent,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user),
              accountEmail: Text(email),
            ),
            ListTile(
              dense: true,
              title: Text('Logout'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                sair();
              },
            ),
          ],
        ),
      ),
      //o Scaffold traz todos os recursos necessarios para dar a aparencia do app, appBar, body, icons, funções...

      body: Container(
        decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(15),),

      // Define o fundo do body como branco
        child: FutureBuilder<dynamic>(
          future: pegarPokemon(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else {
              List<dynamic> pokemonList = snapshot.data!['results'];
              return ListView.builder(
                itemCount: (pokemonList.length / 2).ceil(),
                itemBuilder: (context, index) {
                  int startIndex = index * 2;
                  int endIndex = startIndex + 2;
                  if (endIndex > pokemonList.length) {
                    endIndex = pokemonList.length;
                  }
                  List<dynamic> pokemonPair =
                  pokemonList.sublist(startIndex, endIndex);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: pokemonPair.map((pokemon) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
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
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            }
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
          email = usuario.displayName!;
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
