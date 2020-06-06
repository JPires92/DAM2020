import 'dart:convert';
import 'package:damapp/models/conexao.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:flutter/material.dart';
import 'package:damapp/pages/Habitacao/editHabitacao.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

String categoria="";
class detailHabitacao extends StatefulWidget {
  List list;
  int index;
  String email;
  String cidade;

  detailHabitacao({this.index,this.list,this.email,this.cidade});


  @override
  _detailHabitacaoState createState() {
    return _detailHabitacaoState();
  }
}

class _detailHabitacaoState extends State<detailHabitacao> {

  String urlimages="SemImagem";
  String urlimages2="SemImagem";

  //Apagar registo
  void deleteData(){
    conexao cn=new conexao();
    var url= cn.url+"deleteHabitacao.php";
    http.post(url, body: {
      'id': widget.list[widget.index]['Id_Habitacao'],
      'Img1': urlimages,
      'Img2': urlimages2,
    });
  }

  void getImagens() async {
    conexao cn=new conexao();
    var url= cn.url+"getImagensHabitacao.php";
    final response = await http.post(url, body: {
      "Id": widget.list[widget.index]['Id_Habitacao'].toString(),
    });
    var data = json.decode(response.body);
    if(data.length!=0){
      setState(() {
        urlimages= data[0]['Localizacao'];
        urlimages2= data[1]['Localizacao'];
      });
    }
  }

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
        categoria= datacategoria[0]['Oferta'];
      });
    }
  }

  @override
  void initState() {
    getCategoria();
    getImagens();
    super.initState();
  }

  void confirm (){
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Deseja eliminar anuncio: '${widget.list[widget.index]['Designacao']}'"),
      actions: <Widget>[
        new RaisedButton(
          child: new Text("ELIMINAR",style: new TextStyle(color: Colors.black),),
          color: Colors.red,
          onPressed: (){
            deleteData();
            Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context)=> new InitialP1(email: widget.email , cidade: widget.cidade),
                )
            );
          },
        ),
        new RaisedButton(
          child: new Text("CANCELAR",style: new TextStyle(color: Colors.black)),
          color: Colors.green,
          onPressed: ()=> Navigator.pop(context),
        ),
      ],
    );

    showDialog(context: context, child: alertDialog);
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
      resizeToAvoidBottomInset: false,
      body:
      SingleChildScrollView(child:
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
                new Text("${widget.list[widget.index]['Preco']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
                Divider(),
                //Oferta
                new Text("Oferta", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text(categoria, style: new TextStyle(fontSize: 16.0),),
                Divider(),
                //Email pra contacto
                new Text("Email Contacto", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['EmailContato']}", style: new TextStyle(fontSize: 16.0),),
                Divider(),
                Text("Imagens", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                urlimages=="SemImagem"?
                Text(" "):
                CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: 'https://ucarecdn.com/'+urlimages+'/',
                  width: 320,
                  height: 232,
                ),
                Divider(),
                urlimages2=="SemImagem"?
                Text(" "):
                CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: 'https://ucarecdn.com/'+urlimages2+'/',
                  width: 320,
                  height: 232,
                ),

                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new RaisedButton(
                        child: new Text("EDITAR"),
                        color: Color.fromARGB(255, 173, 216, 230),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new editHabitacao(
                                  index: widget.index,
                                  list: widget.list,
                                  email: widget.email,
                                  cidade: widget.cidade,
                                  img1: urlimages,
                                  img2: urlimages2,
                                ),
                              )
                          );
                        }
                    ),
                    VerticalDivider(),
                    new RaisedButton(
                      child: new Text("ELIMINAR"),
                      color: Colors.redAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: ()=>confirm(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      ),);
  }
}
