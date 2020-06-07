import 'dart:convert';
import 'package:damapp/models/conexao.dart';
import 'package:damapp/models/email.dart';
import 'package:damapp/pages/Admin/adminPage1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String categoria, estado,emailUser, msg="";
class dtlEmpregos extends StatefulWidget {

  List list;
  int index;
  String cidade;

  dtlEmpregos({this.index,this.list,this.cidade});
  @override
  _dtlEmpregosState createState() {
    estado = list[index]['Estado'];
    return _dtlEmpregosState();
  }
}

class _dtlEmpregosState extends State<dtlEmpregos> {
  @override
  void initState() {
    getCategoria();
    getUser();
    super.initState();
  }


  //Alterar estado
  void updateData(){
    (estado == '1') ? estado='0' : estado='1';
    conexao cn = new conexao();
    var url = cn.url + "editEmpregoAdmin.php";
    http.post(url, body: {
      "Id": widget.list[widget.index]['Id_Emprego'],
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
    String texto= 'O seu anúncio de emprego "'+ widget.list[widget.index]['Designacao']+
        '" foi ' + verificaEstado +', para mais informações contacte o administrador através deste email.';
    bool result = await email.sendMessage(
        texto, emailUser, 'Anúncio Suspenso/Ativo');

    setState(() {
      msg = result ? 'Email enviado.' : 'Email não enviado.';
      print (msg);
    });
  }


  //Obter tipo de oferta
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
  Widget build(BuildContext context) {
    //getCategoria();
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
      ),
    );
  }
}
