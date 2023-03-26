// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:repository/core/constant/app_colors.dart';

class TextIcon extends StatelessWidget {
  String text;
  IconData icon;
  Color color;
  TextIcon({Key? key, this.text = "text",this.icon = Icons.arrow_circle_up_outlined,this.color=AppColors.gray}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,size: 20,color: AppColors.primary70,),
        const SizedBox(width: 5,),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
