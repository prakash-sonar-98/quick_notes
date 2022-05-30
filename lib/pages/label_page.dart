import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/label_model.dart';
import '../widgets/label_item.dart';
import '../provider/notes_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class LabelPage extends StatefulWidget {
  const LabelPage({Key? key}) : super(key: key);

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
  final _lableController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  _getLableData() async {
    Provider.of<NotesProvider>(context, listen: false).getLableData();
  }

  _addNewLable() {
    if (_lableController.text.isNotEmpty) {
      final label = LabelModel(
        label: _lableController.text,
      );
      Provider.of<NotesProvider>(context, listen: false)
          .insertLable(context, label);
      _lableController.clear();
    }
  }

  _resetDrawerSelection() {
    Constants.selectedDrawerItem = 1;
  }

  @override
  void initState() {
    _getLableData();
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
    _resetDrawerSelection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _resetDrawerSelection();
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    horizontalSpace(20),
                    Text(
                      Constants.editLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                verticalSpace(20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _focusNode.requestFocus();
                      },
                      child: const Icon(Icons.add),
                    ),
                    horizontalSpace(10),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _lableController,
                        cursorColor: AppColors.grey,
                        decoration: InputDecoration(
                          hintText: Constants.createNewLabel,
                          border: InputBorder.none,
                        ),
                        onSubmitted: (val) {
                          _addNewLable();
                        },
                      ),
                    ),
                    if (_focusNode.hasFocus)
                      InkWell(
                        onTap: () {
                          _addNewLable();
                        },
                        child: const Icon(Icons.check),
                      ),
                  ],
                ),
                Consumer<NotesProvider>(
                  builder: (context, note, child) => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: note.labelList.length,
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
                      value: note.labelList[index],
                      child: const LabelItem(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
