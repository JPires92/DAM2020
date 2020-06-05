import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:http/http.dart' as http;
import 'package:damapp/models/atividade.dart';
import 'package:damapp/models/conexao.dart';


class editEmprego extends StatefulWidget {
  final List list;
  final int index;
  final String email,cidade;


  editEmprego({this.index,this.list,this.email,this.cidade});

  @override
  _editEmpregoState createState() => new _editEmpregoState();
}

class _editEmpregoState extends State<editEmprego> {

  TextEditingController controllerDesignacao = new TextEditingController();
  TextEditingController controllerDescricao = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerAtividade = new TextEditingController();
  atividade _currentAtividade;
  var _formKey = GlobalKey<FormState>();


  void editData() {
    conexao cn = new conexao();
    var url = cn.url + "editEmprego.php";
    http.post(url, body: {
      "id": widget.list[widget.index]['Id_Emprego'],
      "Designacao": controllerDesignacao.text,
      "Descricao": controllerDescricao.text,
      "EContacto": controllerEmail.text,
      "idAtividade": _currentAtividade.id,
    });
  }


  @override
  void initState() {
    controllerDesignacao= new TextEditingController(text: widget.list[widget.index]['Designacao'] );
    controllerDescricao= new TextEditingController(text: widget.list[widget.index]['Descricao'] );
    controllerEmail= new TextEditingController(text: widget.list[widget.index]['EmailContacto'] );
    super.initState();
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
        title: new Text('Fixa-te'),
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
                      "Editar oferta de emprego",
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