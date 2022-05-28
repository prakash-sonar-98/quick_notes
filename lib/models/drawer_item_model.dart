import 'package:flutter/material.dart';

class DrawerItemModel {
  int id;
  IconData icon;
  String title;
  Widget? page;

  DrawerItemModel({
    required this.id,
    required this.icon,
    required this.title,
    this.page,
  });
}
