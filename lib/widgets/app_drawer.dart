import 'package:flutter/material.dart';

import '../models/drawer_Item_model.dart';
import '../pages/settings_page.dart';
import '../pages/trash_pages.dart';
import '../pages/home_page.dart';
import '../pages/label_page.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';
import '../utils/constants.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final List<DrawerItemModel> _drawerItemList = [
    DrawerItemModel(
      id: 1,
      icon: Icons.lightbulb_outline,
      title: 'Notes',
      page: const HomePage(),
    ),
    DrawerItemModel(
      id: 2,
      icon: Icons.add,
      title: 'Create new label',
      page: const LabelPage(),
    ),
    DrawerItemModel(
      id: 3,
      icon: Icons.delete,
      title: 'Trash',
      page: const TrashPage(),
    ),
    DrawerItemModel(
      id: 4,
      icon: Icons.settings,
      title: 'Settings',
      page: const SettingsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              child: Text(
                Constants.appName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            verticalSpace(20),
            ...List.generate(
              _drawerItemList.length,
              (index) => _drawerItem(
                id: _drawerItemList[index].id,
                icon: _drawerItemList[index].icon,
                title: _drawerItemList[index].title,
                isSelected:
                    _drawerItemList[index].id == Constants.selectedDrawerItem
                        ? true
                        : false,
                page: _drawerItemList[index].page,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required int id,
    required IconData icon,
    required String title,
    required bool isSelected,
    Widget? page,
  }) {
    return InkWell(
      onTap: () {
        Constants.selectedDrawerItem = id;
        Navigator.pop(context);
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          alignment: Alignment.center,
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(20),
                  ),
                )
              : null,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              horizontalSpace(20),
              Icon(
                icon,
                color: isSelected ? AppColors.primaryColor : null,
              ),
              horizontalSpace(10),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryColor : null,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
