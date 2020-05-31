import 'package:damapp/pages/Emprego/listEmprego.dart';
import 'package:damapp/pages/Emprego/myEmprego.dart';
import 'package:damapp/pages/EspVerdes/listEspVerdes.dart';
import 'package:damapp/pages/EspVerdes/myEspVerdes.dart';
import 'package:damapp/pages/initialPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String _cidade,_email="";
class InitialP1 extends StatefulWidget {
  final String cidade,email;
  //Construtor
  InitialP1({Key key,@required this.email, @required this.cidade}): super(key: key);

  @override
  _InitialP1State createState(){
    _cidade=this.cidade;
    _email=this.email;
    return _InitialP1State();
  }
}

class _InitialP1State extends State<InitialP1> {

  int _selectedIndex = 2;

  //VERIFICA ITEM SELECIONADO MENU INFERIOR
  void _onItemTapped(int index) {
    setState(() {
     //_selectedIndex = index;
      if(index==0)
        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>myEspVerdes(email: _email,cidade: _cidade,)));

      if(index==2) //Navigator.pushReplacementNamed(context, '/initialPage');
        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Initial(email: _email,cidade: _cidade)));

      if (index==3)
        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>myEmprego(email: _email,cidade: _cidade)));

    });
  }

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
        body:
        Container(
          //MENU SUPERIOR
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center ,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Column(
                  //icones barra superior
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>listEspVerdes(email: _email,cidade: _cidade)));
                      },
                      icon: Icon(Icons.landscape, size: 35,),
                    ),
                  ],
                ),
                Column(
                  //icones
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/listEmprego');
                      },
                      icon: Icon(Icons.home,size: 35,),
                    )
                  ],
                ),
                Column(
                  //icones
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/listEmprego');
                      },
                      icon: Icon(Icons.info, size: 35, ),
                    ),
                    Center(
                      child: Text(
                        _cidade,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Column(
                  //icones
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>listEmprego(email: _email,cidade: _cidade)));
                      },
                      icon: Icon(Icons.account_balance_wallet, size: 35,),
                    )
                  ],
                ),
                Column(
                  //icones
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/listEmprego');
                      },
                      icon: Icon(Icons.local_activity,size: 35,),
                    )
                  ],
                ),
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/mapa.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //MENU INFERIOR
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.landscape),
             title: Text('Verdes'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Habitação'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.border_all),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              title: Text('Emprego'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_activity),
              title: Text('Lazer'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      );
  }
}
