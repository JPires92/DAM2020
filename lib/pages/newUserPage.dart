import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class newUser extends StatefulWidget {
  @override
  _newUserState createState() => _newUserState();
}

class _newUserState extends State<newUser> {

  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerRepeatPassword = new TextEditingController();


  var _formKey = GlobalKey<FormState>();

  void addUser() {
    var url = "http://192.168.1.2/dam/addUser.php";

    http.post(url, body: {
      "nome": controllerName.text,
      "password": controllerPassword.text,
      "email": controllerEmail.text,
      "estado":  "1", //ativo
      "tipoUtilizador": "2", //por defeito é utilizador normal
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(

        title: new Text("Novo Utilizador"),
        backgroundColor: Color.fromARGB(255, 173, 216, 230),
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
                      controller: controllerName,
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
                          addUser();
                          Navigator.pop(context);
                          }
                      },
                      child: const Text(
                          'Registar',
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