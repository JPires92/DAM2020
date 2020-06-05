import 'dart:convert';
import 'package:damapp/pages/Habitacao/detailAllHabitacao.dart';
import 'package:damapp/models/conexao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String _email,_cidade="";
class listHabitacao extends StatefulWidget {
  final String email;
  final String cidade;
  //Construtor
  listHabitacao({Key key,@required this.email, @required this.cidade}): super(key: key);

  @override
  _listHabitacaoState createState() {
    _email=this.email;
    _cidade=this.cidade;
    return _listHabitacaoState();
  }
}

class _listHabitacaoState extends State<listHabitacao> {

  //Carregar anuncios de emprego pessoais
  Future<List> _fetchHabitacao() async {
    conexao cn =new conexao();
    final String url= cn.url+"getHabitacao.php";

    final response = await http.post(url, body: {
      "Cidade": _cidade,
    });

    return json.decode(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Habitações existentes'),
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
        future: _fetchHabitacao(),
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
                  builder: (BuildContext context) => new detailAllHabitacao(
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
                  Icons.home,
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