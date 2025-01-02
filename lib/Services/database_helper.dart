import 'dart:async';
import 'package:gestion_des_notes/Models/etudiants.dart';
import 'package:gestion_des_notes/Models/matieres.dart';
import 'package:gestion_des_notes/Models/notes.dart';
import 'package:gestion_des_notes/Models/professeurs.dart';
import 'package:gestion_des_notes/Models/utilisateurs.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gestion_des_notes_des_etudiants.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE utilisateurs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      prenom TEXT NOT NULL,
      nom TEXT NOT NULL,
      adresse TEXT NOT NULL,
      telephone TEXT NOT NULL,
      sexe TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      date_naissance TEXT NOT NULL,
      image_path TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE etudiants(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        prenom TEXT,
        numeroEtudiant INTEGER,
        classe TEXT
        
      )
    ''');
    await db.execute('''
CREATE TABLE professeurs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    prenom TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE matieres (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    codeMatiere TEXT NOT NULL,
    volumeHoraire INTEGER NOT NULL,
    enseignantResponsable INTEGER,
    FOREIGN KEY (enseignantResponsable) REFERENCES professeurs(id)
)
''');
    await db.execute('''
CREATE TABLE notes(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    note REAL,
    typeEvaluation TEXT,
    dateEvaluation TEXT,
    etudiantId INTEGER,
    matiere INTEGER,
    FOREIGN KEY (matiere) REFERENCES matieres(id)  -- Ajoutez la contrainte de clé étrangère
    FOREIGN KEY (etudiantId) REFERENCES etudiants(id)  -- Ajoutez la contrainte de clé étrangère
)
''');
  }

  Future<int> insertEtudiant(Etudiants etudiant) async {
    Database db = await instance.database;
    try {
      return await db.insert(
        'etudiants',
        etudiant.toMap(),
      );
    } catch (e) {
      print("Erreur lors de l'insertion de l'étudiant: $e");
      return -1; // Retourner une valeur indiquant une erreur
    }
  }

  Future<User?> checkUserLogin(String email, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'utilisateurs',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<int> insertUser(User user) async {
    final db = await instance.database;
    try {
      return await db.insert('utilisateurs', user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("Erreur lors de l'insertion de l'utilisateur: $e");
      return -1; // Retourner une valeur indiquant une erreur
    }
  }

  Future<int> deleteEtudiant(int id) async {
    final db = await instance.database;
    try {
      return await db.delete(
        'etudiants',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Erreur lors de la suppression de l'étudiant: $e");
      return -1; // Retourner une valeur indiquant une erreur
    }
  }

  Future<List<Etudiants>> getEtudiants() async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> maps = await db.query('etudiants');
      return List.generate(maps.length, (i) {
        return Etudiants.fromMap(maps[i]);
      });
    } catch (e) {
      print("Erreur lors de la récupération des étudiants: $e");
      return []; // Retourner une liste vide en cas d'erreur
    }
  }

  Future<Etudiants> getEtudiantById(int id) async {
    final db =
        await instance.database; // Obtenez votre instance de base de données
    final List<Map<String, dynamic>> maps = await db.query(
      'etudiants',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Etudiants.fromMap(maps
          .first); // Assurez-vous que vous avez une méthode fromMap dans votre classe Matiere
    } else {
      throw Exception('Etudiant non trouvé');
    }
  }

  Future<int> updateUserImagePath(int userId, String path) async {
    final db = await instance.database;
    try {
      return await db.update(
        'utilisateurs',
        {'image_path': path},
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print("Erreur lors de la mise à jour de l'image utilisateur: $e");
      return -1; // Retourner une valeur indiquant une erreur
    }
  }

  Future<String?> getUserImagePath(int userId) async {
    final db = await instance.database;
    try {
      final result = await db.query(
        'utilisateurs',
        columns: ['image_path'],
        where: 'id = ?',
        whereArgs: [userId],
      );
      if (result.isNotEmpty) {
        return result.first['image_path'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print(
          "Erreur lors de la récupération du chemin de l'image utilisateur: $e");
      return null; // Retourner null en cas d'erreur
    }
  }

  Future<User?> getUser() async {
    final db = await instance.database;
    try {
      final result = await db.query(
        'utilisateurs',
        limit: 1,
      );

      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      } else {
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur: $e");
      return null; // Retourner null en cas d'erreur
    }
  }

  //__________________________________________Matieres_________________________________________________
  Future<int> insertMatiere(Matieres matiere) async {
    Database db = await instance.database;
    try {
      return await db.insert(
        'matieres',
        matiere.toMap(),
      );
    } catch (e) {
      print("Erreur lors de l'insertion de l'étudiant: $e");
      return -1; // Retourner une valeur indiquant une erreur
    }
  }

  Future<List<Matieres>> getMatieres() async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> maps = await db.query('matieres');
      print("Données récupérées: $maps"); // Ajoutez cette ligne
      return List.generate(maps.length, (i) {
        return Matieres.fromMap(maps[i]);
      });
    } catch (e) {
      print("Erreur lors de la récupération des matieres: $e");
      return []; // Retourner une liste vide en cas d'erreur
    }
  }

  Future<Matieres> getMatiereById(int id) async {
    final db =
        await instance.database; // Obtenez votre instance de base de données
    final List<Map<String, dynamic>> maps = await db.query(
      'matieres',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Matieres.fromMap(maps
          .first); // Assurez-vous que vous avez une méthode fromMap dans votre classe Matiere
    } else {
      throw Exception('Matière non trouvée');
    }
  }
  //delete

  Future<int> deleteMatiere(int id) async {
    final db = await instance.database;
    try {
      return await db.delete(
        'matieres',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Erreur lors de la suppression de la matiere: $e");
      return -1; // Retourner une valeur indiquant une erreur
    }
  }

  //_______________________________________________________Professeurs________________________________
  Future<int> insertProfesseurs(Professeurs prof) async {
    Database db = await instance.database;
    try {
      return await db.insert(
        'professeurs',
        prof.toMap(),
      );
    } catch (e) {
      print("Erreur lors de l'insertion du professeur: $e");
      return -1; // Retourner une valeur indiquant une erreur
    }
  }

  //Get

  Future<List<Professeurs>> getProfesseurs() async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> maps = await db.query('professeurs');
      return List.generate(maps.length, (i) {
        return Professeurs.fromMap(maps[i]);
      });
    } catch (e) {
      print("Erreur lors de la récupération des professeurs: $e");
      return []; // Retourner une liste vide en cas d'erreur
    }
  }

  //delete

  Future<int> deleteProfesseur(int id) async {
    final db = await instance.database;
    try {
      return await db.delete(
        'professeurs',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Erreur lors de la suppression de l'étudiant: $e");
      return -1; // Retourner une valeur indiquant une erreur
    }
  }

  //___________________________________Notes_____________________________________
  Future<void> insertNote(Notes note) async {
    final db =
        await database; // Assurez-vous d'avoir une référence à votre base de données

    await db.insert('notes', {
      'note': note.note, // Assurez-vous d'accéder à la propriété 'note'
      'typeEvaluation': note.typeEvaluation,
      'dateEvaluation': note.dateEvaluation.toIso8601String(),
      'etudiantId': note.etudiantId,
      'matiere': note.matiere,
    });
  }

  //Get
  Future<List<Notes>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('notes'); // Adjust table name as necessary
    return List.generate(maps.length, (i) {
      return Notes.fromMap(maps[i]); // Ensure this includes the matiere field
    });
  }

  //delete

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    try {
      return await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Erreur lors de la suppression de l'étudiant: $e");
      return -1; // Retourner une valeur indiquant une erreur
    }
  }

  Future<Notes?> getNoteById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Notes.fromMap(maps.first);
    }
    return null;
  }

//Mettre a jour
  Future<void> updateNote(Notes note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
