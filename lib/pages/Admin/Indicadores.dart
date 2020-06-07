
import 'dart:convert';
import 'package:damapp/pages/Admin/addIndicadores.dart';
import 'package:damapp/pages/Admin/editIndicadores.dart';
import 'package:http/http.dart' as http;
import 'package:damapp/models/conexao.dart';
import 'package:flutter/material.dart';

String _cidade,textoBT="";

String qVida,mTrans,qtVerdes,nPol,dPop,lPop,hosp="";
class Indicadores extends StatefulWidget {

  final String cidade;

  Indicadores({@required this.cidade});


  @override
  _IndicadoresState createState(){
    _cidade=this.cidade;
    qVida="-";mTrans="-";qtVerdes="-";nPol="-";dPop="-";lPop="-";hosp="-";textoBT="ADICIONAR";
    return _IndicadoresState();
  }
}

class _IndicadoresState extends State<Indicadores> {

  @override
  void initState() {
    _fetchIndicadores();
    super.initState();
  }
  //Carregar anuncios de espaços verdes pessoais
  void _fetchIndicadores() async {
    conexao cn =new conexao();
    final String url= cn.url+"getIndicadores.php";

    final response = await http.post(url, body: {
      "Cidade": _cidade,
    });

    var data = json.decode(response.body);

    if(data.length!=0){
      setState(() {
        qVida=data[0]['Valor'];
        mTrans=data[1]['Valor'];
        qtVerdes=data[2]['Valor'];
        nPol=data[3]['Valor'];
        dPop=data[4]['Valor'];
        lPop=data[5]['Valor'];
        hosp=data[6]['Valor'];
        textoBT="EDITAR";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  new AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/MyHomePage');
              },
              icon: Icon(Icons.exit_to_app,)
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/fixate4.png',
              fit: BoxFit.cover,
              height: 45.0,
            ),
          ],
        ),

      ),
      body:
      new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mapa04.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(5.0),
              ),
              new Text(
                "Indicadores "+ _cidade,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              new Padding(
                padding: const EdgeInsets.all(50.0),
              ),
              new Align(alignment: Alignment.center,
                child: new Text("Minutos diários de transito", style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, color: Colors.black),),
              ),
              new Align(alignment: Alignment.center,
                child: new Text(mTrans, style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),),
              ),
              new Align(alignment: Alignment.center,
                child: new Text("Quantidade de espaços verdes", style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, color: Colors.black),),
              ),
              new Align(alignment: Alignment.center,
                child: new Text(qtVerdes, style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),),
              ),
              new Align(alignment: Alignment.center,
                child: new Text("Nível de poluição", style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, color: Colors.black),),
              ),
              new Align(alignment: Alignment.center,
                child: new Text(nPol, style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),),
              ),
              new Align(alignment: Alignment.center,
                child: new Text("Densidade populacional (h/km^2)", style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, color: Colors.black),),
              ),
              new Align(alignment: Alignment.center,
                child: new Text(dPop, style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),),
              ),new Align(alignment: Alignment.center,
                child: new Text("Longevidade da População", style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, color: Colors.black),),
              ),
              new Align(alignment: Alignment.center,
                child: new Text(lPop, style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),),
              ),new Align(alignment: Alignment.center,
                child: new Text("Nº de Hospitais+Centros de saúde", style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, color: Colors.black),),
              ),
              new Align(alignment: Alignment.center,
                child: new Text(hosp, style:
                new TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),),
              ),

              new Padding(
                padding: const EdgeInsets.all(51.0),
              ),

              //Qualidade de vida
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Text("                                           Qualidade de vida: ",style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black),),
                  new Text(qVida, style:
                  new TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold, color: Colors.white),),
                ],
              ),
              new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new RaisedButton(
                    child: new Text(
                      textoBT,
                    ),
                    color:  Colors.grey,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(60.0)),
                    onPressed: (){
                      if(textoBT=="EDITAR")
                        {
                          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new editIndicadores(
                            cidade: widget.cidade,qvida: qVida,mtrans: mTrans,qtverdes: qtVerdes,npol: nPol,dpop: dPop,lpop: lPop,Hosp: hosp,)));
                        }else{
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new addIndicadores(cidade: widget.cidade,)));
                      }
                    },
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
