import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/add_note_page.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../utils/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../provider/notes_provider.dart';
import '../widgets/notes_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _homeScaffoldKey = GlobalKey<ScaffoldState>();
  _getNotesData() async {
    Provider.of<NotesProvider>(context, listen: false).getLableData();
    Provider.of<NotesProvider>(context, listen: false)
        .getNotesData(isActive: true);
  }

  @override
  void initState() {
    _getNotesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _homeScaffoldKey,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<NotesProvider>(
            builder: (context, notes, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerView(),
                  verticalSpace(10),
                  notes.searchNotesList.isEmpty
                      ? Center(
                          child: Text(Constants.noNotesAvailable),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: notes.searchNotesList.length,
                            itemBuilder: (context, index) =>
                                ChangeNotifierProvider.value(
                              value: notes.searchNotesList[index],
                              child: const NotesItem(isFromTrash: false),
                            ),
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

// header search bar view
  Widget _headerView() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              _homeScaffoldKey.currentState!.openDrawer();
            },
            child: const Icon(Icons.menu),
          ),
          horizontalSpace(10),
          Expanded(
            child: TextField(
              cursorColor: AppColors.grey,
              decoration: InputDecoration(
                hintText: Constants.searchText,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                Provider.of<NotesProvider>(context, listen: false)
                    .searchNotes(value);
              },
            ),
          ),
          const CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.primaryColor,
            child: Text(
              'P',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
