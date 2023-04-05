
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/storage_services.dart';

class StartMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool isAuthenticated = StorageServices.sharedPreferences.getBool(AppSharedKeys.isAuthenticated)??false;
    bool isHasRepo = StorageServices.sharedPreferences.getBool(AppSharedKeys.isHasRepo)??false;
    HelperLogicFunctions.printNote(isAuthenticated);
    if (!isAuthenticated || !isHasRepo) {
      return const RouteSettings(name: AppPagesRoutes.registration);
    }
    return null;
  }
}
