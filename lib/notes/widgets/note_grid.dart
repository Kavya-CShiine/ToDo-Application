import 'package:flutter/material.dart';
import 'package:flutter_application_1/notes/note.dart';
import 'package:flutter_application_1/notes/pages/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/notes/widgets/note_card.dart';  // Import NoteCard

class NotesGrid extends StatelessWidget {
  const NotesGrid({super.key, required List<Note> notes});

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteProvider>().notes;

    if (notes.isEmpty) {
      return const Center(child: Text('No notes found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];  // Get the current note from the list

        // Pass the 'note' to the NoteCard widget
        return NoteCard(
          note: note,  // Passing the note
          isInGrid: true,  // Since it's grid, pass true
        );
      },
    );
  }
}
