
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:repository/core/constant/app_colors.dart';

class SearchAppbar extends StatelessWidget {

  String? hintText;
  TextEditingController? controller;
  void Function(String value)? onChanged;
  void Function()? onSearchIconPressed;
  Future<void> Function()? onBackIconPressed;

  SearchAppbar(
      {this.hintText,
      this.controller,
      this.onChanged,
      this.onBackIconPressed,
      this.onSearchIconPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: TextField(
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1,color: AppColors.primary0)
              ),
              focusedBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1,color: AppColors.primary0)
              ),
              prefixIcon: IconButton(
                  onPressed: onBackIconPressed,
                  icon: const Icon(Icons.arrow_back)),
              suffixIcon: IconButton(
                  onPressed: onSearchIconPressed,
                  icon: const Icon(Icons.search)),
              hintText: hintText,
              fillColor: AppColors.primary10,
              hintMaxLines: 1
          ),
          autofocus: true,
          onChanged: onChanged,
          controller: controller,
        ),
      ),
    );
  }
}
