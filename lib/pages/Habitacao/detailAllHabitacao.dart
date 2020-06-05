import 'dart:convert';
import 'package:damapp/models/conexao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String categoria="";
class detailAllHabitacao extends StatefulWidget {
  List list;
  int index;
  String email;
  String cidade;

  detailAllHabitacao({this.index,this.list,this.email,this.cidade});

  @override
  _detailAllHabitacaoState createState() => _detailAllHabitacaoState();
}

class _detailAllHabitacaoState extends State<detailAllHabitacao> {

  void getCategoria() async {
    conexao cn=new conexao();
    var url= cn.url+"getTipoOferta.php";
    final response = await http.post(url, body: {
      "Id": widget.list[widget.index]['Id_TipoOferta'].toString(),
    });

    var datacategoria = json.decode(response.body);
    if(datacategoria.length==0){
      setState(() {
        categoria="Sem oferta.";
      });
    }else{
      setState(() {
        categoria= datacategoria[0]['TipoOferta'];
      });
    }
  }

  @override
  void initState() {
    getCategoria();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getCategoria();
    return new Scaffold(
      appBar:  new AppBar(
        title: new Text('Habitações existentes'),
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
      body:
      new Container(
        //height: 300.0,
        // padding: const EdgeInsets.all(20.0),
        child: new Card(
          child: new Center(
            child: new Column(
              children: <Widget>[
                //Designação
                new Text(""),
                new Text(widget.list[widget.index]['Designacao'], style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                Divider(),
                //Descrição
                new Text("Descrição", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['Descricao']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
                Divider(),
                //Preco
                new Text("Preço", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['Preço']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
                Divider(),
                //Categoria
                new Text("Oferta", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text(categoria, style: new TextStyle(fontSize: 16.0),),
                Divider(),
                //Email pra contacto
                new Text("Email Contacto", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['EmailContacto']}", style: new TextStyle(fontSize: 16.0),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}