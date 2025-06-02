import 'package:flutter/material.dart';
import 'package:flutter_application_1/notes/colors.dart';

class NoteIconbuttonOutlined extends StatelessWidget {
  const NoteIconbuttonOutlined({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: black),
        ),
        foregroundColor: black,
      ),
    );
  }
}
