import 'package:flutter/material.dart';
import 'package:gestion_des_notes/Models/utilisateurs.dart';
import 'package:gestion_des_notes/Screens/connexion.dart';
import 'package:gestion_des_notes/Screens/list_des_matieres.dart';
import 'package:gestion_des_notes/Services/database_helper.dart';
import 'package:gestion_des_notes/Themes/colors.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  bool _passwordInVisible = true;
  final _formkey = GlobalKey<FormState>();
  final _adresseEditController = TextEditingController();
  final _nomEditController = TextEditingController();
  final _prenomEditController = TextEditingController();
  final _telephoneEditController = TextEditingController();
  final _emailEditController = TextEditingController();
  final _passwordEditController = TextEditingController();
// List of dropdown items for gender
  final List<String> _genderItems = ['Masculin', 'Feminin'];
// Selected gender item
  String? _selectedGender;
  bool isEmail(String input) =>
      RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(input);
  bool isPhone(String input) => RegExp(r'^[0-9]{9}$').hasMatch(input);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: myblueColor,
          title: Text(
            "Inscription",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _prenomEditController,
                              validator: (String? value) {
                                if (value!.length == 0) {
                                  return "le champs ne doit pas etre vide";
                                }
                                return null;
                              },
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                labelText: 'Prénom ',
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _nomEditController,
                              validator: (String? value) {
                                if (value!.length == 0) {
                                  return "le champs ne doit pas etre vide";
                                }
                                return null;
                              },
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                labelText: 'Nom',
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _adresseEditController,
                              validator: (String? value) {
                                if (value!.length == 0) {
                                  return "le champs ne doit pas etre vide";
                                }
                                return null;
                              },
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                labelText: 'Adresse',
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedGender,
                              items: _genderItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedGender = newValue;
                                });
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez sélectionner un sexe";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Sexe',
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _telephoneEditController,
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                labelText: 'Numéro téléphone',
                              ),
                              validator: (String? value) {
                                if (value!.length == 0) {
                                  return "le champs ne doit pas etre vide";
                                }
                                if (!isPhone(value)) {
                                  return "numéro téléphone invalide";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _emailEditController,
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                              ),
                              validator: (String? value) {
                                if (value!.length == 0) {
                                  return "le champs ne doit pas etre vide";
                                }
                                if (!isEmail(value)) {
                                  return "e-mail invalide";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _passwordEditController,
                              validator: (String? value) {
                                if (value!.length == 0) {
                                  return "le champs ne doit pas etre vide";
                                }
                                return null;
                              },
                              obscureText: _passwordInVisible,
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
                            const SizedBox(height: 20.0),
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
                          ],
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Déja membre ? ',
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: const Text(
                            'Connectez-vous',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ])));
  }

  Future<void> _handleSubmit(BuildContext context) async {
    try {
      if (_formkey.currentState!.validate()) {
        AlertDialog alert = AlertDialog(
          content: Row(children: [
            CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Inscription en cours...",
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
        User user = User(
            id: DateTime.now().millisecondsSinceEpoch,
            prenom: _prenomEditController.text.trim(),
            nom: _nomEditController.text.trim(),
            adresse: _adresseEditController.text.trim(),
            telephone: _telephoneEditController.text.trim(),
            sexe: _selectedGender!,
            email: _emailEditController.text.trim(),
            password: _passwordEditController.text.trim());
        DatabaseHelper.instance.insertUser(user);
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('Enregistremment effectué avec success'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            });
      }
    } catch (error) {
      print(error);
    }
  }
}
