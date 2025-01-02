import 'package:flutter/material.dart';

class MyDrawerListTile extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MyDrawerListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  _MyDrawerListTileState createState() => _MyDrawerListTileState();
}

class _MyDrawerListTileState extends State<MyDrawerListTile> {
  Color _tileColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _tileColor = Colors.white.withOpacity(0.3); // Couleur au survol
          });
        },
        onExit: (_) {
          setState(() {
            _tileColor = Colors.transparent; // Couleur par défaut
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _tileColor,
          ),
          child: ListTile(
            leading: Icon(
              widget.icon,
              color: Colors.white,
            ),
            title: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
