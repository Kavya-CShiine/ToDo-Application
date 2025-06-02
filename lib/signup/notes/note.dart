import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class Note {
  String id;  
  String title;
  String content;
  DateTime createdDate;
  DateTime modifiedDate;
  Color backgroundColor;

  var tags;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdDate,
    required this.modifiedDate,
    required this.backgroundColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
      'backgroundColor': backgroundColor.value.toString(),
    };
  }

  // Create a Note object from a Map (useful when loading from storage)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdDate: DateTime.parse(map['createdDate']),
      modifiedDate: DateTime.parse(map['modifiedDate']),
      backgroundColor: Color(int.parse(map['backgroundColor'])),
    );
  }

  // Getter for formatted date
  String get date => DateFormat('MMM dd, yyyy').format(modifiedDate);
}
