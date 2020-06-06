import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:http/http.dart' as http;
import 'package:damapp/models/tipoOferta.dart';
import 'package:damapp/models/conexao.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';


class editHabitacao extends StatefulWidget {
  final List list;
  final int index;
  final String email,cidade,img1,img2;


  editHabitacao({this.index,this.list,this.email,this.cidade,this.img1,this.img2});

  @override
  _editHabitacaoState createState() => new _editHabitacaoState();
}

class _editHabitacaoState extends State<editHabitacao> {

  String img1Inicial,img2Inicial; //Para enviar no pedido e verificar se é necessário fazer update a imagem ou nao
  String urlimages,urlimages2;
  int contador=1;

  TextEditingController controllerDesignacao = new TextEditingController();
  TextEditingController controllerDescricao = new TextEditingController();
  TextEditingController controllerPreco = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerTipoOferta = new TextEditingController();
  tipoOferta _currentTipoOferta;
  var _formKey = GlobalKey<FormState>();


  void editData() {
    conexao cn = new conexao();
    var url = cn.url + "editHabitacao.php";
    http.post(url, body: {
      "id": widget.list[widget.index]['Id_Habitacao'],
      "Designacao": controllerDesignacao.text,
      "Descricao": controllerDescricao.text,
      "Preco": controllerPreco.text,
      "EContacto": controllerEmail.text,
      "IdTipoOferta": _currentTipoOferta.id,
      "img1In":img1Inicial,
      "img2In":img2Inicial,
      "Img1":urlimages,
      "Img2":urlimages2,
    });
  }


  @override
  void initState() {
    controllerDesignacao= new TextEditingController(text: widget.list[widget.index]['Designacao'] );
    controllerDescricao= new TextEditingController(text: widget.list[widget.index]['Descricao'] );
    controllerPreco= new TextEditingController(text: widget.list[widget.index]['Preco'] );
    controllerEmail= new TextEditingController(text: widget.list[widget.index]['EmailContato'] );
    urlimages=widget.img1; img1Inicial=widget.img1;
    urlimages2=widget.img2; img2Inicial=widget.img2;

    super.initState();
  }


  Future<List<tipoOferta>> _fetchTipoOferta() async {
    conexao cn =new conexao();
    final String url= cn.url+"getTipoOfertas.php";

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<tipoOferta> listOfTipoOferta = items.map<tipoOferta>((json) {
        return tipoOferta.fromJson(json);
      }).toList();
      return listOfTipoOferta;
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


      floatingActionButton: FloatingActionButton(child: Icon(Icons.file_upload),
        onPressed: ()=>getGaleria(),
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
                      "Editar oferta de habitacao",
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
                  new ListTile(//Preco
                    title: new TextFormField(
                      controller: controllerPreco,
                      validator: (value) {
                        if (value.isEmpty) return "Insira o Preço!";
                      },
                      decoration: new InputDecoration(
                        hintText: "€", labelText: "Preço",
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
                  new ListTile( //Oferta selecionada
                    title: new TextFormField(
                      controller: controllerTipoOferta,
                      enabled: false,
                      validator: (value) {
                        if (value.isEmpty) return "Escolha a oferta";
                      },
                      decoration: new InputDecoration(
                          hintText: controllerTipoOferta.text, labelText: "Oferta"
                      ),
                    ),
                  ),
                  new FutureBuilder<List<tipoOferta>>( //Lista de categorias
                      future: _fetchTipoOferta(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<tipoOferta>> snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();
                        return DropdownButton<tipoOferta>(
                          items: snapshot.data
                              .map((_tipoOferta) => DropdownMenuItem<tipoOferta>(
                            child: Text(_tipoOferta.label),
                            value: _tipoOferta,
                          ))
                              .toList(),
                          onChanged: (tipoOferta value) {
                            setState(() {
                              _currentTipoOferta=value;
                              controllerTipoOferta.text=value.label;
                            });
                          },
                          isExpanded: false,
                          hint: Text('Selecione a oferta'),
                        );
                      }),
                  new Padding(
                    padding: const EdgeInsets.all(15.0),
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

                  new Padding(
                    padding: const EdgeInsets.all(15.0),
                  ),

                  ButtonTheme( //botão
                    buttonColor: Color.fromARGB(255, 173, 216, 230),
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
    //request.fields.addAll({'UPLOADCARE_PUB_KEY': 'bb209e6bc36b1b7bb8aa'}); //CHAVE PESSOAL
    // bb209e6bc36b1b7bb8aa
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




