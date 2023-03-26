
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/view/widget/shared/search_field.dart';

// ignore: must_be_immutable
class SampleAppBar extends StatelessWidget {
  String title;
  bool isHasSearch;

  SampleAppBar(this.title, {this.isHasSearch=false,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isHasSearch ? 0.15 * Get.height: 0.07 * Get.height,
      padding: const EdgeInsets.only(left: 10, right: 10,top: 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          IconButton(onPressed: () {
            Get.back();
          }, icon: const Icon(Icons.arrow_back_ios)) ,
          const SizedBox(width: 10,),
          Text(
            title,
            style:const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ],),
        const SizedBox(height: 5,),
        isHasSearch ? SearchField():const SizedBox(),
      ],),
    );
  }
}
