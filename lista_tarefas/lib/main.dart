import 'package:flutter/material.dart';
// para ler arquivo vamos adicionar o plugin path_provider
import 'package:path_provider/path_provider.dart';
//lib para importar arquivos
import 'dart:io';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Lista que vai armazenar nossas tarefas
  final _todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          //container responsável pelo spaçamento
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: //aqyu vamos adicionar o textfield e o botão
                      TextField(
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                IconButton(icon: Icon(Icons.add), onPressed: () {})
              ],
            ),
          )
        ],
      ),
    );
  }

  //Criar uma função para retornar o arquivo em que vamos salvar os dados

  Future<File> _getFile() async {
    //Pegando o diretorio onde vamos armazenar as tarefas
    final directory = await getApplicationDocumentsDirectory();
    //pegando e retornando a funcao com um arquivo, e esquecificar o caminho
    return File("${directory.path}/data.json");
  }

// Salvar algum dado no arquivo
  Future<File> _saveData() async {
    // transformando a lista em JSON
    String data = json.encode(_todoList);
    //pegando o arquivo
    final file = await _getFile();
    // o pegando o arquivo e retornando como texto
    return file.writeAsString(data);
  }

  // Função para obter o dados do arquivo
  Future<String> _readData() async {
    try {
      //pegando oa rquivo
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
