// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/view/widget/shared/title_section.dart';

class SectionTabs extends StatelessWidget {
  String title;
  List<String> tabsTitles;
  List<Widget> tabs;
  TabController controller;
  double tabViewHeight;
  void Function(int)? onTab;
  void Function()? onArrowPressed;
  bool isScrollable;
  // TODO FLEXIBLE HEIGHT
  SectionTabs(
      {Key? key,
      required this.title,
      required this.tabsTitles,
      required this.tabs,
      required this.controller,
      this.tabViewHeight=0,
      this.isScrollable=false,
      this.onArrowPressed,
      this.onTab,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    tabViewHeight = tabViewHeight == 0 ? Get.width : tabViewHeight;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: TitleSection(
              onPressed: onArrowPressed,
              title: title,
            ),
          ),
          TabBar(
              isScrollable: isScrollable,
              onTap: onTab,
              controller: controller,
              tabs: List.generate(
                  tabsTitles.length,
                  (index) => Tab(
                        child: Text(tabsTitles[index],
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: AppColors.primary60),
                        ),
                      ))),
          const Divider(height: 0,thickness: 1),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: tabViewHeight,
            child: TabBarView(
                controller: controller,
                children: tabs
            ),
          )
        ],
      ),
    );
  }
}
