import 'package:flutter/material.dart';

import 'package:gestion_des_notes/Models/etudiants.dart';
import 'package:gestion_des_notes/Services/database_helper.dart';
import 'package:gestion_des_notes/Themes/colors.dart';
import 'package:gestion_des_notes/Widgets/drawer.dart';

class GestionDesEtudiants extends StatefulWidget {
  const GestionDesEtudiants({super.key});

  @override
  _GestionDesEtudiantsState createState() => _GestionDesEtudiantsState();
}

class _GestionDesEtudiantsState extends State<GestionDesEtudiants> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _numeroEtudiantController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  late Future<List<Etudiants>> etudiants;

  String? selectedClasse;

  final List<String> listesClasses = ['IG1', 'IG2', 'IG3', 'SG1', 'SG2', 'SG3'];

  // Supprimer un Etudiant
  void delete(int? id) async {
    if (id != null) {
      final res = await dbHelper.deleteEtudiant(id);
      if (res > 0) {
        setState(() {
          _onRefresh();
        });
      }
    } else {
      // Gérer le cas où l'ID est nul
      print("L'ID est nul et ne peut pas être supprimé.");
    }
  }

  Future<List<Etudiants>> _fetchEtudiants() async {
    final eleve = await dbHelper.getEtudiants();
    return eleve;
  }

  Future<void> _onRefresh() async {
    setState(() {
      etudiants = _fetchEtudiants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: myblueColor,
        centerTitle: true,
        title: const Text(
          "Etudiants",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      drawer: const MyDrawer(),
      body: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: FutureBuilder(
              future: dbHelper.getEtudiants(), // Votre future ici
              builder: (BuildContext context,
                  AsyncSnapshot<List<Etudiants>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun Etudiant trouvé !!!"));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final List<Etudiants> items = snapshot.data ?? <Etudiants>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final Etudiants etudiant =
                          items[index]; // Récupère un étudiant spécifique
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Text("${etudiant.prenom} ${etudiant.nom}"),
                            titleTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                            subtitle: Text(etudiant.classe),
                            subtitleTextStyle: TextStyle(
                                color: myredColor, fontWeight: FontWeight.bold),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Suppression"),
                                      content: Text(
                                          "Voulez-vous vraiment retirer cet Etudiant de la liste ?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Annuler",
                                            style:
                                                TextStyle(color: myblueColor),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            delete(etudiant.id);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Supprimer",
                                            style: TextStyle(color: myredColor),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => DetailEtudiant(
                              //       etudiant: etudiant,
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addSession();
        },
        backgroundColor: myblueColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Enregistrer un nouveau module
  void _saveEtudiant() async {
    if (_formKey.currentState!.validate()) {
      final etudiant = Etudiants(
        numeroEtudiant: int.parse(_numeroEtudiantController.text),
        classe: selectedClasse.toString(),
        nom: _nomController.text,
        prenom: _prenomController.text,
      );
      await dbHelper.insertEtudiant(etudiant);
      _nomController.clear();
      _prenomController.clear();
      _onRefresh(); // Rafraîchir la liste des modules après enregistrement

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Enregistrement effectué avec succès"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void addSession() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter une nouvelle Session"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _prenomController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ ne doit pas être vide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Prenom",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //Nom
                  TextFormField(
                    controller: _nomController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ ne doit pas être vide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Nom",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _numeroEtudiantController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ ne doit pas être vide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Numero Etudiant",
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Choix de La classe

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: "Niveau",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    items: listesClasses.map((String classe) {
                      return DropdownMenuItem(
                        value: classe,
                        child: Text(classe),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedClasse = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveEtudiant(); // Save the session and close the dialog
              },
              child: Text(
                'Enregistrer',
                style: TextStyle(color: myblueColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
