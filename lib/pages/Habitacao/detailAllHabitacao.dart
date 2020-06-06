import 'dart:convert';
import 'package:damapp/models/conexao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';


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

  String urlimages="SemImagem";
  String urlimages2="SemImagem";

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

  @override
  Widget build(BuildContext context) {
    //getCategoria();
    return new Scaffold(
      resizeToAvoidBottomInset: false,
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
                //Categoria
                new Text("Oferta", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text(categoria, style: new TextStyle(fontSize: 16.0),),
                Divider(),
                //Email pra contacto
                new Text("Email Contacto", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                new Text("${widget.list[widget.index]['EmailContato']}", style: new TextStyle(fontSize: 16.0),),
               Divider(),
            //Localizacao
               new Text("Localização", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
               new Text("${widget.list[widget.index]['Localizacao']}", style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.center),
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

              ],
            ),
          ),
        ),
      ),
          ), );
  }
}