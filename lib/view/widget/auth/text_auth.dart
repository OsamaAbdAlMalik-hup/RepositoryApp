import 'package:flutter/material.dart';
import 'package:repository/core/constant/app_colors.dart';

class TextAuth extends StatelessWidget {
  final String textone;
  final String texttwo;
  final void Function() onTap;
  const TextAuth(
      {Key? key,
      required this.textone,
      required this.texttwo,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(textone,style: const TextStyle(fontSize: 18),),
        InkWell(
          onTap: onTap,
          child: Text(texttwo,
              style: const TextStyle(
                  color: AppColors.primary90, fontWeight: FontWeight.bold,fontSize: 18)),
        )
      ],
    );
  }
}
