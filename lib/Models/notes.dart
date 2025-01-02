class Notes {
  final int? id; // ID de la note, peut être nul lors de la création
  final double note; // Note de l'étudiant, assurez-vous que c'est un double
  final String typeEvaluation; // Type d'évaluation (ex: contrôle, examen)
  final DateTime dateEvaluation; // Date de l'évaluation
  final int? matiere;
  int? etudiantId; // ID de l'étudiant, peut être nul

  Notes({
    this.id,
    required this.note,
    required this.matiere,
    required this.typeEvaluation,
    required this.dateEvaluation,
    this.etudiantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'matiere': matiere,
      'etudiantId': etudiantId,
      'dateEvaluation':
          dateEvaluation.toIso8601String(), // Format ISO pour la date
      'typeEvaluation': typeEvaluation,
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'], // Assurez-vous que c'est un int ou null
      dateEvaluation:
          DateTime.parse(map['dateEvaluation']), // Conversion de la date
      matiere: map['matiere'],
      note: (map['note'] is int)
          ? (map['note'] as int).toDouble()
          : map['note'], // Assurez-vous que c'est un double
      typeEvaluation: map['typeEvaluation'],
      etudiantId: map['etudiantId'], // Assurez-vous que c'est un int ou null
    );
  }
}
