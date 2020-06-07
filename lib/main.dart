import 'package:damapp/pages/Emprego/listEmprego.dart';
import 'package:damapp/pages/initialPage.dart';
import 'package:damapp/pages/initialPage1.dart';
import 'package:damapp/pages/loginPage.dart';
import 'file:///C:/Users/jp251/Desktop/Curso/DAM/dam_app/lib/pages/Admin/adminPage.dart';
import 'file:///C:/Users/jp251/Desktop/Curso/DAM/dam_app/lib/pages/Utilizador/newUserPage.dart';
import 'file:///C:/Users/jp251/Desktop/Curso/DAM/dam_app/lib/pages/Utilizador/recuperarPass.dart';
import 'package:flutter/material.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fixa-te',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: new MyHomePage(),
      routes: <String,WidgetBuilder>{
        '/MyHomePage': (BuildContext context)=> new MyHomePage(),
        '/loginPage': (BuildContext context)=> new LoginPage(),
        '/newUserPage': (BuildContext context)=>new newUser(),
        '/adminPage': (BuildContext context)=> new Admin(),
        '/initialPage': (BuildContext context)=> new Initial(),
        '/initialPage1': (BuildContext context)=> new InitialP1(),
        '/listEmprego':(BuildContext context) => new listEmprego(),
        '/recuperarPass':(BuildContext context) => new recuperarPass(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(
            top: 130
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Container( //Imagem
                child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Image(
                      width: 135,
                      height: 135,
                      image: new AssetImage('assets/images/fixa-te.png'),
                    )
                ),
                width: 170.0,
                height: 170.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle
                ),
              ),
              Container( //Texto
                child: Text(
                  'Fixa-te',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ButtonTheme(
                buttonColor: Color.fromARGB(255, 173, 216, 230),
                minWidth: 200.0,
                height: 40.0, //Tamanho botão
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginPage');
                    //Navigator.pushNamed(context, '/form');
                  },
                  child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20)
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child:InkWell(
                  child: Text(
                    'Registar-me',
                    style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: (){
                    Navigator.pushNamed(context,'/newUserPage');
                  },
                ),
              ),],
          ),
        ),
      ),
    );
  }
}
