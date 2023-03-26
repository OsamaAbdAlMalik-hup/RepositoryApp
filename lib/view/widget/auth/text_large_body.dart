import 'package:flutter/material.dart';
import 'package:repository/core/constant/app_colors.dart';

class TextLargeBody extends StatelessWidget {
  final String text;
  const TextLargeBody({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: AppColors.gray,
            fontWeight: FontWeight.bold,
          )
      ),
    );
  }
}
