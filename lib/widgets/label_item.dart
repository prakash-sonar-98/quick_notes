import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/notes_provider.dart';
import '../models/label_model.dart';
import '../utils/app_colors.dart';

class LabelItem extends StatefulWidget {
  const LabelItem({
    Key? key,
  }) : super(key: key);

  @override
  State<LabelItem> createState() => _LabelItemState();
}

class _LabelItemState extends State<LabelItem> {
  final _labelController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  _updateLable(LabelModel labelModel) {
    if (labelModel.label!.toLowerCase() !=
        _labelController.text.toLowerCase()) {
      final label = LabelModel(
        id: labelModel.id,
        label: _labelController.text,
      );
      Provider.of<NotesProvider>(context, listen: false).updateLable(label);
      _focusNode.unfocus();
    } else {
      _focusNode.unfocus();
    }
  }

  _deleteLable(LabelModel label) {
    Provider.of<NotesProvider>(context, listen: false).deleteLable(label);
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus || !_focusNode.hasFocus) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(() {});
    _focusNode.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = Provider.of<LabelModel>(context);
    _labelController.text = labels.label ?? '';
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: _focusNode.hasFocus
          ? GestureDetector(
              onTap: () {
                _focusNode.unfocus();
                _deleteLable(labels);
              },
              child: Icon(
                Icons.delete,
                color: AppColors.black,
              ),
            )
          : Icon(
              Icons.label_outline,
              color: AppColors.black,
            ),
      title: TextField(
        focusNode: _focusNode,
        controller: _labelController,
        cursorColor: AppColors.grey,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onSubmitted: (val) {
          _updateLable(labels);
        },
      ),
      trailing: GestureDetector(
        onTap: () {
          if (!_focusNode.hasFocus) {
            _focusNode.requestFocus();
          } else {
            _updateLable(labels);
          }
        },
        child: _focusNode.hasFocus
            ? Icon(
                Icons.check,
                color: AppColors.black,
              )
            : Icon(
                Icons.edit,
                color: AppColors.black,
              ),
      ),
    );
  }
}
