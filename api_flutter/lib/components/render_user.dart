import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RenderUserComponent extends StatefulWidget {
  const RenderUserComponent({super.key, required this.user});

  final dynamic user;

  @override
  State<RenderUserComponent> createState() => _RenderUserComponentState();
}

class _RenderUserComponentState extends State<RenderUserComponent> {
  String alert = "";

  bool edit = false;

  @override
  void initState() {
    super.initState();
    edit = false;
  }

  void openEditUser() {
    setState(() {
      edit = !edit;
    });
  }

  Future<void> _editarUser(dynamic user, String name, String email) async {
    int userId = user["id"];
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
    };
    try {
      final response = await http.put(
        Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        setState(() {
          alert = "Usuário editado: $data";
        });
        openEditUser();
      } else {
        setState(() {
          alert = "Erro ao editar o usuário";
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _deleteData(dynamic user) async {
    try {
      int userId = user["id"];
      String userName = user['name'];
      final response = await http.delete(
        Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          alert = "Usuario $userName foi deletado com sucesso.";
        });
      } else {
        setState(() {
          alert = "Algo deu errado ao tentar deletar o usuário $userName";
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerName =
        TextEditingController(text: widget.user['name']);
    TextEditingController controllerEmail =
        TextEditingController(text: widget.user['email']);

    dynamic user = widget.user;
    return Center(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        child: Container(
          width: 800, // Defina a largura do card
          child: Column(
            children: [
              ListTile(
                title: Text(user['name']),
                subtitle: Text(user['email']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {
                          openEditUser();
                        },
                        child: const Text('Editar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          onPrimary: Colors.blue,
                          primary: Color.fromARGB(255, 157, 224, 255),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {
                          _deleteData(user).then((value) => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete do usuário'),
                                  content: Text(alert),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancelar'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ));
                        },
                        child: const Text('Deletar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10), 
                          onPrimary: const Color.fromARGB(255, 206, 32, 32),
                          primary: const Color.fromARGB(255, 255, 151, 151),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              edit
                  ? Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 500,
                              margin: const EdgeInsets.only(left: 18.0),
                              child: TextField(
                                controller: controllerName,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 18.0),
                              width: 500,
                              child: TextField(
                                controller: controllerEmail,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(18.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _editarUser(user, controllerName.text,
                                          controllerEmail.text)
                                      .then((value) => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text('Usuário editado!'),
                                                content: Text(alert),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, 'Cancelar'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              )));
                                },
                                child: const Text('Salvar'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(10), 
                                  onPrimary: Color.fromARGB(255, 0, 129, 4),
                                  primary: Color.fromARGB(255, 118, 255, 154),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(18.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  openEditUser();
                                },
                                child: const Text('Cancelar'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(10), 
                                  onPrimary: const Color.fromARGB(255, 206, 32, 32),
                                  primary: const Color.fromARGB(255, 255, 151, 151),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
