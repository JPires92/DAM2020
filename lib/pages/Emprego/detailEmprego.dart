import 'dart:convert';
import 'package:damapp/models/conexao.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:flutter/material.dart';
import 'package:damapp/pages/Emprego/editEmprego.dart';
import 'package:http/http.dart' as http;

String categoria="";
class detailEmprego extends StatefulWidget {
  List list;
  int index;
  String email;
  String cidade;

  detailEmprego({this.index,this.list,this.email,this.cidade});


  @override
  _detailEmpregoState createState() {
    return _detailEmpregoState();
  }
}

class _detailEmpregoState extends State<detailEmprego> {

  //Apagar registo
  void deleteData(){
    conexao cn=new conexao();
    var url= cn.url+"deleteEmprego.php";
    http.post(url, body: {
      'id': widget.list[widget.index]['Id_Emprego']
    });
  }

  void getCategoria() async {
    conexao cn=new conexao();
    var url= cn.url+"getAtividade.php";
    final response = await http.post(url, body: {
      "Id": widget.list[widget.index]['Id_Atividade'].toString(),
    });

    var datacategoria = json.decode(response.body);
    if(datacategoria.length==0){
      setState(() {
        categoria="Sem categoria.";
      });
    }else{
      setState(() {
        categoria= datacategoria[0]['Atividade'];
      });
    }
  }

  @override
  void initState() {
    getCategoria();
    super.initState();
  }

  void confirm (){
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Desja eliminar anuncio: '${widget.list[widget.index]['Designacao']}'"),
      actions: <Widget>[
        new RaisedButton(
          child: new Text("ELIMINAR",style: new TextStyle(color: Colors.black),),
          color: Colors.red,
          onPressed: (){
            deleteData();
            Navigator.of(context).push(
                new MaterialPageRoute(
                 builder: (BuildContext context)=> new InitialP1(email: widget.email , cidade: widget.cidade),
                )
            );
          },
        ),
        new RaisedButton(
          child: new Text("CANCELAR",style: new TextStyle(color: Colors.black)),
          color: Colors.green,
          onPressed: ()=> Navigator.pop(context),
        ),
      ],
    );

    showDialog(context: context, child: alertDialog);
  }
  @override
  Widget build(BuildContext context) {
    //getCategoria();
    return new Scaffold(
      appBar:  new AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/MyHomePage');
              },
              icon: Icon(Icons.exit_to_app,)
          ),
        ],
        title: Text("Fixa-te"),
      ),
      body:
      new Container(
        //height: 300.0,
       // padding: const EdgeInsets.all(20.0),
        child: new Card(
          child: new Center(
            child: new Column(
              children: <Widget>[
                //Designação
                new Text(""),
                new Text(widget.list[widget.index]['Designacao'], style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                Divider(),
                //Descrição
                new Text("Descrição", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['Descricao']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
                Divider(),
                //Categoria
                new Text("Categoria", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text(categoria, style: new TextStyle(fontSize: 16.0),),
                Divider(),
                //Email pra contacto
                new Text("Email Contacto", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['EmailContacto']}", style: new TextStyle(fontSize: 16.0),),

                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text("EDITAR"),
                      color: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new editEmprego(
                                index: widget.index,
                                list: widget.list,
                                email: widget.email,
                                cidade: widget.cidade,
                              ),
                            )
                        );
                      }
                    ),
                    VerticalDivider(),
                    new RaisedButton(
                      child: new Text("ELIMINAR"),
                      color: Colors.redAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: ()=>confirm(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
