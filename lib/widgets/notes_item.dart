import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notes_model.dart';
import '../pages/add_note_page.dart';
import '../provider/notes_provider.dart';
import '../utils/utils.dart';

class NotesItem extends StatelessWidget {
  const NotesItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NotesModel>(context);
    return Dismissible(
      key: Key('${notes.id}'),
      onDismissed: (DismissDirection dir) {
        _deleteNote(context, notes.id!);
      },
      direction: DismissDirection.startToEnd,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(notes: notes),
            ),
          );
        },
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
              Text('${notes.notes}'),
            ],
          ),
        ),
      ),
    );
  }

  _deleteNote(BuildContext context, int id) {
    Provider.of<NotesProvider>(context, listen: false).deleteNote(id, context);
  }
}
