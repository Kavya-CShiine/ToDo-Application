import 'package:flutter/material.dart';
import 'package:flutter_application_1/notes/note.dart';
import 'package:flutter_application_1/notes/widgets/note_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/notes/pages/note_provider.dart';

class NotesList extends StatelessWidget {
  final List<Note> notes;
  const NotesList({super.key,
  required this.notes});

  @override
  Widget build(BuildContext context) {
    // Fetching notes from NoteProvider
    final notes = context.watch<NoteProvider>().notes;

    // If no notes are available
    if (notes.isEmpty) {
      return const Center(child: Text('No notes found'));
    }

    return ListView.separated(
      itemCount: notes.length,  // Dynamically set the number of notes
      clipBehavior: Clip.none,
      itemBuilder: (context, index) {
        // Passing the current note to the NoteCard widget
        return NoteCard(isInGrid:false,note:notes[index]);
          
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
