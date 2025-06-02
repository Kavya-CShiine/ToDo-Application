import 'package:flutter/material.dart';
import 'package:flutter_application_1/notes/note.dart';


enum SortOrder{createdDate,modifiedDate}
class NoteProvider with ChangeNotifier {
  final List<Note> _notes = [];
  List<Note> _filteredNotes = [];

  String _searchQuery = '';
  String _sortBy = 'modified'; // or 'created'
  bool _isDescending = true;

  List<Note> get notes => List.unmodifiable(_filteredNotes);
  bool get isDescending=>_isDescending;
  String get sortBy=>_sortBy;

  NoteProvider() {
    _filteredNotes = _notes;
  }

  void addNote(Note note) {
    _notes.insert(0, note); // add to the top
    _applyFilters();
  }

  void updateNote(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      _applyFilters();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setSortOptions({required String sortBy, required bool isDescending}) {
    _sortBy = sortBy;
    _isDescending = isDescending;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredNotes = _notes.where((note) {
      return note.title.toLowerCase().contains(_searchQuery) ||
             note.content.toLowerCase().contains(_searchQuery);
    }).toList();

    _filteredNotes.sort((a, b) {
      final compare = _sortBy == 'created'
          ? a.createdDate.compareTo(b.createdDate)
          : a.modifiedDate.compareTo(b.modifiedDate);

      return _isDescending ? -compare : compare;
    });

    notifyListeners();
  }
}
