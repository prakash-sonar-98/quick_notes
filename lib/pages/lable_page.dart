import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lable_model.dart';
import '../widgets/lable_item.dart';
import '../provider/notes_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class LablePage extends StatefulWidget {
  const LablePage({Key? key}) : super(key: key);

  @override
  State<LablePage> createState() => _LablePageState();
}

class _LablePageState extends State<LablePage> {
  final _lableController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  _getLableData() async {
    Provider.of<NotesProvider>(context, listen: false).getLableData();
  }

  _addNewLable() {
    if (_lableController.text.isNotEmpty) {
      final lable = LableModel(
        lable: _lableController.text,
      );
      Provider.of<NotesProvider>(context, listen: false).insertLable(lable);
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
                      Constants.editLable,
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
                          hintText: Constants.createNewLable,
                          border: InputBorder.none,
                        ),
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
                    itemCount: note.lableList.length,
                    itemBuilder: (context, index) =>
                        LableItem(lableModel: note.lableList[index]),
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
