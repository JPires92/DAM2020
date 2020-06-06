import 'dart:convert';
import 'package:damapp/models/conexao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:damapp/pages/initialPage1.dart';
import 'package:damapp/pages/Utilizador/editUtilizador.dart';

String _email,_cidade="";
class detailUtilizador extends StatefulWidget {

  List list;
  int index;
  final String email, cidade;

  detailUtilizador({this.index,this.list,@required this.email, @required this.cidade});

  @override
  _detailUtilizadorState createState() {
    _email = this.email;
    _cidade = this.cidade;
    return _detailUtilizadorState();
  }

}


class _detailUtilizadorState extends State<detailUtilizador> {



  void getUtilizador() async {
    conexao cn=new conexao();
    var url= cn.url+"getUtilizador.php";
    final response = await http.post(url, body: {
      "Id": widget.list[widget.index]['Email'].toString(),
    });


  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar:  new AppBar(
        title: new Text('O meu Perfil'),
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
      body:
      new Container(
        //height: 300.0,
        // padding: const EdgeInsets.all(20.0),
        child: new Card(
          child: new Center(
            child: new Column(
              children: <Widget>[

                new Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 40.0,
                ),
                //Nome
                new Text(""),
                new Text(widget.list[widget.index]['Nome'], style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                Divider(),
                //Email
                new Text("Email", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['Email']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
                Divider(),
                //Password
                new Text("Password", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['Email']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
                Divider(),
            new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new RaisedButton(
                    child: new Text("EDITAR"),
                    color: Color.fromARGB(255, 173, 216, 230),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new editUtilizador(
                              index: widget.index,
                              list: widget.list,
                              email: widget.email,
                              cidade: widget.cidade,
                            ),
                          )
                      );
                    }
                ),
              ],


            ),

          ],),
        ),
      ),
      ),
    );
  }
}