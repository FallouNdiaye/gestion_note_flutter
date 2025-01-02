class Matieres {
  final int? id;
  final String nom;
  final int volumeHoraire;
  final String codeMatiere; // Utilisez des conventions de nommage cohérentes
  final int enseignantResponsable;

  Matieres({
    this.id,
    required this.volumeHoraire,
    required this.nom,
    required this.codeMatiere, // Corrigé ici pour correspondre à la convention
    required this.enseignantResponsable,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'volumeHoraire': volumeHoraire,
      'codeMatiere': codeMatiere, // Corrigé ici
      'enseignantResponsable': enseignantResponsable,
    };
  }

  factory Matieres.fromMap(Map<String, dynamic> map) {
    return Matieres(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      codeMatiere: map['codeMatiere'] is String
          ? map['codeMatiere']
          : map['codeMatiere'].toString(), // Assurez-vous que c'est un String
      volumeHoraire: map['volumeHoraire'] is String
          ? int.parse(map['volumeHoraire'])
          : map['volumeHoraire'] as int, // Conversion si nécessaire
      enseignantResponsable: map['enseignantResponsable'] is String
          ? int.parse(map['enseignantResponsable'])
          : map['enseignantResponsable'] as int, // Conversion si nécessaire
    );
  }
}
