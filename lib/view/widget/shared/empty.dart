
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';

class Empty extends StatelessWidget {
  String imagePath;
  String text;
  double height;
  double fontSize;
  Color color;
  Empty({this.imagePath=AppAssets.noInvoices,this.text="Empty",this.height=150,this.fontSize=18,this.color=AppColors.primary70,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height+80,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                child: Image.asset(
                  imagePath,
                  height: height,
                ),
              ),
              Text(text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: color,
                    fontSize: fontSize
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
