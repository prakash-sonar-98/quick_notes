import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../widgets/label_widget.dart';
import '../models/notes_model.dart';
import '../pages/add_note_page.dart';
import '../provider/notes_provider.dart';
import '../utils/utils.dart';

class NotesItem extends StatelessWidget {
  final bool isFromTrash;
  const NotesItem({
    Key? key,
    required this.isFromTrash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NotesModel>(context);
    return Dismissible(
      key: Key('${notes.id}'),
      onDismissed: (DismissDirection dir) {
        ScaffoldMessenger.of(context).clearSnackBars();
        if (isFromTrash) {
          _deleteNote(context, notes.id!);
        } else {
          _moveToTrash(context, notes);
        }
      },
      direction: DismissDirection.startToEnd,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(
                notes: notes,
                isEdit: isFromTrash ? false : true,
              ),
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
            border: Border.all(
              width: 0.2,
              color: AppColors.black,
            ),
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
              if (notes.label != null) verticalSpace(10),
              if (notes.label != null) LabelWidget(label: notes.label!),
            ],
          ),
        ),
      ),
    );
  }

  _deleteNote(BuildContext context, int id) {
    Provider.of<NotesProvider>(context, listen: false).deleteNote(id, context);
  }

  _moveToTrash(BuildContext context, NotesModel note) {
    note.isActive = 'false';
    Provider.of<NotesProvider>(context, listen: false)
        .moveToTrash(context, note);
  }
}
