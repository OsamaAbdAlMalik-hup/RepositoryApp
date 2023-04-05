
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
  double? expandedHeight;
  List<Widget>? actions;
  List<Widget>? childrenBottomAppbar;
  TabBar tabBar;
  TabBarView tabBarView;
  StatusView statusView;
  void Function()? onTapImage;
  bool isShowDetails;
  NestedScrollViewPage({
    required this.title,
    this.actions,
    required this.imageUrl,
    this.childrenBottomAppbar,
    this.expandedHeight,
    required this.tabBar,
    required this.tabBarView,
    required this.statusView,
    this.isShowDetails=true,
    this.onTapImage,
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
                  expandedHeight: expandedHeight ?? Get.width+2*kToolbarHeight,
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
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: onTapImage,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
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
                                      child: Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.black)),
                                    ),
                              ),
                              AnimatedOpacity(
                                opacity: isShowDetails ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            AppColors.black90,
                                            AppColors.black50,
                                          ])),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if(childrenBottomAppbar!=null)
                                        ...childrenBottomAppbar!
                                    ],
                                  ),
                                ),
                              ),

                            ],
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: tabBarView,
              ),
            ),
          ),
        ));
  }
}
