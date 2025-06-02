import 'package:flutter/material.dart';
import 'package:flutter_application_1/signup/notes/note.dart';
import 'package:flutter_application_1/signup/notes/pages/new_or_edit.dart';
import 'package:flutter_application_1/signup/notes/pages/note_provider.dart';

import 'package:provider/provider.dart';

class NotesGrid extends StatelessWidget {
  final List<Note> notes;
  const NotesGrid({super.key,required this.notes});

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
        final note = notes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NewOrEdit(existingNote: note)),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: note.backgroundColor, // fallback color
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  note.content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
