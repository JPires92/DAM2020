import 'dart:convert';

import 'package:damapp/models/atividade.dart';
import 'package:damapp/models/conexao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String _cidade,_email="";

class novoEmprego extends StatefulWidget {

  final String cidade;
  final String email;
  //Construtor
  novoEmprego({Key key,@required this.email, @required this.cidade}): super(key: key);


  @override
  _novoEmpregoState createState() {

    _cidade=this.cidade;
    _email=this.email;

    return _novoEmpregoState();
  }
}

class _novoEmpregoState extends State<novoEmprego> {

  TextEditingController controllerDesignacao = new TextEditingController();
  TextEditingController controllerDescricao = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerAtividade = new TextEditingController();
  atividade _currentAtividade;

  var _formKey = GlobalKey<FormState>();

  //Adicionar proposta de emprego
  void addEmprego() {
    conexao cn = new conexao();
    var url = cn.url + "addEmprego.php";
    //var url = "http://192.168.1.2/dam/addUser.php";
    http.post(url, body: {
      "Designacao": controllerDesignacao.text,
      "Descricao": controllerDescricao.text,
      "EContacto": controllerEmail.text,
      "Estado":  "1", //ativo por defeito
      "Email": _email, //email user
      "IdAtividade": _currentAtividade.id, //informática
      "Cidade":_cidade,
    });
  }


  Future<List<atividade>> _fetchAtividades() async {
    conexao cn =new conexao();
    final String url= cn.url+"getAtividades.php";

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<atividade> listOfAtividades = items.map<atividade>((json) {
        return atividade.fromJson(json);
      }).toList();
      return listOfAtividades;
    } else {
      throw Exception('Erro!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
      body:
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Nova oferta de emprego",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ),
                  new ListTile( //Designacao
                    title: new TextFormField(
                      controller: controllerDesignacao,
                      validator: (value) {
                        if (value.isEmpty) return "Insira a designação!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Título do anúncio ", labelText: "Designação",
                      ),
                    ),
                  ),
                  new ListTile(//Descrição
                    title: new TextFormField(
                      maxLines: 6,
                      controller: controllerDescricao,
                      validator: (value) {
                        if (value.isEmpty) return "Insira a Descrição!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Descrição do anúncio", labelText: "Descrição",
                      ),
                    ),
                  ),
                  new ListTile( //Email de contacto
                    title: new TextFormField(
                      controller: controllerEmail,
                      validator: (value) {
                        if (value.isEmpty) return "Insira o email para contacto!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Email para contacto", labelText: "Email de contacto",
                      ),
                    ),
                  ),
                  new ListTile( //Categoria selecionada
                    title: new TextFormField(
                      controller: controllerAtividade,
                      enabled: false,
                      validator: (value) {
                        if (value.isEmpty) return "Escolha a categoria";
                      },
                      decoration: new InputDecoration(
                          hintText: controllerAtividade.text, labelText: "Categoria"
                      ),
                    ),
                  ),
                  new FutureBuilder<List<atividade>>( //Lista de categorias
                      future: _fetchAtividades(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<atividade>> snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();
                        return DropdownButton<atividade>(
                          items: snapshot.data
                              .map((_atividade) => DropdownMenuItem<atividade>(
                            child: Text(_atividade.label),
                            value: _atividade,
                          ))
                              .toList(),
                          onChanged: (atividade value) {
                            setState(() {
                              _currentAtividade=value;
                              controllerAtividade.text=value.label;
                            });
                          },
                          isExpanded: false,
                          hint: Text('Selecione a categoria'),
                        );
                      }),
                  new Padding(
                    padding: const EdgeInsets.all(30.0),
                  ),
                  ButtonTheme( //botão
                    buttonColor: Colors.grey,
                    minWidth: 200.0,
                    height: 50.0, //Tamanho botão
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          addEmprego();
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