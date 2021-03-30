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
  var _toDoController = TextEditingController();
  // Lista que vai armazenar nossas tarefas
  var _todoList = [];

  // Mapa que vamos remover
  Map<String, dynamic> _lastRemoved;
  // saber a posição que foi removida
  int _lastRemovedPos;

  //Ler os dados, metodo sempre que iniciamos a teka[
  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _todoList = json.decode(data);
      });
    });
  }

  // adicionando mapa na lista
  void _addTodo() {
    setState(() {
      //acessando texto pelo controlador
      Map<String, dynamic> newTodo = Map();
      // colocar o titulo da tarefa
      newTodo['title'] = _toDoController.text;
      //Zerando o texto do texto field, assim que o clicar no botão o nome irá ser resetado
      _toDoController.text = "";
      //tarefa não concluida
      newTodo['ok'] = false;
      //adicionar o newtodo na lista
      _todoList.add(newTodo);
      _saveData();
    });
  }

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
                // Para dar espaço entre um campo e o outro
                Expanded(
                  child: //aqyu vamos adicionar o textfield e o botão
                      TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.lightBlue)),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed:
                        _addTodo) // Aqui dentro do botão vou chamar a função addTodoList
              ],
            ),
          ),
          // Aqui vai vim a lista
          Expanded(
            // ListView = Widget que podemos fazer uma lista, Builder = construia lista conforme for rodando ela
            child: ListView.builder(
                // Para descolar da linha Nova Tarefa
                padding: EdgeInsets.only(top: 10.0),
                // Quantidade de item que vamos ter
                itemCount: _todoList.length,
                //index é o elemento que estamos desenhando no momento
                itemBuilder: buildItem),
          )
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    // Dismissible item que vai permitir que arrastamos o icone para direita
    return Dismissible(
      // Key é o tempo atual em milisegundos
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      //Temos que especificar um background
      background: Container(
        //faixa vermelha atrás do ícone
        color: Colors.red,
        //colocando icone da lixeira quando for arrastar para direita
        child: Align(
          //Align alinha o filho
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      // Definir a direção da esquerda para direita
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_todoList[index]["title"]),
        value: _todoList[index]["ok"],
        // mudando icone para ok (verdinho) desmarcado como error
        secondary: CircleAvatar(
          child: Icon(_todoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          // se marcamos no ok vamos adicionar como C
          setState(() {
            _todoList[index]["ok"] = c;
          });
          _saveData();
        },
      ),
      // Função que vai chamar o item sempre que mover ele para direita
      onDismissed: (diretion) {
        setState(() {
          //pPara remover o item, primeiro vamos duplicar ele, em seguida
          _lastRemoved = Map.from(_todoList[index]);
          // Salvar a posição qe foi removida
          _lastRemovedPos = index;
          // Remover da todoList
          _todoList.removeAt(index);

          // Salvar a alista com item removida
          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa ${_lastRemoved["title"]} Removida"),
          );
        });
      },
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
