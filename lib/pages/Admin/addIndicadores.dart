import 'package:damapp/pages/Admin/adminPage1.dart';
import 'package:http/http.dart' as http;
import 'package:damapp/models/conexao.dart';
import 'package:flutter/material.dart';


String _cidade="";
class addIndicadores extends StatefulWidget {
  final String cidade;

  //Construtor
  addIndicadores({Key key, @required this.cidade}): super(key: key);
  @override
  _addIndicadoresState createState(){
    _cidade=this.cidade;
    return _addIndicadoresState();
  }
}

class _addIndicadoresState extends State<addIndicadores> {
  TextEditingController controllerQualidadeVida = new TextEditingController();
  TextEditingController controllerMinutosTransito = new TextEditingController();
  TextEditingController controllerQntEspVerdes = new TextEditingController();
  TextEditingController controllerNivelPoluicao = new TextEditingController();
  TextEditingController controllerDensidadePopulacional = new TextEditingController();
  TextEditingController controllerLongevidadePopulacional = new TextEditingController();
  TextEditingController controllerHospitaisCS = new TextEditingController();

  var _formKey = GlobalKey<FormState>();

  //Adicionar proposta de emprego
  void addIndicadores() {
    conexao cn = new conexao();
    var url = cn.url + "addIndicadores.php";
    http.post(url, body: {
      "QualidadeVida": controllerQualidadeVida.text,
      "MinutosTransito": controllerMinutosTransito.text,
      "QntEspVerdes": controllerQntEspVerdes.text,
      "NivelPoluicao":  controllerNivelPoluicao.text,
      "DensidadePopulacional": controllerDensidadePopulacional.text,
      "LongevidadePopulacional": controllerLongevidadePopulacional.text,
      "HospitaisCS": controllerHospitaisCS.text,
      "Cidade":_cidade,
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Indicadores'),
        backgroundColor: Color.fromARGB(255, 173, 216, 230),
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
                      "Indicadores de "+_cidade,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ),
                  new ListTile( //QualidadeVida
                    title: new TextFormField(
                      controller: controllerQualidadeVida,
                      validator: (value) {
                        if (value.isEmpty) return "Insira um valor para qualidade de vida!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Qualidade de vida", labelText: "Qualidade de vida",
                      ),
                    ),
                  ),
                  new ListTile(//MinutosTransito
                    title: new TextFormField(
                      controller: controllerMinutosTransito,
                      validator: (value) {
                        if (value.isEmpty) return "Insira o tempo médio de minutos no trânsito!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Tempo médio de minutos no trânsito", labelText: "Minutos trânsito",
                      ),
                    ),
                  ),
                  new ListTile( //QntEspVerdes
                    title: new TextFormField(
                      controller: controllerQntEspVerdes,
                      validator: (value) {
                        if (value.isEmpty) return "Insira o nº de espaços verdes!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Nº de espaços verdes", labelText: "Nº Espaços Verdes",
                      ),
                    ),
                  ),
                  new ListTile( //NivelPoluicao
                    title: new TextFormField(
                      controller: controllerNivelPoluicao,
                      validator: (value) {
                        if (value.isEmpty) return "Insira o nivel de poluição!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Nivel de poluição", labelText: "Nivel de Poluição",
                      ),
                    ),
                  ),
                  new ListTile( //DensidadePopulacional
                    title: new TextFormField(
                      controller: controllerDensidadePopulacional,
                      validator: (value) {
                        if (value.isEmpty) return "Insira a densidade populacional!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Densidade populacional (hab/km^2)", labelText: "Densidade Populacional",
                      ),
                    ),
                  ),
                  new ListTile( //LongevidadePopulacional
                    title: new TextFormField(
                      controller: controllerLongevidadePopulacional,
                      validator: (value) {
                        if (value.isEmpty) return "Insira a esperança média de vida!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Esperança média de vida", labelText: "Longevidade Populacional",
                      ),
                    ),
                  ),
                  new ListTile( //HospitaisCS
                    title: new TextFormField(
                      controller: controllerHospitaisCS,
                      validator: (value) {
                        if (value.isEmpty) return "Insira o nº de Hospitais+C.Saúde!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Nº de Hospitais + C.Saúde", labelText: "Nº de Hospitais+C.Saúde",
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(30.0),
                  ),
                  ButtonTheme( //botão
                    buttonColor:Color.fromARGB(255, 173, 216, 230),
                    //textTheme: ButtonTextTheme.accent,
                    //colorScheme:
                    //Theme.of(context).colorScheme.copyWith(secondary: Colors.white), // Text color
                    minWidth: 200.0,
                    height: 50.0, //Tamanho botão
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          addIndicadores();
                          //Navigator.pop(context);
                          Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (BuildContext context)=> new adminPage1(cidade: _cidade),
                              ));
                        }
                      },
                      child: const Text(
                          'Guardar',
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