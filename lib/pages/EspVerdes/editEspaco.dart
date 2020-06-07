import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:http/http.dart' as http;
import 'package:damapp/models/conexao.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

class editEspaco extends StatefulWidget {
  final List list;
  final int index;
  final String email,cidade,img1,img2;

  editEspaco({this.index,this.list,this.email,this.cidade,this.img1,this.img2});

  @override
  _editEspacoState createState() => _editEspacoState();
}

class _editEspacoState extends State<editEspaco> {

  String img1Inicial,img2Inicial; //Para enviar no pedido e verificar se é necessário fazer update a imagem ou nao
  String urlimages,urlimages2;
  int contador=1;


  TextEditingController controllerDesignacao = new TextEditingController();
  TextEditingController controllerDescricao = new TextEditingController();
  TextEditingController controllerLocalizacao = new TextEditingController();

  @override
  void initState() {
    controllerDesignacao= new TextEditingController(text: widget.list[widget.index]['Designacao'] );
    controllerDescricao= new TextEditingController(text: widget.list[widget.index]['Descricao'] );
    controllerLocalizacao= new TextEditingController(text: widget.list[widget.index]['Localizacao'] );
    urlimages=widget.img1; img1Inicial=widget.img1;
    urlimages2=widget.img2; img2Inicial=widget.img2;
    super.initState();
  }

  var _formKey = GlobalKey<FormState>();

  //Adicionar proposta de emprego
  void EditEspaco() {
    conexao cn = new conexao();
    var url = cn.url + "editEspaco.dart.php";
    http.post(url, body: {
      "id": widget.list[widget.index]['Id_Espaco'],
      "Designacao": controllerDesignacao.text,
      "Localizacao":controllerLocalizacao.text,
      "Descricao": controllerDescricao.text,
      "Estado":  "1", //ativo por defeito
      "Email": widget.email, //email user
      "Cidade": widget.cidade,
      "TipoEspaco": "1", //1-Espaços verdes, 2-Espaços de lazer
      "img1In":img1Inicial,
      "img2In":img2Inicial,
      "Img1":urlimages,
      "Img2":urlimages2,
    });
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
              icon: Icon(
                Icons.exit_to_app,
              )
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.file_upload),
        onPressed: ()=>getGaleria(),
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
                      "Editar espaço verde",
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
                        hintText: "Nome do espaço ", labelText: "Designação",
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
                        hintText: "Descrição acerca do espaço", labelText: "Descrição",
                      ),
                    ),
                  ),
                  new ListTile( //Localização
                    title: new TextFormField(
                      maxLines: 2,
                      controller: controllerLocalizacao,
                      validator: (value) {
                        if (value.isEmpty) return "Insira a localização!";
                      },
                      decoration: new InputDecoration(
                        hintText: "Localização do espaço.", labelText: "Localização",
                      ),
                    ),
                  ),
                  Text("Imagens", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  urlimages=="SemImagem"?
                  Center(child: Text("Sem imagem 1 carregada!")):
                  Center(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => CircularProgressIndicator(),
                      imageUrl: 'https://ucarecdn.com/'+urlimages+'/',
                      width: 320,
                      height: 232,
                    ),
                  ),
                  urlimages2=="SemImagem"?
                  Center(child: Text("Sem imagem 2 carregada!")):
                  Center(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => CircularProgressIndicator(),
                      imageUrl: 'https://ucarecdn.com/'+urlimages2+'/',
                      width: 320,
                      height: 232,
                    ),
                  ),
                  ButtonTheme( //botão
                    buttonColor: Color.fromARGB(255, 173, 216, 230),
                    minWidth: 200.0,
                    height: 50.0, //Tamanho botão
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          EditEspaco();
                          // Navigator.pop(context);
                          Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (BuildContext context)=> new InitialP1(email: widget.email , cidade: widget.cidade),
                              ));
                        }
                      },
                      child: const Text(
                          'Editar',
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

  //Obter galeria
  getGaleria() async{ //async precisa ser exeutado em segundo plano
    var filename = await ImagePicker.pickImage(source: ImageSource.gallery); //aplicação espera nesta linha até escolher imagem em segundo plano
    upload(filename);
  }

  //Fazer upload de imagens
  upload(File imageFile) async{

    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length =  await imageFile.length();
    var uri = Uri.parse('https://upload.uploadcare.com/base/');

    var request = http.MultipartRequest('POST', uri);
    var multipartFile = http.MultipartFile('uploadedfile', stream, length,  filename:  imageFile.path);

    request.files.add(multipartFile);
    request.fields.addAll({'UPLOADCARE_PUB_KEY': 'demopublickey'}); //CHAVE PUBLICA

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen( (value){
      final JsonDecoder decoder = JsonDecoder();
      dynamic map = decoder.convert(value ?? ''); //se resposta for null retorna um valor, sn retorna ''

      setState(() {
        //verifica contador, se for nº par carrega imagem 1, se for impar carrega imagem 2 - MAX 5 TENTATIVAS
        if(contador%2!=0)
          urlimages = map['uploadedfile']; //adiciona valor da url
        if(contador%2==0)
          urlimages2 = map['uploadedfile']; //adiciona valor da url

        contador+=1;
      });
    });
  }
}
