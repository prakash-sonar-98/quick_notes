import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class LabelWidget extends StatelessWidget {
  final String label;
  const LabelWidget({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
