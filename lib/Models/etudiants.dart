class Etudiants {
  final int? id;
  final String nom;
  final String prenom;
  final int numeroEtudiant;

  final String classe;

  Etudiants(
      {this.id,
      required this.nom,
      required this.prenom,
      required this.classe,
      required this.numeroEtudiant});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'classe': classe,
      'numeroEtudiant': numeroEtudiant,
    };
  }

  factory Etudiants.fromMap(Map<String, dynamic> map) {
    return Etudiants(
        id: map['id'],
        classe: map['classe'],
        nom: map['nom'],
        prenom: map['prenom'],
        numeroEtudiant: map['numeroEtudiant']);
  }
}
