import 'package:flutter/material.dart';

import '../pages/add_note_page.dart';
import '../models/notes_model.dart';
import '../helper/database_helper.dart';
import '../utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  List<NotesModel> _notesList = [];

  _getNotesData() async {
    _notesList = await dbHelper.getNotes();
    setState(() {});
  }

  @override
  void initState() {
    _getNotesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Notes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              verticalSpace(10),
              Expanded(
                child: ListView.builder(
                  itemCount: _notesList.length,
                  itemBuilder: (context, index) => _itemWidget(
                    _notesList[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNavigator(
            context,
            const AddNotePage(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemWidget(NotesModel notes) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${notes.title}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpace(10),
            Text('${notes.description}'),
          ],
        ),
      ),
    );
  }
}
