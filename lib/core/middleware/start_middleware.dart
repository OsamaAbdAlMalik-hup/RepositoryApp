
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/service/shared_preferences_service.dart';

class StartMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  SharedPreferencesService sharedServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    bool isAuthenticated=sharedServices.sharedPreferences.getBool(AppSharedKeys.isAuthenticated)??false;
    bool isHasRepo=sharedServices.sharedPreferences.getBool(AppSharedKeys.isHasRepo)??false;
    if (isAuthenticated && isHasRepo) {
      return const RouteSettings(name: AppPagesRoutes.mainScreen);
    }
    return null;
  }
}
