import 'package:flutter/material.dart';
import 'package:flutter_application_1/signup/notes/colors.dart';
import 'package:flutter_application_1/signup/notes/pages/new_or_edit.dart';
import 'package:flutter_application_1/signup/notes/pages/note_provider.dart';
import 'package:flutter_application_1/signup/notes/pages/notes_grid.dart';
import 'package:flutter_application_1/signup/notes/widgets/note_icon.dart';
import 'package:flutter_application_1/signup/notes/widgets/note_icon_button.dart';
import 'package:flutter_application_1/signup/notes/widgets/note_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Notes(),
    );
  }
}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final List<String> dropdownOptions = ["Date modified", 'Date created'];
  late String dropdownValue;
  bool isGrid = true;

  @override
  void initState() {
    super.initState();
    dropdownValue = dropdownOptions.first;

    // Set initial sort in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NoteProvider>();
      provider.setSortOptions(
        sortBy: 'modified',
        isDescending: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    final isDescending = provider.isDescending;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Awesome Notes 📒 ',
          style: TextStyle(
            color: Color.fromARGB(255, 206, 190, 50),
          ),
        ),
        actions: [
          NoteIconbuttonOutlined(
            icon: Icons.logout,
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton.small(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewOrEdit()),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: primary,
          foregroundColor: white,
          shape: const CircleBorder(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                context.read<NoteProvider>().setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search your notes...',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search),
                fillColor: white,
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                prefixIconConstraints:
                    const BoxConstraints(minHeight: 42, minWidth: 42),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: primary),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  NoteIconButton(
                    icon: isDescending
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    size: 18,
                    onPressed: () {
                      final newDirection = !isDescending;
                      final sortKey = dropdownValue == 'Date created'
                          ? 'created'
                          : 'modified';

                      context.read<NoteProvider>().setSortOptions(
                        sortBy: sortKey,
                        isDescending: newDirection,
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.sort_outlined,
                        size: 18,
                        color: black,
                      ),
                    ),
                    underline: const SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(16),
                    isDense: true,
                    items: dropdownOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Row(
                          children: [
                            Text(option),
                            if (option == dropdownValue) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.check),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                    selectedItemBuilder: (context) =>
                        dropdownOptions.map((option) => Text(option)).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                        context.read<NoteProvider>().setSortOptions(
                          sortBy: newValue == 'Date created'
                              ? 'created'
                              : 'modified',
                          isDescending: provider.isDescending,
                        );
                      }
                    },
                  ),
                  const Spacer(),
                  NoteIconButton(
                    icon: isGrid
                        ? Icons.table_chart_outlined
                        : Icons.menu,
                    size: 20,
                    onPressed: () {
                      setState(() {
                        isGrid = !isGrid;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<NoteProvider>(
                builder: (context, noteProvider, _) {
                  return isGrid
                      ? NotesGrid(notes: noteProvider.notes)
                      : NotesList(notes: noteProvider.notes);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
