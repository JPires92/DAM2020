import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:damapp/models/conexao.dart';
import 'package:damapp/models/email.dart';
import 'package:damapp/pages/Admin/adminPage1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String estado, emailUser, msg="";
class dtlEspacos extends StatefulWidget {
  List list;
  int index;
  String cidade;

  dtlEspacos({this.index,this.list,this.cidade});

  @override
  _dtlEspacosState createState(){
    estado = list[index]['Estado'];
    return _dtlEspacosState();
  }
}

class _dtlEspacosState extends State<dtlEspacos> {
 //Alterar estado
  void updateData() {
    (estado == '1') ? estado='0' : estado='1';
    conexao cn = new conexao();
    var url = cn.url + "editEspacoAdmin.php";
    http.post(url, body: {
      "Id": widget.list[widget.index]['Id_Espaco'],
      "Estado": estado,
    });
    _sendEmail();
  }


  //Notificar user
  var email = Email('fixatedam2020@gmail.com', '-dam2020');

  void getUser() async {
    conexao cn=new conexao();
    var url= cn.url+"getUser.php";
    final response = await http.post(url, body: {
      "Id": widget.list[widget.index]['Id_Utilizador'].toString(),
    });
    var dataUser = json.decode(response.body);
    if(dataUser.length==1){
      setState(() {
        emailUser= dataUser[0]['Email'].toString();
      });
    }
  }

  void _sendEmail() async {
    String verificaEstado ="";
    (estado == '1') ? verificaEstado='ativo' : verificaEstado='suspenso';
    String texto= 'O seu anúncio de Espaço de Lazer/Verde "'+ widget.list[widget.index]['Designacao']+
        '" foi ' + verificaEstado +', para mais informações contacte o administrador através deste email.';
    bool result = await email.sendMessage(
        texto, emailUser, 'Anúncio Suspenso/Ativo');

    setState(() {
      msg = result ? 'Email enviado.' : 'Email não enviado.';
      print (msg);
    });
  }

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
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  new AppBar(
        title: new Text('Detalhes anúncio'),
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
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new RaisedButton(
                          child: new Text(
                            (estado == '1') ? 'SUSPENDER' : 'ATIVAR',
                          ),
                          color:  (estado == '1') ? Colors.redAccent : Colors.green,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: (){
                            updateData();
                            Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context)=>new adminPage1(cidade: widget.cidade,)
                                ));
                          },
                        ),
                      ],
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