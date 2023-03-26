
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:repository/core/constant/app_colors.dart';

class SearchField extends StatelessWidget {
  String title;
  void Function(String)? onChange;
  TextEditingController? controller;
  SearchField({this.title = "stuff",this.onChange,this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.all(0),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide:
                  BorderSide(width: 0, color: AppColors.whiteSecondary)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide:
                  BorderSide(width: 0, color: AppColors.whiteSecondary)),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide:
                  BorderSide(width: 0, color: AppColors.whiteSecondary)),
          filled: true,
          fillColor: AppColors.whiteSecondary200,
          hintText: 'search about $title',
        ),
        onChanged: onChange,
        controller: controller,
      ),
    );
  }
}
