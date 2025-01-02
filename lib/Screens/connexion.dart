import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_des_notes/Models/utilisateurs.dart';
import 'package:gestion_des_notes/Screens/list_des_matieres.dart';
import 'package:gestion_des_notes/Screens/signup_screen.dart';
import 'package:gestion_des_notes/Services/database_helper.dart';
import 'package:gestion_des_notes/Themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  bool _passwordInVisible = true;
  final _formkey = GlobalKey<FormState>();
  final _emailEditController = TextEditingController();
  final _passwordEditController = TextEditingController();
  SharedPreferences? preferences;
  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/profil.png",
              height: 250,
            ),
            const SizedBox(height: 40),
            Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailEditController,
                        validator: (String? value) {
                          if (value!.length == 0) {
                            return "le champs ne doit pas etre vide";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _passwordEditController,
                        validator: (String? value) {
                          if (value!.length == 0) {
                            return "le champs ne doit pas etre vide";
                          }
                          return null;
                        },
                        obscureText: _passwordInVisible,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordInVisible =
                                    !_passwordInVisible; //change boolean
                              });
                            },
                            icon: Icon(
                              _passwordInVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                          color: myblueColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextButton(
                          child: Text(
                            "Connexion",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            _handleSubmit(context);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Nouveau membre ? ',
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          },
                          child: Text(
                            'Inscrivez-vous',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: myredColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    ])));
  }

  _handleSubmit(BuildContext context) {
    if (_formkey.currentState!.validate()) {
      AlertDialog alert = AlertDialog(
        content: Row(children: [
          CircularProgressIndicator(
            backgroundColor: Colors.red,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black, //<-- SEE HERE
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 10),
              child: Text("Authentification en cours...",
                  style: TextStyle(
                      fontSize: 12,
//fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat-Bold',
                      color: Colors.red),
                  maxLines: 2,
                  textAlign: TextAlign.center)),
        ]),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      var email = _emailEditController.text.trim();
      var password = _passwordEditController.text.trim();
      DatabaseHelper.instance.checkUserLogin(email, password).then((result) {
        if (result != -1) {
          User? user = result;
          String userEncode = jsonEncode(user?.toMap());
          this.preferences!.setString('currentUser', userEncode);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Authentiification réussie',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ListDesMatieres()));
        } else {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('Email ou mot de passe incorect'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }
}
