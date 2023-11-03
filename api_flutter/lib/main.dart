import 'dart:convert';

import 'package:api_flutter/components/render_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const HomeUser(title: 'API Flutter'),
    );
  }
}

class HomeUser extends StatefulWidget {
  const HomeUser({super.key, required this.title});
  final String title;
  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        setState(() {
          _data = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  TextEditingController controllerName = TextEditingController(text: "Email");
  TextEditingController controllerEmail = TextEditingController(text: "Nome");
  String alert = "";

  Future<void> _createUser(String name, String email) async {
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
    };
    try {
      final response = await http.post(
          Uri.parse(
            'https://jsonplaceholder.typicode.com/users',
          ),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
      if (response.statusCode == 201) {
        setState(() {
          alert = "Usuario cadastrado com as informações: $data";
        });
      } else {
        setState(() {
          alert = "Erro ao cadastrar novo usuario.";
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 400,
              margin: const EdgeInsets.only(left: 18.0),
              child: TextField(
                controller: controllerName,
              ),
            ),
            Container(
              width: 400,
              margin: const EdgeInsets.only(left: 18.0),
              child: TextField(
                controller: controllerEmail,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                onPressed: () {
                  _createUser(controllerName.text, controllerEmail.text)
                      .then((value) => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Usuário criado'),
                                content: Text(alert),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Ok'),
                                  ),
                                ],
                              )));
                  ;
                },
                child: const Text('Novo usuário'),
                style: ElevatedButton.styleFrom( 
                  primary: Color.fromARGB(255, 118, 255, 154),
                  onPrimary: Color.fromARGB(255, 0, 129, 4), 
                  padding: const EdgeInsets.all(20), 
                  elevation: 5, 
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  dynamic currentUser = _data[index];
                  return RenderUserComponent(user: currentUser);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}