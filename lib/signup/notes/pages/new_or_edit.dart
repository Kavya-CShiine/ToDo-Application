import 'package:flutter/material.dart';

import 'package:flutter_application_1/signup/notes/note.dart';
import 'package:flutter_application_1/signup/notes/pages/note_provider.dart';
import 'package:flutter_application_1/signup/notes/widgets/note_icon.dart';
import 'package:flutter_application_1/signup/notes/widgets/note_icon_button.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_quill/quill_delta.dart' as quill show Delta;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewOrEdit extends StatefulWidget {
  final Note? existingNote;

  const NewOrEdit({super.key, this.existingNote});

  @override
  State<NewOrEdit> createState() => _NewOrEditState();
}

class _NewOrEditState extends State<NewOrEdit> {
  late final quill.QuillController quillController;
  final TextEditingController titleController = TextEditingController();
  Color noteBgColor = Colors.white;
  final List<String> tags = [];
  DateTime? _lastUsedDate;
  late Note currentNote;

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      currentNote = widget.existingNote!;
      titleController.text = currentNote.title;
      quillController = quill.QuillController(
        document: quill.Document.fromDelta(
          quill.Delta()..insert(currentNote.content),
        ),
        selection: const TextSelection.collapsed(offset: 0),
      );
      noteBgColor = currentNote.backgroundColor;
      _lastUsedDate = currentNote.modifiedDate;
    } else {
      currentNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '',
        content: '',
        createdDate: DateTime.now(),
        modifiedDate: DateTime.now(),
        backgroundColor: Colors.white,
      );
      quillController = quill.QuillController.basic();
    }

    quillController.document.changes.listen((event) {
      _updateModifiedDate();
      _updateLastUsedDate();
    });
  }

  void _updateModifiedDate() {
    currentNote.modifiedDate = DateTime.now();
  }

  void _updateLastUsedDate() {
    setState(() {
      _lastUsedDate = DateTime.now();
    });
  }

  void _saveNote() {
    currentNote.title = titleController.text;
    currentNote.content = quillController.document.toPlainText();
    currentNote.backgroundColor = noteBgColor;

    final notesProvider = Provider.of<NoteProvider>(context, listen: false);
    final isNew = !notesProvider.notes.any((n) => n?.id == currentNote.id);

    if (isNew) {
      notesProvider.addNote(currentNote);
    } else {
      notesProvider.updateNote(currentNote);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Note Saved"), duration: Duration(seconds: 1)),
    );

    Navigator.pop(context);
  }

  void _clearNote() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Clear Note?"),
        content: const Text("This will remove all text and formatting."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              titleController.clear();
              quillController.clear();
              setState(() {
                tags.clear();
                noteBgColor = Colors.white;
              });
              Navigator.pop(context);
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  int _getWordCount() {
    return quillController.document.toPlainText().trim().split(RegExp(r'\s+')).length;
  }

  String _formatted(DateTime time) => DateFormat('dd MMM yyyy, hh:mm a').format(time);

  @override
  void dispose() {
    quillController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NoteIconbuttonOutlined(
          icon: Icons.chevron_left,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.existingNote != null ? 'Edit Note' : 'New Note',
          style: const TextStyle(
            color: Color.fromARGB(255, 209, 191, 35),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          NoteIconbuttonOutlined(icon: Icons.edit, onPressed: () {}),
          NoteIconbuttonOutlined(icon: Icons.check, onPressed: _saveNote),
          IconButton(icon: const Icon(Icons.clear), onPressed: _clearNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(hintText: 'Enter Title', border: InputBorder.none),
            ),
            if (_lastUsedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  _formatted(_lastUsedDate!),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            Row(
              children: [
                const Text('Tags: ', style: TextStyle(color: Colors.grey)),
                NoteIconButton(icon: Icons.add, size: 18, onPressed: () {
                  final TextEditingController tagController = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Enter Tag"),
                      content: TextField(
                        controller: tagController,
                        decoration: const InputDecoration(hintText: 'Enter tag name'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (tagController.text.isNotEmpty) {
                                tags.add(tagController.text);
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            Wrap(
              spacing: 8,
              children: tags.map((tag) => Chip(
                label: Text(tag),
                onDeleted: () => setState(() => tags.remove(tag)),
              )).toList(),
            ),
            const Divider(),
            Wrap(
              spacing: 8,
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold, color: quillController.getSelectionStyle().attributes.containsKey(quill.Attribute.bold.key) ? Colors.blue : Colors.black),
                  onPressed: () => _toggleStyle(quill.Attribute.bold),
                ),
                IconButton(
                  icon: Icon(Icons.format_italic, color: quillController.getSelectionStyle().attributes.containsKey(quill.Attribute.italic.key) ? Colors.blue : Colors.black),
                  onPressed: () => _toggleStyle(quill.Attribute.italic),
                ),
                IconButton(
                  icon: Icon(Icons.format_underline, color: quillController.getSelectionStyle().attributes.containsKey(quill.Attribute.underline.key) ? Colors.blue : Colors.black),
                  onPressed: () => _toggleStyle(quill.Attribute.underline),
                ),
                IconButton(icon: const Icon(Icons.format_list_bulleted), onPressed: () => _toggleStyle(quill.Attribute.ul)),
                IconButton(icon: const Icon(Icons.format_list_numbered), onPressed: () => _toggleStyle(quill.Attribute.ol)),
                IconButton(icon: const Icon(Icons.color_lens_outlined), onPressed: _pickTextColor),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: quill.QuillEditor.basic(controller: quillController),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text("Word count: ${_getWordCount()}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleStyle(quill.Attribute attr) {
    final isApplied = quillController.getSelectionStyle().attributes.containsKey(attr.key);
    if (isApplied) {
      quillController.formatSelection(quill.Attribute.clone(attr, null));
    } else {
      quillController.formatSelection(attr);
    }
  }

  void _pickTextColor() {
    Color pickerColor = Colors.black;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick Text Color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) {
              pickerColor = color;
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Apply"),
            onPressed: () {
              Navigator.of(context).pop();
              final hexColor = '#${pickerColor.value.toRadixString(16).substring(2)}';
              quillController.formatSelection(quill.Attribute.fromKeyValue('color', hexColor));
            },
          ),
        ],
      ),
    );
  }
}


