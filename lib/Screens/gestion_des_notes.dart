import 'package:flutter/material.dart';
import 'package:gestion_des_notes/Models/etudiants.dart';
import 'package:gestion_des_notes/Models/matieres.dart';
import 'package:gestion_des_notes/Models/professeurs.dart';
import 'package:intl/intl.dart';

import 'package:gestion_des_notes/Models/notes.dart';
import 'package:gestion_des_notes/Services/database_helper.dart';
import 'package:gestion_des_notes/Themes/colors.dart';
import 'package:gestion_des_notes/Widgets/drawer.dart';

class GestionDesNotes extends StatefulWidget {
  const GestionDesNotes({super.key});

  @override
  _GestionDesNotesState createState() => _GestionDesNotesState();
}

class _GestionDesNotesState extends State<GestionDesNotes> {
  final TextEditingController _noteController = TextEditingController();

  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Notes>> notes;
  String? selectedEvaluation;
  int? selectedMatiere;
  int? selectedEtudiant;

  final List<String> typeEvaluation = ['Devoir', 'Examen', 'Controle Continu'];

  // Supprimer un Etudiant
  void delete(int? id) async {
    if (id != null) {
      final res = await dbHelper.deleteNote(id);
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

  Future<List<Notes>> _fetchNotes() async {
    final note = await dbHelper.getNotes();
    return note;
  }

  Future<void> _onRefresh() async {
    setState(() {
      notes = _fetchNotes();
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
          "Notes",
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
              future: Future.wait([
                dbHelper.getNotes(),
                dbHelper.getEtudiants(),
                dbHelper.getMatieres(),
                dbHelper.getProfesseurs(),
              ]),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final List<Notes> notes = snapshot.data![0];
                  final List<Etudiants> etudiants = snapshot.data![1];
                  final List<Matieres> matieres = snapshot.data![2];
                  final List<Professeurs> professeurs = snapshot.data![3];

                  final Map<int?, Etudiants> etudiantMap = {
                    for (var etudiant in etudiants) etudiant.id: etudiant,
                  };

                  final Map<int?, Matieres> matiereMap = {
                    for (var matiere in matieres) matiere.id: matiere,
                  };

                  final Map<int?, Professeurs> professeurMap = {
                    for (var professeur in professeurs)
                      professeur.id: professeur,
                  };

                  if (notes.isEmpty) {
                    return const Center(child: Text("Aucune note trouvée !!!"));
                  }

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final Notes note = notes[index];

                      // Retrieve student name
                      String etudiantNom = note.etudiantId != null &&
                              etudiantMap.containsKey(note.etudiantId)
                          ? "${etudiantMap[note.etudiantId]!.prenom} ${etudiantMap[note.etudiantId]!.nom}"
                          : "Inconnu";

                      // Retrieve subject and professor
                      String matiereNom = note.matiere != null &&
                              matiereMap.containsKey(note.matiere)
                          ? matiereMap[note.matiere]!.nom
                          : "Inconnue";

                      String professeurNom = note.matiere != null &&
                              matiereMap.containsKey(note.matiere)
                          ? professeurMap[matiereMap[note.matiere]!
                                      .enseignantResponsable]
                                  ?.nom ??
                              "Inconnu"
                          : "Inconnu";

                      // Format the date
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(note.dateEvaluation);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // First line: Student name, Evaluation type, Date, and Delete button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      etudiantNom,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    Text(
                                      "${note.typeEvaluation} du $formattedDate",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    // Delete button
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Suppression"),
                                              content: Text(
                                                "Voulez-vous vraiment retirer cette note de la liste ?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Annuler",
                                                      style: TextStyle(
                                                          color: Colors.blue)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    delete(note
                                                        .id); // Call the delete method
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Supprimer",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.grey[300], thickness: 1),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _editNote(note.id!);
                                      },
                                      child: Text(
                                        note.note.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: note.note >= 9.5
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Matière: $matiereNom",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87),
                                        ),
                                        // Text(
                                        //   "Professeur: $professeurNom",
                                        //   style: TextStyle(
                                        //       fontSize: 12,
                                        //       color: Colors.black54),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNote();
        },
        backgroundColor: myblueColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

// Enregistrer une nouvelle note
  void _saveNote(int? etudiantId, int? matiere) async {
    if (_formKey.currentState!.validate()) {
      print("Validation réussie");
      double inputValue = double.parse(_noteController.text.trim());

      try {
        final notes = Notes(
          dateEvaluation: DateTime.now(),
          etudiantId: etudiantId, // Utilisez le paramètre passé
          matiere: matiere, // Utilisez le paramètre passé
          typeEvaluation: selectedEvaluation ?? '', // Valeur par défaut
          note: inputValue,
        );

        await dbHelper.insertNote(notes); // Insérer la note
        _noteController.clear();
        _onRefresh(); // Rafraîchir la liste des notes

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
                  child: const Text('OK', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Erreur lors de l'insertion de la note: $e");
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
                  child: const Text('OK', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      }
    } else {
      print("Validation échouée");
    }
  }

  void addNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Initialisation des variables d'état
        int? localSelectedMatiere = selectedMatiere;
        int? localSelectedEtudiant = selectedEtudiant;

        return AlertDialog(
          title: const Text("Ajouter une nouvelle Note"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Les Matieres
                  FutureBuilder<List<Matieres>>(
                    future: dbHelper.getMatieres(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final matieres = snapshot.data!;
                        return DropdownButtonFormField<int>(
                          value: localSelectedMatiere,
                          decoration: const InputDecoration(
                            labelText: "Sélectionner une Matiere",
                            border: OutlineInputBorder(),
                          ),
                          items: matieres.map((matiere) {
                            return DropdownMenuItem<int>(
                              value: matiere.id,
                              child: Text("${matiere.nom}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              localSelectedMatiere =
                                  value; // Mettez à jour l'état
                            });
                          },
                          validator: (int? value) {
                            if (value == null) {
                              return "Veuillez sélectionner une Matiere";
                            }
                            return null;
                          },
                        );
                      } else {
                        return const Center(
                            child: Text("Aucune Matiere trouvée."));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Choix du Type d'évaluation
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Type Evaluation",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: typeEvaluation.map((String classe) {
                      return DropdownMenuItem(
                        value: classe,
                        child: Text(classe),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedEvaluation = value;
                      });
                    },
                    validator: (String? value) {
                      if (value == null) {
                        return "Veuillez sélectionner un Etudiant";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Sélection de l'Étudiant
                  FutureBuilder<List<Etudiants>>(
                    future: dbHelper.getEtudiants(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final etudiants = snapshot.data!;
                        return DropdownButtonFormField<int>(
                          value: localSelectedEtudiant,
                          decoration: const InputDecoration(
                            labelText: "Sélectionner un Etudiant",
                            border: OutlineInputBorder(),
                          ),
                          items: etudiants.map((etudiant) {
                            return DropdownMenuItem<int>(
                              value: etudiant.id,
                              child: Text("${etudiant.prenom} ${etudiant.nom}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              localSelectedEtudiant =
                                  value; // Mettez à jour l'état
                            });
                          },
                          validator: (int? value) {
                            if (value == null) {
                              return "Veuillez sélectionner un Etudiant";
                            }
                            return null;
                          },
                        );
                      } else {
                        return const Center(
                            child: Text("Aucun Étudiant trouvé."));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Champ de la Note
                  TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _noteController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ ne doit pas être vide";
                      }
                      try {
                        double.parse(value);
                      } catch (e) {
                        return "Veuillez entrer un nombre valide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Note",
                      prefixIcon: const Icon(Icons.book),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Vérifie si les sélections ne sont pas nulles
                  if (localSelectedEtudiant != null &&
                      localSelectedMatiere != null) {
                    _saveNote(localSelectedEtudiant, localSelectedMatiere);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Veuillez sélectionner une matière et un étudiant.")),
                    );
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

  //Modifier la note
  void _editNote(int noteId) async {
    final existingNote = await dbHelper.getNoteById(noteId);
    if (existingNote == null) return;

    int? localSelectedMatiere = existingNote.matiere;
    int? localSelectedEtudiant = existingNote.etudiantId;
    _noteController.text = existingNote.note.toString();
    selectedEvaluation = existingNote.typeEvaluation;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier la Note"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<List<Matieres>>(
                    future: dbHelper.getMatieres(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final matieres = snapshot.data!;
                        return DropdownButtonFormField<int>(
                          value: localSelectedMatiere,
                          decoration: const InputDecoration(
                            labelText: "Sélectionner une Matiere",
                            border: OutlineInputBorder(),
                          ),
                          items: matieres.map((matiere) {
                            return DropdownMenuItem<int>(
                              value: matiere.id,
                              child: Text("${matiere.nom}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              localSelectedMatiere = value;
                            });
                          },
                          validator: (int? value) {
                            if (value == null) {
                              return "Veuillez sélectionner une Matiere";
                            }
                            return null;
                          },
                        );
                      } else {
                        return const Center(
                            child: Text("Aucune Matiere trouvée."));
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Type Evaluation",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedEvaluation,
                    items: typeEvaluation.map((String classe) {
                      return DropdownMenuItem(
                        value: classe,
                        child: Text(classe),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedEvaluation = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  FutureBuilder<List<Etudiants>>(
                    future: dbHelper.getEtudiants(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final etudiants = snapshot.data!;
                        return DropdownButtonFormField<int>(
                          value: localSelectedEtudiant,
                          decoration: const InputDecoration(
                            labelText: "Sélectionner un Etudiant",
                            border: OutlineInputBorder(),
                          ),
                          items: etudiants.map((etudiant) {
                            return DropdownMenuItem<int>(
                              value: etudiant.id,
                              child: Text("${etudiant.prenom} ${etudiant.nom}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              localSelectedEtudiant = value;
                            });
                          },
                          validator: (int? value) {
                            if (value == null) {
                              return "Veuillez sélectionner un Etudiant";
                            }
                            return null;
                          },
                        );
                      } else {
                        return const Center(
                            child: Text("Aucun Étudiant trouvé."));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Champ de la Note
                  TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _noteController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ ne doit pas être vide";
                      }
                      try {
                        double.parse(value);
                      } catch (e) {
                        return "Veuillez entrer un nombre valide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Note",
                      prefixIcon: const Icon(Icons.book),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (localSelectedEtudiant != null &&
                      localSelectedMatiere != null) {
                    _updateNote(
                        noteId, localSelectedEtudiant, localSelectedMatiere);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Veuillez sélectionner une matière et un étudiant.")),
                    );
                  }
                }
              },
              child: Text(
                'Modifier',
                style: TextStyle(color: myblueColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateNote(int noteId, int? etudiantId, int? matiere) async {
    try {
      double inputValue = double.parse(_noteController.text.trim());
      final updatedNote = Notes(
        id: noteId, // Assuming Notes has an id property
        dateEvaluation: DateTime.now(),
        etudiantId: etudiantId,
        matiere: matiere,
        typeEvaluation: selectedEvaluation ?? '',
        note: inputValue,
      );

      await dbHelper.updateNote(updatedNote);
      _onRefresh();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Modification effectuée avec succès"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Erreur lors de la modification de la note: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Erreur lors de la modification: $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }
  }
}
