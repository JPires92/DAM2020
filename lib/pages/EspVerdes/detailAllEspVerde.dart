import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:damapp/models/conexao.dart';
import 'package:damapp/pages/EspVerdes/editEspaco.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class detailAllEspVerde extends StatefulWidget {
  List list;
  int index;
  String email;
  String cidade;

  detailAllEspVerde({this.index,this.list,this.email,this.cidade});

  @override
  _detailAllEspVerdeState createState() => _detailAllEspVerdeState();
}

class _detailAllEspVerdeState extends State<detailAllEspVerde> {
  String urlimages="SemImagem";
  String urlimages2="SemImagem";

  void getImagens() async {
    conexao cn=new conexao();
    var url= cn.url+"getImagens.php";
    final response = await http.post(url, body: {
      "Id": widget.list[widget.index]['Id_Espaco'].toString(),
    });

    var data = json.decode(response.body);
    if(data.length!=0){
      setState(() {
        urlimages= data[0]['Localizacao'];
        urlimages2= data[1]['Localizacao'];
      });
    }
  }

  @override
  void initState() {
    getImagens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  new AppBar(
        title: new Text('Espaços verdes existentes'),
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
        child: ListView(
          children: <Widget>[
            new Card(
              child: new Center(
                child: new Column(
                  //mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //Designação
                    new Text(""),
                    new Text(widget.list[widget.index]['Designacao'], style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                    Divider(),
                    //Descrição
                    new Text("Descrição", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                    new Text("${widget.list[widget.index]['Descricao']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
                    Divider(),
                    //Localizacao
                    new Text("Localização", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                    new Text("${widget.list[widget.index]['Localizacao']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
                    Divider(),
                    Text("Imagens", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    urlimages=="SemImagem"?
                    Text(" "):
                    CachedNetworkImage(
                      placeholder: (context, url) => CircularProgressIndicator(),
                      imageUrl: 'https://ucarecdn.com/'+urlimages+'/',
                      width: 320,
                      height: 232,
                    ),
                    Divider(),
                    urlimages2=="SemImagem"?
                    Text(" "):
                    CachedNetworkImage(
                      placeholder: (context, url) => CircularProgressIndicator(),
                      imageUrl: 'https://ucarecdn.com/'+urlimages2+'/',
                      width: 320,
                      height: 232,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

