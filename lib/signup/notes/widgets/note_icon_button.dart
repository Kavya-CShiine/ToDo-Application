import 'package:flutter/material.dart';
import 'package:flutter_application_1/signup/notes/colors.dart';

class NoteIconButton extends StatelessWidget {
  const NoteIconButton({
  required this.icon,
  required this.size,
  required this.onPressed,
  super.key});

final IconData icon;
final double? size;
final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
                    onPressed: onPressed,
                    
                    icon: Icon(icon),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints: BoxConstraints(),
                    style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    iconSize: size,
                    color: black,
                  );
  }
}