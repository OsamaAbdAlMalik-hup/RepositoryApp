// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/view/widget/shared/title_section.dart';

class Section extends StatelessWidget {
  String title;
  Widget child;
  void Function()? onArrowPressed;

  Section(
      {Key? key,
      required this.title,
      required this.child,
      this.onArrowPressed,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(5),
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary0,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 2,
              spreadRadius: 0,
              color: AppColors.gray),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: TitleSection(
              onPressed: onArrowPressed,
              title: title,
            ),
          ),
          child
        ],
      ),
    );
  }
}
