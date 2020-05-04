import 'package:damapp/pages/initialPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class InitialP1 extends StatefulWidget {
  InitialP1({this.username,this.cidade}); //email user
  final String username,cidade;

  @override
  _InitialP1State createState() => _InitialP1State();
}

class _InitialP1State extends State<InitialP1> {

  int _selectedIndex = 2;

  //Verifica item selecionado na barra 1 para navegação
  void _onItemTapped(int index) {
    setState(() {
     //_selectedIndex = index;
      if(index==0)
          Navigator.pushReplacementNamed(context, '/MyHomePage');

      if(index==2)
        Navigator.pushReplacementNamed(context, '/initialPage');

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center ,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Column(
                  //icones
                  children: <Widget>[
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.landscape, size: 35,),
                    ),
                  ],
                ),
                Column(
                  //icones
                  children: <Widget>[
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.home,size: 35,),
                    )
                  ],
                ),
                Column(
                  //icones
                  children: <Widget>[
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.info, size: 35, ),
                    ),
                    Center(
                      child: Text(
                        cidade,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Column(
                  //icones
                  children: <Widget>[
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.account_balance_wallet, size: 35,),
                    )
                  ],
                ),
                Column(
                  //icones
                  children: <Widget>[
                    IconButton(
                      onPressed: (){},
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
        //Barra de navegação inferior
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
