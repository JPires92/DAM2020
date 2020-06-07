import 'dart:convert';
import 'package:damapp/models/utilizador.dart';
import 'package:damapp/pages/initialPage.dart';
import 'package:flutter/material.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:http/http.dart' as http;
import 'package:damapp/models/conexao.dart';


class editUtilizador extends StatefulWidget {

  final String email;


  editUtilizador({this.email});

  @override
  _editUtilizadorState createState() => new _editUtilizadorState();
}

class _editUtilizadorState extends State<editUtilizador> {

  String id="";
  TextEditingController controllerNome = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerRepeatPassword = new TextEditingController();

  var _formKey = GlobalKey<FormState>();


  void editData() {
    conexao cn = new conexao();
    var url = cn.url + "editUtilizador.php";
    http.post(url, body: {
      "Id": id,
      "Nome": controllerNome.text,
      "Email": controllerEmail.text,
      "Password": controllerPassword.text,
    });
  }

  void getUser() async {
    conexao cn=new conexao();
    var url= cn.url+"getUtilizador.php";
    final response = await http.post(url, body: {
      "Email": widget.email,
    });

    var datacategoria = json.decode(response.body);
    if(datacategoria.length!=0){
      setState(() {
        id = (datacategoria[0]['Id_Utilizador']);
        controllerNome=new TextEditingController(text:datacategoria[0]['Nome']);
        controllerEmail=new TextEditingController(text:datacategoria[0]['Email']);
      });
    }
  }


  @override
  void initState() {
    getUser();
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
      body: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new ListTile( //Nome
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerNome,
                    validator: (value) {
                      if (value.isEmpty) return "Insira o nome!";
                    },
                    decoration: new InputDecoration(
                      hintText: "nome", labelText: "Nome",
                    ),
                  ),
                ),
                new ListTile(//Email
                  leading: const Icon(Icons.email, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerEmail,
                    validator: (value) {
                      if (value.isEmpty) return "Insira o email!";
                    },
                    decoration: new InputDecoration(
                      hintText: "email", labelText: "Email",
                    ),
                  ),
                ),
                new ListTile( //Password
                  leading: const Icon(Icons.vpn_key, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerPassword,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) return "Insira a password!";
                    },
                    decoration: new InputDecoration(
                      hintText: "password", labelText: "Password",
                    ),
                  ),
                ),
                new ListTile( //Repeat Password
                  leading: const Icon(Icons.vpn_key, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerRepeatPassword,
                    obscureText: true,
                    validator: (value) {
                      if (controllerPassword.text!=controllerRepeatPassword.text) return "Passwords diferentes!";
                    },
                    decoration: new InputDecoration(
                      hintText: "Confirmação password", labelText: "Confirmação password",
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(30.0),
                ),
                ButtonTheme( //botão
                  buttonColor: Color.fromARGB(255, 173, 216, 230),
                  minWidth: 200.0,
                  height: 50.0, //Tamanho botão
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        editData();
                        Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (BuildContext context)=> new Initial(email: controllerEmail.text , cidade: ""),
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