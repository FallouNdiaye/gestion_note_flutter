import 'package:flutter/material.dart';
import 'package:gestion_des_notes/Models/matieres.dart';
import 'package:gestion_des_notes/Models/professeurs.dart';
import 'package:gestion_des_notes/Services/database_helper.dart';
import 'package:gestion_des_notes/Themes/colors.dart';
import 'package:gestion_des_notes/Widgets/drawer.dart';

class ListDesMatieres extends StatefulWidget {
  const ListDesMatieres({super.key});

  @override
  _ListDesMatieresState createState() => _ListDesMatieresState();
}

class _ListDesMatieresState extends State<ListDesMatieres> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _codeMatieresController = TextEditingController();
  final TextEditingController _VolumeHoraireController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  int? selectedProfesseur;
  late Future<List<Matieres>> matieres;

  // Supprimer un Etudiant
  void delete(int? id) async {
    if (id != null) {
      final res = await dbHelper.deleteMatiere(id);
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

  Future<List<Matieres>> _fetchMatieres() async {
    final matiere = await dbHelper.getMatieres();
    return matiere;
  }

  Future<void> _onRefresh() async {
    setState(() {
      matieres = _fetchMatieres();
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
          "Matieres",
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
          Expanded(
            child: FutureBuilder(
              future: dbHelper.getMatieres(), // Votre future ici
              builder: (BuildContext context,
                  AsyncSnapshot<List<Matieres>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("Aucune Matiere trouvée !!!"));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final List<Matieres> items = snapshot.data ?? <Matieres>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final Matieres module =
                          items[index]; // Récupère un étudiant spécifique
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Text(module.nom),
                            titleTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Volume Horaire:"),
                                    Text(
                                      "${module.volumeHoraire}",
                                      style: TextStyle(
                                          color: myredColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Suppression"),
                                      content: Text(
                                          "Voulez-vous vraiment retirer cette Matiere de la liste ?"),
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
                                            delete(module.id);
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
                            onTap: () {},
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
          addMatiere();
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
  void _saveMatiere() async {
    if (_formKey.currentState!.validate()) {
      try {
        final modules = Matieres(
          volumeHoraire: int.tryParse(_VolumeHoraireController.text) ?? 0,
          nom: _nomController.text,
          codeMatiere: _codeMatieresController.text,
          enseignantResponsable:
              selectedProfesseur ?? 0, // Assurez-vous que c'est valide
        );

        await dbHelper.insertMatiere(modules);
        _nomController.clear();
        _codeMatieresController.clear();
        _onRefresh(); // Rafraîchir la liste des modules après enregistrement

        // Afficher un message de succès
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
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Gérer les erreurs d'insertion
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Erreur lors de l'enregistrement: $e"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
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
    }
  }

  void addMatiere() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int? localSelectedProfesseur = selectedProfesseur;

        return AlertDialog(
          title: const Text("Ajouter une nouvelle Matière"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<List<Professeurs>>(
                    future: dbHelper.getProfesseurs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final professeurs = snapshot.data!;
                        return DropdownButtonFormField<int>(
                          value: localSelectedProfesseur,
                          decoration: const InputDecoration(
                            labelText: "Sélectionner un Professeur",
                            border: OutlineInputBorder(),
                          ),
                          items: professeurs.map((prof) {
                            return DropdownMenuItem<int>(
                              value: prof.id,
                              child: Text("${prof.prenom} ${prof.nom}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              localSelectedProfesseur =
                                  value; // Update the state
                            });
                          },
                          validator: (int? value) {
                            if (value == null) {
                              return "Veuillez sélectionner un Professeur";
                            }
                            return null;
                          },
                        );
                      } else {
                        return const Center(
                            child: Text("Aucun Professeur trouvé."));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _codeMatieresController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ ne doit pas être vide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Code Matière",
                      prefixIcon: const Icon(Icons.book),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nomController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ ne doit pas être vide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Nom Matière",
                      prefixIcon: const Icon(Icons.book),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _VolumeHoraireController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ ne doit pas être vide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Volume Horaire",
                      prefixIcon: const Icon(Icons.watch),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (localSelectedProfesseur == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Veuillez sélectionner un Professeur')),
                    );
                  } else {
                    _saveMatiere(); // Sauvegarder la matière
                    Navigator.of(context).pop();
                  }
                }
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
