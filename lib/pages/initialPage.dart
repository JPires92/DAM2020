import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



String cidade="";

class Initial extends StatefulWidget {
  Initial({this.username}); //email user
  final String username;

  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  //TextEditingController controllerDistrito = new TextEditingController();

  String _mySelection;
  //Lista Concelhos
  List<Map> _myJson = [{"id":0,"name":"Abrantes"},{"id":1,"name":"Águeda"}, {"id":2,"name":"Aguiar da Beira"},{"id":3,"name":"Braga"}];

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
              children: <Widget>[
                Spacer(),
                Text(
                  "Selecione a cidade",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                DropdownButton<String>(
                  isDense: true,
                  hint: new Text("Cidade"),
                  iconSize: 50.0,
                  elevation: 30,
                  value: _mySelection,
                  onChanged: (String newValue) {
                    setState(() {
                      _mySelection = newValue;
                    });
                    print (_mySelection);
                  },
                  items: _myJson.map((Map map) {
                    return new DropdownMenuItem<String>(
                      //value: map["id"].toString(),
                      value: map["name"].toString(),
                      child: new Text(
                        map["name"],
                      ),
                    );
                  }).toList(),
                ),
                ButtonTheme(
                  buttonColor: Colors.grey,
                  minWidth: 180.0,
                  height: 30.0, //Tamanho botão
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/initialPage1');
                      setState(() {
                        cidade=_mySelection;
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
