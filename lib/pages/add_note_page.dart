import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/label_page.dart';
import '../widgets/label_widget.dart';
import '../models/notes_model.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../utils/app_colors.dart';
import '../provider/notes_provider.dart';

class AddNotePage extends StatefulWidget {
  final NotesModel? notes;
  final bool isEdit;
  const AddNotePage({
    Key? key,
    this.notes,
    required this.isEdit,
  }) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  String? _label;

  _getNotesData() {
    if (widget.notes != null) {
      _title.text = widget.notes?.title ?? '';
      _notes.text = widget.notes?.notes ?? '';
      _label = widget.notes?.label;
    }
  }

  _addNote() async {
    final note = NotesModel(
      title: _title.text,
      notes: _notes.text,
      label: _label,
      isActive: 'true',
    );
    Provider.of<NotesProvider>(context, listen: false)
        .insertNote(context, note);
  }

  _updateNote() {
    final note = NotesModel(
      id: widget.notes!.id,
      title: _title.text,
      notes: _notes.text,
      label: _label,
      isActive: 'true',
    );
    Provider.of<NotesProvider>(context, listen: false)
        .updateNote(context, note);
  }

  _restoreNote() {
    final note = NotesModel(
      id: widget.notes!.id,
      title: _title.text,
      notes: _notes.text,
      label: _label,
      isActive: 'true',
    );
    Provider.of<NotesProvider>(context, listen: false).restoreNote(note);
    Navigator.pop(context);
  }

  _deleteNote() {
    Provider.of<NotesProvider>(context, listen: false)
        .deleteNote(widget.notes!.id!, context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _getNotesData();
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  if (widget.isEdit)
                    IconButton(
                      onPressed: () {
                        _showLabelDialog();
                      },
                      icon: const Icon(Icons.label_outline),
                    ),
                  horizontalSpace(10),
                  widget.isEdit
                      ? InkWell(
                          onTap: () {
                            if (_title.text.isEmpty && _notes.text.isEmpty) {
                              showSnackBar(
                                  context, Constants.emptyNoteDiscardedMsg);
                              Navigator.pop(context);
                            } else {
                              if (widget.notes != null) {
                                _updateNote();
                              } else {
                                _addNote();
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.primaryColor,
                            ),
                            child: Text(
                              widget.notes != null
                                  ? Constants.update
                                  : Constants.save,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        )
                      : _menuButton(),
                ],
              ),
              verticalSpace(20),
              if (_label != null) LabelWidget(label: _label ?? ''),
              if (_label != null) verticalSpace(10),
              TextField(
                enabled: widget.isEdit,
                controller: _title,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  hintText: Constants.title,
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                cursorColor: AppColors.grey,
              ),
              Expanded(
                child: TextField(
                  enabled: widget.isEdit,
                  autocorrect: true,
                  autofocus: true,
                  controller: _notes,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: Constants.note,
                    border: InputBorder.none,
                  ),
                  cursorColor: AppColors.grey,
                  maxLines: 99,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // show lables popup
  _showLabelDialog() {
    final lables = Provider.of<NotesProvider>(context, listen: false).labelList;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Constants.labels),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LabelPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        content: ListView.builder(
          shrinkWrap: true,
          itemCount: lables.length,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.label_outline),
            title: Text('${lables[index].label}'),
            onTap: () {
              setState(() {
                _label = lables[index].label;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _menuButton() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            _deleteNote();
          },
          child: Text(Constants.deleteForever),
        ),
        PopupMenuItem(
          onTap: () {
            _restoreNote();
          },
          child: Text(Constants.restore),
        ),
      ],
      child: const Icon(Icons.more_vert),
    );
  }
}
