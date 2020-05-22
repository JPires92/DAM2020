import 'dart:convert';

import 'package:damapp/models/concelho.dart';
import 'package:damapp/models/conexao.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


 String _cidade,_email="";

class Initial extends StatefulWidget {

  final String cidade;
  final String email;
  //Construtor
  Initial({Key key,@required this.email, @required this.cidade}): super(key: key);
  //Initial({this.username}); //email user


  @override
  _InitialState createState(){
    
    _cidade=this.cidade;
    _email=this.email;
    
    return _InitialState();
  }
}

class _InitialState extends State<Initial> {

  concelho _currentCity;
  Future<List<concelho>> _fetchConcelhos() async {
    conexao cn =new conexao();
    final String uri= cn.url+"getdataConcelhos.php";

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
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/MyHomePage');
              },
              icon: Icon(
                Icons.exit_to_app,
              )
          ),
        ],
        title: Text("Fixa-te"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mapa.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child:Column(
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
                          .map((_concelho) => DropdownMenuItem<concelho>(
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
                buttonColor: Colors.grey,
                minWidth: 180.0,
                height: 30.0, //Tamanho botão
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>InitialP1(email: _email,cidade: _cidade)));
                    setState(() {
                      _cidade= _currentCity.label;
                    });
                    //Navigator.pushNamed(context,'/InitialP1');
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