import 'package:flutter/material.dart';
import 'package:repository/core/constant/app_colors.dart';

class ButtonAuth extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const ButtonAuth({Key? key, required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding:const EdgeInsets.symmetric(vertical: 10),
      onPressed: onPressed,
      color: AppColors.primary90,
      textColor: AppColors.white,
      child: Text(text , style:const TextStyle(fontWeight: FontWeight.bold , fontSize: 25)),
    );
  }
}
