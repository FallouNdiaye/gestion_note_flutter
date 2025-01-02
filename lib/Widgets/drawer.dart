import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gestion_des_notes/Models/utilisateurs.dart';
import 'package:gestion_des_notes/Screens/gestion_des_notes.dart';
import 'package:gestion_des_notes/Screens/list_etudiants.dart';
import 'package:gestion_des_notes/Services/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gestion_des_notes/Screens/list_des_matieres.dart';
import 'package:gestion_des_notes/Screens/list_des_profs.dart';
import 'package:gestion_des_notes/Themes/colors.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  User? utilisateur;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    utilisateur = await DatabaseHelper.instance.getUser();
    if (utilisateur != null) {
      print("Nom");
      print(utilisateur!.prenom);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [myblueColor, myredColor],
              ),
            ),
            currentAccountPicture: Image.asset(
              "assets/images/profil.png",
              height: 60,
              width: 50,
            ),
            accountName: Text(
              utilisateur == null
                  ? 'Utilisateur'
                  : '${utilisateur!.prenom} ${utilisateur!.nom}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              utilisateur == null ? '' : utilisateur!.email,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  text: 'Matieres',
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListDesMatieres()),
                      (Route<dynamic> route) =>
                          false, // Supprime toutes les pages
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.group_add_rounded,
                  text: 'Liste Etudiants',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GestionDesEtudiants()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  text: 'Liste Professeurs',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GestionDesProfesseurs()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.create_sharp,
                  text: 'Notes',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GestionDesNotes()));
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.call,
                  text: 'Service Client',
                  onTap: () {
                    _AppellerMoi();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.exit_to_app,
                  text: 'Quitter',
                  onTap: () {
                    exit(0);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: myblueColor),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  void _AppellerMoi() async {
    const numeroServiceClient = "221 77 3358337";
    await launch("tel:$numeroServiceClient");
  }
}
