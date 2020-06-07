import 'dart:convert';
import 'package:damapp/pages/Admin/dtlEmpregos.dart';
import 'package:damapp/pages/Admin/dtlUsers.dart';
import 'package:http/http.dart' as http;
import 'package:damapp/models/conexao.dart';
import 'package:flutter/material.dart';

class adminUsers extends StatefulWidget {
  @override
  _adminUsersState createState() => _adminUsersState();
}

class _adminUsersState extends State<adminUsers> {
//Carregar anuncios de emprego pessoais
  Future<List> _fetchUsers() async {
    conexao cn =new conexao();
    final String url= cn.url+"getUsersAdmin.php";

    final response = await http.post(url, body: {
      "tipoUser": '2',
    });

    return json.decode(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Utilizadores'),
        backgroundColor: Color.fromARGB(255, 173, 216, 230),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/MyHomePage');
              },
              icon: Icon(Icons.exit_to_app,)
          ),
        ],

      ),
      body:new FutureBuilder<List>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
            list: snapshot.data,
          ) : new Center(
            child: new Text("Sem resultados!"),
          );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new dtlUsers(
                    list: list,
                    index: i,
                  )),
            ),
            child: new Card(
              child: new ListTile(
                title: new Text(
                  list[i]['Nome'],
                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                ),
                leading: new Icon(
                  Icons.person_outline,
                  size: 44.0,
                  color: Color.fromARGB(255, 173, 216, 230),
                ),
                subtitle: new Text(
                  ((list[i]['Estado'])=='1') ? 'Ativo' : 'Suspenso',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

