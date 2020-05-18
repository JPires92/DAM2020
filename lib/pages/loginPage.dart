
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



String username='';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController user=new TextEditingController();
  TextEditingController pass=new TextEditingController();

  String msg='';

  Future<List> _login() async {
    final response = await http.post("http://192.168.1.2/dam/login.php", body: {
      "Email": user.text,
      "Password": pass.text,
    });


    var datauser = json.decode(response.body);

    if(datauser.length==0){
      setState(() {
        msg="Login Fail";
      });
    }else{
      if(datauser[0]['Id_TipoUtilizador']=='1'){ //Admin

        Navigator.pushReplacementNamed(context, '/adminPage');
      }else if(datauser[0]['Id_TipoUtilizador']=='2'){//utilizador normal
        Navigator.pushReplacementNamed(context, '/initialPage');
      }
      setState(() {
        username= datauser[0]['Email'];
      });

    }
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        child: Container( //Fundo
          // decoration: new BoxDecoration(
          //  image: new DecorationImage(
          //     image: new AssetImage("assets/images/fixa-te.png"),
          //    fit: BoxFit.cover
          //),
          //),
          child: Column( //Iamgem
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top:77.0),
                child: new CircleAvatar(
                    backgroundColor: Color(0xF81F7F3),
                    child:new Image(
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
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top:93
                ),
                child: Column(
                  children: <Widget>[
                    Container(//Email
                      width:MediaQuery.of(context).size.width /1.2,
                      padding: EdgeInsets.only(
                          top:4, left: 16,right: 16, bottom: 4
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color:Colors.black12,
                                blurRadius: 5
                            )
                          ]
                      ),
                      child:TextFormField(
                        controller: user,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            hintText: 'Email'
                        ),
                      ),
                    ),
                    Container(//password
                      width: MediaQuery.of(context).size.width /1.2,
                      height: 50,
                      margin: EdgeInsets.only(
                          top:32
                      ),
                      padding: EdgeInsets.only(
                          top:4,left: 16, right: 16, bottom: 4
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow:[
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5
                            )
                          ]
                      ),
                      child: TextField(
                        controller: pass,
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.vpn_key,
                              color: Colors.black,
                            ),
                            hintText: 'Password'
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top:6, right: 32,
                        ),
                        child: Text(
                          'Recuperar password',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      buttonColor: Color.fromARGB(255, 173, 216, 230),

                      minWidth: 320.0,
                      height: 50.0,//Tamanho botão
                      child: RaisedButton(
                      child: new Text('Iniciar sessão',style: TextStyle(fontSize: 22),),


                      onPressed: (){
                        _login();
                        Navigator.pop(context);
                      },
                    ),
                    ),
                    Spacer(),
                    Text(msg,
                      style: TextStyle(fontSize: 25.0, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
