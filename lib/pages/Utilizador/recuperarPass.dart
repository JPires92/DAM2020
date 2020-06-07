import 'dart:convert';
import 'dart:math';

import 'package:damapp/models/conexao.dart';
import 'package:damapp/models/email.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class recuperarPass extends StatefulWidget {
  @override
  _recuperarPassState createState() => _recuperarPassState();
}

class _recuperarPassState extends State<recuperarPass> {
  String msg="";
  String pass ='';

  TextEditingController controllerEmail = new TextEditingController();
  var _formKey = GlobalKey<FormState>();

  var email = Email('fixatedam2020@gmail.com', '-dam2020');
  void criaPassRandom(){
    var _random = Random.secure();
    var random = List<int>.generate(10, (i) => _random.nextInt(256));
    var verificador = base64Url.encode(random);
    setState(() {
      pass=verificador;
    });
  }

  void _sendEmail() async {
    //criaPassRandom();
    String texto= 'A sua password temporária é: "'+ pass +'" , pedimos que substitua a mesma por questões de segurança.';
    bool result = await email.sendMessage(
        texto, controllerEmail.text, 'Recuperar password');

    setState(() {
      msg = result ? 'Email enviado.' : 'Email não enviado.';
    });

  }

 void  recuperar(){
    criaPassRandom();
    conexao cn = new conexao();
    var url = cn.url + "recuperarPassword.php";
    final response = http.post(url, body: {
      "Email": controllerEmail.text,
      "Password": pass,
    });
      _sendEmail();
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new ListTile( //Email
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
                  ButtonTheme( //botão
                    buttonColor: Color.fromARGB(255, 173, 216, 230),
                    minWidth: 200.0,
                    height: 50.0, //Tamanho botão
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          recuperar();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                          'Recuperar',
                          style: TextStyle(fontSize: 20)
                      ),
                    ),
                  ),
                  Text(msg,
                    style: TextStyle(fontSize: 18.0, color: Colors.blue),
                  ),
                ],),
            ],),
        ),

      ),

    );
  }
}
