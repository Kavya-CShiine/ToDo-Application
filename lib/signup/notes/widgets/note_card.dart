import 'package:flutter/material.dart';
import 'package:flutter_application_1/signup/notes/colors.dart';
import 'package:flutter_application_1/signup/notes/note.dart';
import 'package:flutter_application_1/signup/notes/pages/new_or_edit.dart';
import 'package:flutter_application_1/signup/notes/pages/note_provider.dart';
 // Import the NewOrEdit screen
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  final bool isInGrid;
  final Note note;

  const NoteCard({
    super.key,
    required this.isInGrid,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to NewOrEdit page, passing the selected note for editing
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewOrEdit(existingNote: note), // Pass the note to NewOrEdit
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: primary),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.5),
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title of the note
            Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),

            // Tags displayed in a row
            if (note.tags != null && note.tags is List<String>)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    note.tags.length,
                    (index) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color.fromARGB(249, 207, 200, 200),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      margin: EdgeInsets.only(right: 4),
                      child: Text(
                        note.tags[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 122, 119, 105),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 4),

            // Note content: adjust based on grid or list view
            isInGrid
                ? Expanded(
                    child: Text(
                      note.content,
                      style: TextStyle(color: Color.fromARGB(255, 68, 70, 71)),
                    ),
                  )
                : Text(
                    note.content,
                    maxLines: 3,
                    style: TextStyle(color: Color.fromARGB(255, 68, 70, 71)),
                  ),

            // Date and delete icon
            Row(
              children: [
                Text(
                  note.date,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    // Delete the note when the delete icon is tapped
                    Provider.of<NoteProvider>(context, listen: false)
                        .deleteNote(note.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
