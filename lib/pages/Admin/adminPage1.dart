import 'package:damapp/pages/Admin/Empregos.dart';
import 'package:damapp/pages/Admin/Espacos.dart';
import 'package:damapp/pages/Admin/Habitacao.dart';
import 'package:damapp/pages/Admin/Indicadores.dart';
import 'package:damapp/pages/Admin/Users.dart';
import 'package:damapp/pages/Admin/adminPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String _cidade="";
class adminPage1 extends StatefulWidget {

  final String cidade;
  //Construtor
  adminPage1({Key key,@required this.cidade}): super(key: key);

  @override
  _adminPage1State createState(){
    _cidade=this.cidade;
    return _adminPage1State();
  }
}

class _adminPage1State extends State<adminPage1> {
  int _selectedIndex = 0;

  //VERIFICA ITEM SELECIONADO MENU INFERIOR
  void _onItemTapped(int index) {
    setState(() {
      //_selectedIndex = index;
      if (index == 4)
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>adminEmpregos(cidade: _cidade,)));

      if (index == 3)
         Navigator.of(context).push(MaterialPageRoute(builder:(context)=>adminHabitacao(cidade: _cidade)));

      if (index == 2)
         Navigator.of(context).push(MaterialPageRoute(builder:(context)=>adminEspacos(espaco: '2',cidade: _cidade))); //1-Esp verdes, 2-Esp Lazer

      if (index == 1)
        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>adminEspacos(espaco: '1',cidade: _cidade))); //1-Esp verdes, 2-Esp Lazer

      if (index == 0)
        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Indicadores(cidade: _cidade,)));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Admin()));
              },
              icon: Icon(
                Icons.favorite_border,
              )
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/MyHomePage');
              },
              icon: Icon(
                Icons.exit_to_app,
              )
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
      Container(
        child:
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    _cidade,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ]
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mapa04.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),

      //MENU INFERIOR
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('Indicadores'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.landscape),
            title: Text('EspVerdes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            title: Text('EspLazer'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Habitação'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            title: Text('Emprego'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
