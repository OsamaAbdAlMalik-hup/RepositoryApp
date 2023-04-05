import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/data/static/home_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const PageScrollPhysics(),
      itemCount: cardItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1),
      itemBuilder: (context, index) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.toNamed(cardItems[index].screen, arguments: {
              AppSharedKeys.passFilter: PublicFilterType.date,
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                cardItems[index].imagePath,
                color: AppColors.primary70,
                height: 75,
              ),
              Text(
                cardItems[index].title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700, color: AppColors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
