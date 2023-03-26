
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/view/screen/main_screen/products_screen.dart';

class SortDialog<T extends GetxController> extends StatelessWidget {

  String title;
  bool ascending;
  List<SortItem> sortItems;
  void Function(bool isAscending) onAscending;

  SortDialog({required this.title,required this.sortItems,required this.ascending,required this.onAscending, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(
                thickness: 2,
              ),
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
                      onAscending.call(true);
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
                      onAscending.call(false);
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
                      controller.update();
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
        ),);
  }
}
