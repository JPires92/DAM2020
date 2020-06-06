import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:http/http.dart' as http;
import 'package:damapp/models/conexao.dart';


class editUtilizador extends StatefulWidget {
  final List list;
  final int index;
  final String email,cidade;


  editUtilizador({this.index,this.list,this.email,this.cidade});

  @override
  _editUtilizadorState createState() => new _editUtilizadorState();
}

class _editUtilizadorState extends State<editUtilizador> {

  TextEditingController controllerNome = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();

  var _formKey = GlobalKey<FormState>();


  void editData() {
    conexao cn = new conexao();
    var url = cn.url + "editUtilizador.php";
    http.post(url, body: {
      "id": widget.list[widget.index]['Id_Utilizador'],
      "Nome": controllerNome.text,
      "Email": controllerEmail.text,
      "Password": controllerPassword.text,
    });
  }


  @override
  void initState() {
    controllerNome= new TextEditingController(text: widget.list[widget.index]['Nome'] );
    controllerEmail= new TextEditingController(text: widget.list[widget.index]['Email'] );
    controllerPassword= new TextEditingController(text: widget.list[widget.index]['Password'] );
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
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
      body:       Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Editar o meu Perfil",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ),
                  new ListTile( //Nome
                    title: new TextFormField(
                      controller: controllerNome,
                      validator: (value) {
                        if (value.isEmpty) return "Insira o nome!";
                      },
                      decoration: new InputDecoration(
                        hintText: "nome ", labelText: "Nome",
                      ),
                    ),
                  ),

                  new ListTile( //Email de contacto
                    title: new TextFormField(
                      controller: controllerEmail,
                      validator: (value) {
                        if (value.isEmpty) return "Insira o email!";
                      },
                      decoration: new InputDecoration(
                        hintText: "email", labelText: "Email ",
                      ),
                    ),
                  ),
                  new ListTile( //Email de contacto
                    title: new TextFormField(
                      controller: controllerPassword,
                      validator: (value) {
                        if (value.isEmpty) return "Insira a Password!";
                      },
                      decoration: new InputDecoration(
                        hintText: "password", labelText: "Password",
                      ),
                    ),
                  ),

                  new Padding(
                    padding: const EdgeInsets.all(30.0),
                  ),
                  ButtonTheme( //botão
                    buttonColor:Color.fromARGB(255, 173, 216, 230),
                    minWidth: 200.0,
                    height: 50.0, //Tamanho botão
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          editData();
                          Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context)=>new InitialP1(email: widget.email,cidade: widget.cidade,)
                              ));
                        }
                      },
                      child: const Text(
                          'Alterar',
                          style: TextStyle(fontSize: 20)
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}