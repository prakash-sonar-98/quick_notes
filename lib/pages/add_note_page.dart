import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            TextField(
              decoration: InputDecoration(
                hintText: 'Title',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
