class User {
  int _id;
  String _prenom;
  String _nom;
  String _adresse;
  String _telephone;
  String _sexe;
  String _email;
  String _password;

  User({
    required int id,
    required String prenom,
    required String nom,
    required String adresse,
    required String telephone,
    required String sexe,
    required String email,
    required String password,
  })  : _id = id,
        _prenom = prenom,
        _nom = nom,
        _adresse = adresse,
        _telephone = telephone,
        _sexe = sexe,
        _email = email,
        _password = password;

  User.forProfil({
    required int id,
    required String prenom,
    required String nom,
    required String adresse,
    required String telephone,
    required String email,
    required String password,
  })  : _id = id,
        _prenom = prenom,
        _nom = nom,
        _adresse = adresse,
        _telephone = telephone,
        _sexe = '',
        _email = email,
        _password = password;

  User.fromMap(Map<String, dynamic> map)
      : _id = map['id'],
        _prenom = map['prenom'],
        _nom = map['nom'],
        _adresse = map['adresse'],
        _telephone = map['telephone'],
        _sexe = map['sexe'],
        _email = map['email'],
        _password = map['password'];

  int get id => _id;
  String get prenom => _prenom;
  String get nom => _nom;
  String get adresse => _adresse;
  String get sexe => _sexe;
  String get email => _email;
  String get password => _password;
  String get telephone => _telephone;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'prenom': _prenom,
      'nom': _nom,
      'adresse': _adresse,
      'telephone': _telephone,
      'sexe': _sexe,
      'email': _email,
      'password': _password,
    };
  }
}
