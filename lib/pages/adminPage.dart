import 'package:flutter/material.dart';


class Admin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('Página Inicio admin'),),
      body: new Column(
        children: <Widget>[
          Text("Estamos na página inicial"),
          RaisedButton(
            child: Text("Sair"),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/loginPage');
            },
          )
        ],
      ),
    );
  }
}
