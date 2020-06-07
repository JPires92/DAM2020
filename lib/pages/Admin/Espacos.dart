import 'dart:convert';
import 'package:damapp/models/conexao.dart';
import 'package:damapp/pages/Admin/dtlEspacos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String _tipoEspaco,_cidade=""; //1-Espaços verdes, 2-Espaços lazer
class adminEspacos extends StatefulWidget {

  final String espaco,cidade;

  adminEspacos({@required this.espaco,@required this.cidade});


  @override
  _adminEspacos createState(){
    _tipoEspaco=this.espaco;
    _cidade=this.cidade;
    return _adminEspacos();
  }
}

class _adminEspacos extends State<adminEspacos> {


  //Carregar todos anuncios de espaços verdes ou lazer
  Future<List> _fetchEspacos() async {
    conexao cn =new conexao();
    final String url= cn.url+"getEspacos.php";

    final response = await http.post(url, body: {
      "Cidade": _cidade,
      "Espaco":_tipoEspaco,
    });

    return json.decode(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
         _tipoEspaco == '1' ?  'Espaços verdes' : 'Espaços de lazer',
        ),
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
        future: _fetchEspacos(),
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
                  builder: (BuildContext context) => new dtlEspacos(
                    index: i,
                    list: list,
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
                  _tipoEspaco == '1' ?  Icons.landscape : Icons.local_activity,
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
