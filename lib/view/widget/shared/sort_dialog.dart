
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/view/screen/main_screen/products_screen.dart';

class SortDialog<T extends GetxController> extends StatelessWidget {

  String title;
  bool ascending;
  List<SortItem> sortItems;
  void Function(List<SortItem> sortItems,bool isAscending) onChange;

  SortDialog({this.title='',required this.sortItems,required this.ascending,required this.onChange, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      builder: (controller) => Column(
        children: [
          Row(
            children: [
              FilterChip(
                padding: EdgeInsets.zero,
                selectedColor: AppColors.primary0,
                backgroundColor: AppColors.primary0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                label: const Icon(Icons.text_rotation_angledown),
                onSelected: (value) {
                  ascending = true;
                  onChange.call(sortItems,ascending);
                },
                selected: ascending,
              ),
              const SizedBox(
                width: 10,
              ),
              FilterChip(
                padding: EdgeInsets.zero,
                selectedColor: AppColors.primary0,
                backgroundColor: AppColors.primary0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                label: const Icon(Icons.text_rotation_angleup),
                onSelected: (value) {
                  ascending = false;
                  onChange.call(sortItems,ascending);
                },
                selected: !ascending,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 15,
            children: List.generate(
              sortItems.length,
                  (index) => InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  for (int i = 0; i < sortItems.length; i++) {
                    sortItems[i].isSelected = (i == index);
                  }
                  onChange.call(sortItems,ascending);
                },
                child: SizedBox(
                  width: 75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        sortItems[index].icon,
                        color: sortItems[index].isSelected
                            ? AppColors.primary60
                            : AppColors.black,
                      ),
                      Text(
                        sortItems[index].label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: sortItems[index].isSelected
                                ? AppColors.primary60
                                : AppColors.black),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
