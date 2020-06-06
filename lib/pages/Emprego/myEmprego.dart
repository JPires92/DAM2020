
import 'dart:convert';

import 'package:damapp/models/conexao.dart';
import 'package:damapp/pages/Emprego/novoEmprego.dart';
import 'package:damapp/pages/Emprego/detailEmprego.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String _email,_cidade="";
class myEmprego extends StatefulWidget {

  final String email;
  final String cidade;
  //Construtor
  myEmprego({Key key,@required this.email, @required this.cidade}): super(key: key);

  @override
  _myEmpregoState createState(){
    _email=this.email;
    _cidade=this.cidade;
    return _myEmpregoState();
  }
}

class _myEmpregoState extends State<myEmprego> {

  //Carregar anuncios de emprego pessoais
  Future<List> _fetchEmprego() async {
    conexao cn =new conexao();
    final String url= cn.url+"getMyEmpregos.php";

    final response = await http.post(url, body: {
      "Email": _email,
      "Cidade": _cidade,
    });

    return json.decode(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Área Pessoal - Emprego'),
          backgroundColor: Color.fromARGB(255, 173, 216, 230),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                  Navigator.pushReplacementNamed(context, '/MyHomePage');
                },
                icon: Icon(Icons.exit_to_app)
            ),
          ],

        ),
        floatingActionButton: FloatingActionButton(child: Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 173, 216, 230),
            foregroundColor: Colors.white,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>novoEmprego(email: _email,cidade: _cidade)));
        }),
        body:new FutureBuilder<List>(
          future: _fetchEmprego(),
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
                  builder: (BuildContext context) => new detailEmprego(
                    list: list,
                    index: i,
                    email: _email,
                    cidade: _cidade,
                  )),
            ),
            child: new Card(
              child: new ListTile(
                title: new Text(
                  list[i]['Designacao'],
                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                ),
                leading: new Icon(
                  Icons.account_balance_wallet,
                  size: 44.0,
                  color: Color.fromARGB(255, 173, 216, 230),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
