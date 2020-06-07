import 'dart:convert';

import 'package:damapp/models/concelho.dart';
import 'package:damapp/models/conexao.dart';
import 'package:damapp/pages/Admin/Users.dart';
import 'package:damapp/pages/Admin/adminPage1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


String _cidade="";

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  concelho _currentCity;

  Future<List<concelho>> _fetchConcelhos() async {
    conexao cn = new conexao();
    final String uri = cn.url + "getdataConcelhos.php";

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<concelho> listOfConcelhos = items.map<concelho>((json) {
        return concelho.fromJson(json);
      }).toList();
      return listOfConcelhos;
    } else {
      throw Exception('Erro!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),

        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder:(context)=>adminUsers()));
              },
              icon: Icon(
                Icons.group,
              )
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/MyHomePage');
              },
              icon: Icon(
                Icons.exit_to_app,
              )
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/fixate4.png',
              fit: BoxFit.cover,
              height: 45.0,
            ),
          ],
        ),
        //title: Text('Fixa-te', style: TextStyle(color: Colors.black)),

      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mapa01.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Spacer(),
              FutureBuilder<List<concelho>>(
                  future: _fetchConcelhos(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<concelho>> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return DropdownButton<concelho>(
                      items: snapshot.data
                          .map((_concelho) =>
                          DropdownMenuItem<concelho>(
                            child: Text(_concelho.label),
                            value: _concelho,
                          ))
                          .toList(),
                      onChanged: (concelho value) {
                        setState(() {
                          _currentCity = value;
                        });
                      },
                      isExpanded: false,
                      hint: Text('Selecione a cidade'),
                    );
                  }),
              SizedBox(height: 20.0),
              _currentCity != null
                  ? Text("Cidade: " +
                  _currentCity.label)
                  : Text("Nenhuma cidade selecionada!"),
              ButtonTheme(
                buttonColor: Colors.white,
                minWidth: 180.0,
                height: 30.0, //Tamanho botão
                child: RaisedButton(
                  onPressed: () {
                    if (_currentCity != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                            adminPage1(cidade: _currentCity.label,)));
                    }
                    setState(() {
                      _cidade = _currentCity.label;
                    });
                  },
                  child: const Text(
                      'Continuar',
                      style: TextStyle(fontSize: 20)
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

