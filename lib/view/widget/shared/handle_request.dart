
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';

class HandleRequest extends StatelessWidget {
  final StatusView statusView;
  final Widget child;

  const HandleRequest(
      {Key? key, required this.statusView, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return statusView == StatusView.loading
        ? const Center(
            child: SpinKitSpinningLines(
              size: 200,
              lineWidth: 5,
              color: AppColors.primary70,
            ))
        : statusView == StatusView.serverFailure
            ? Center(
                child: Lottie.asset(AppAssets.server, width: 250, height: 250))
            : statusView == StatusView.noContent
                ? Center(
                    child: Lottie.asset(AppAssets.noContent, width: 250, height: 250,),)
                : child;
  }
}
