import 'package:flutter/material.dart';
import 'package:gestion_des_notes/Screens/list_des_matieres.dart';
import 'package:gestion_des_notes/Screens/list_des_profs.dart';
import 'package:gestion_des_notes/Themes/colors.dart';
import 'package:gestion_des_notes/Widgets/drawer_list.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 300,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: myblueColor,
          boxShadow: [
            BoxShadow(
                color: myblueColor.withOpacity(.8),
                blurRadius: 1,
                spreadRadius: 0)
          ]),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: myblueColor,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'UCAO ISAE ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white),
            // MyDrawerListTile(
            //   icon: Icons.home,
            //   text: "ACCUEIL",
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const HomePage(),
            //       ),
            //     );
            //   },
            // ),
            MyDrawerListTile(
              icon: Icons.person_add_alt_1_rounded,
              text: " ETUDIANTS",
              onTap: () {
                // Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListDesMatieres(),
                  ),
                );
              },
            ),
            MyDrawerListTile(
              icon: Icons.person_add_alt_1_rounded,
              text: " PROFESSEURS",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GestionDesProfesseurs(),
                  ),
                );
              },
            ),
            // MyDrawerListTile(
            //   icon: Icons.edit_document,
            //   text: "NOTES",
            //   onTap: () {},
            // ),
            // MyDrawerListTile(
            //   icon: Icons.timeline_rounded,
            //   text: "SESSIONS",
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const GestionSessions(),
            //       ),
            //     );
            //   },
            // ),
            // // MyDrawerListTile(
            // //   icon: Icons.timeline_rounded,
            // //   text: "Modules",
            // //   onTap: () {
            // //     Navigator.pop(context);
            // //     Navigator.push(
            // //       context,
            // //       MaterialPageRoute(
            // //         builder: (context) => const GestionSemestre(),
            // //       ),
            // //     );
            // //   },
            // // ),
            // MyDrawerListTile(
            //   icon: Icons.library_books,
            //   text: "FILIERES",
            //   onTap: () {
            //     // Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ListFilieres(),
            //       ),
            //     );
            //   },
            // ),
            // MyDrawerListTile(
            //   icon: Icons.calendar_month,
            //   text: "EMPLOI DU TEMPS",
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const EmploisDuTemps(),
            //       ),
            //     );
            //   },
            // ),
            MyDrawerListTile(
              icon: Icons.person_remove_rounded,
              text: "ASSIDUITE",
              onTap: () {},
            ),
            const Divider(),
            MyDrawerListTile(
              icon: Icons.payment,
              text: "PAYEMENTS",
              onTap: () {},
            ),
            MyDrawerListTile(
              icon: Icons.groups,
              text: "BDE",
              onTap: () {},
            ),
            const Divider(),
            MyDrawerListTile(
              icon: Icons.settings,
              text: "PARAMETRES",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
