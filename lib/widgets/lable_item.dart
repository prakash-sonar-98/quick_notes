import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/notes_provider.dart';
import '../models/lable_model.dart';
import '../utils/app_colors.dart';

class LableItem extends StatefulWidget {
  final LableModel lableModel;
  const LableItem({
    Key? key,
    required this.lableModel,
  }) : super(key: key);

  @override
  State<LableItem> createState() => _LableItemState();
}

class _LableItemState extends State<LableItem> {
  final _lableController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  _updateLable() {
    if (widget.lableModel.lable!.toLowerCase() !=
        _lableController.text.toLowerCase()) {
      final lable = LableModel(
        id: widget.lableModel.id,
        lable: _lableController.text,
      );
      Provider.of<NotesProvider>(context, listen: false).updateLable(lable);
      _focusNode.unfocus();
    } else {
      _focusNode.unfocus();
    }
  }

  _deleteLable() {
    Provider.of<NotesProvider>(context, listen: false)
        .deleteLable(widget.lableModel);
    _focusNode.unfocus();
  }

  @override
  void initState() {
    _lableController.text = widget.lableModel.lable ?? '';

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
    _lableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: _focusNode.hasFocus
          ? GestureDetector(
              onTap: () {
                _deleteLable();
              },
              child: const Icon(
                Icons.delete,
                color: AppColors.black,
              ),
            )
          : const Icon(
              Icons.label_outline,
              color: AppColors.black,
            ),
      title: TextField(
        focusNode: _focusNode,
        controller: _lableController,
        cursorColor: AppColors.grey,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onSubmitted: (val) {
          _updateLable();
        },
      ),
      trailing: GestureDetector(
        onTap: () {
          if (!_focusNode.hasFocus) {
            _focusNode.requestFocus();
          } else {
            _updateLable();
          }
        },
        child: _focusNode.hasFocus
            ? const Icon(
                Icons.check,
                color: AppColors.black,
              )
            : const Icon(
                Icons.edit,
                color: AppColors.black,
              ),
      ),
    );
  }
}
