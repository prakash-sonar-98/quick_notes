import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/notes_provider.dart';
import '../widgets/app_drawer.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../widgets/notes_item.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({Key? key}) : super(key: key);

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  final GlobalKey<ScaffoldState> _trashScaffoldKey = GlobalKey<ScaffoldState>();

  _getNotesData() async {
    Provider.of<NotesProvider>(context, listen: false)
        .getNotesData(isActive: false);
  }

  _emptyTrash() {
    Provider.of<NotesProvider>(context, listen: false).emptyTrashData();
  }

  _onBackPressed() {
    Constants.selectedDrawerItem = 1;
    Provider.of<NotesProvider>(context, listen: false).trashList = [];
  }

  @override
  void initState() {
    _getNotesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.value(true);
      },
      child: Scaffold(
        key: _trashScaffoldKey,
        drawer: const AppDrawer(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Consumer<NotesProvider>(
              builder: (context, notes, _) {
                return Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            _trashScaffoldKey.currentState?.openDrawer();
                          },
                          child: const Icon(Icons.menu),
                        ),
                        horizontalSpace(20),
                        Text(
                          Constants.trash,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        if (notes.trashList.isNotEmpty) _menuButton(),
                      ],
                    ),
                    verticalSpace(10),
                    notes.trashList.isEmpty
                        ? Center(
                            child: Text(Constants.noNotesInTrash),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: notes.trashList.length,
                              itemBuilder: (context, index) =>
                                  ChangeNotifierProvider.value(
                                value: notes.trashList[index],
                                child: const NotesItem(isFromTrash: true),
                              ),
                            ),
                          ),
                  ],
                );
              },
            ),
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
            _emptyTrash();
          },
          child: Text(Constants.emptyTrash),
        ),
      ],
      child: const Icon(Icons.more_vert),
    );
  }
}
