
// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/view/widget/shared/handle_request.dart';

class NestedScrollViewPage extends StatelessWidget {

  String title;
  String imageUrl;
  double expandedHeight;
  List<Widget>? actions;
  List<Widget>? childrenBottomAppbar;
  TabBar tabBar;
  TabBarView tabBarView;
  StatusView statusView;
  NestedScrollViewPage({
    required this.title,
    this.actions,
    required this.imageUrl,
    this.childrenBottomAppbar,
    required this.expandedHeight,
    required this.tabBar,
    required this.tabBarView,
    required this.statusView,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: HandleRequest(
          statusView: statusView,
          child: SafeArea(
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: expandedHeight,
                  pinned: true,
                  floating: true,
                  primary: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    stretchModes: const [
                      StretchMode.zoomBackground,
                    ],
                    background: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: kToolbarHeight,),
                        CachedNetworkImage(
                          height: Get.width,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: imageUrl,
                          placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                          const CircleAvatar(
                            radius: 36,
                            backgroundColor: AppColors.primary0,
                            child: Text('',
                                //${controller.category.name[0]}${controller.category.name[1]}
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black)),
                          ),
                        ),
                        if(childrenBottomAppbar!=null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primary0,
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  color: AppColors.gray)
                            ],
                          ),
                          child: Column(
                            children: childrenBottomAppbar!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Expanded(
                      child: Container(
                        color: AppColors.primary0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(onPressed: (){
                                  Get.back();
                                }, icon: const Icon(Icons.arrow_back)),
                                Text(
                                  title,
                                  style: GoogleFonts.oswald(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                    color: AppColors.primary70,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if(actions!=null) ...actions!
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                  bottom: tabBar,
                ),
              ],
              body: Container(
                margin: const EdgeInsets.only(top: 50),
                child: tabBarView,
              ),
            ),
          ),
        ));
  }
}
