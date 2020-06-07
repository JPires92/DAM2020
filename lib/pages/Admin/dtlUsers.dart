import 'dart:convert';
import 'package:damapp/models/conexao.dart';
import 'package:damapp/models/email.dart';
import 'package:damapp/pages/Admin/adminPage.dart';
import 'package:damapp/pages/Admin/adminPage1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String estado, emailUser,msg="";
class dtlUsers extends StatefulWidget {
  List list;
  int index;


  dtlUsers({this.index,this.list});

  @override
  _dtlUsersState createState(){
    estado = list[index]['Estado'];
    return _dtlUsersState();
  }
}

class _dtlUsersState extends State<dtlUsers> {

  @override
  void initState() {

    emailUser= widget.list[widget.index]['Email'];
    super.initState();
  }
  //Alterar estado
  void updateData(){
    (estado == '1') ? estado='0' : estado='1';
    conexao cn = new conexao();
    var url = cn.url + "editUserAdmin.php";
    http.post(url, body: {
      "Id": widget.list[widget.index]['Id_Utilizador'],
      "Estado": estado,
    });
    _sendEmail();
  }

  //Notificar user
  var email = Email('fixatedam2020@gmail.com', '-dam2020');

  void _sendEmail() async {
    String verificaEstado ="";
    (estado == '1') ? verificaEstado='ativa' : verificaEstado='suspensa';
    String texto= 'A sua conta foi '+ verificaEstado +', para mais informações contacte o administrador através deste email.';
    bool result = await email.sendMessage(
        texto, emailUser, 'Conta Suspensa/Ativa');

    setState(() {
      msg = result ? 'Email enviado.' : 'Email não enviado.';
      print (msg);
    });
  }


  @override
  Widget build(BuildContext context) {
    //getCategoria();
    return new Scaffold(
      appBar:  new AppBar(
        title: new Text('Detalhes utilizador'),
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
                //Nome
                new Text(""),
                new Text(widget.list[widget.index]['Nome'], style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                Divider(),
                //Email
                new Text("Email", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['Email']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
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
                                builder: (BuildContext context)=>new Admin()
                            ));
                      },
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
