class Professeurs {
  final int? id;
  final String nom;
  final String prenom;

  Professeurs({
    this.id,
    required this.nom,
    required this.prenom,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
    };
  }

  factory Professeurs.fromMap(Map<String, dynamic> map) {
    return Professeurs(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
    );
  }
}
