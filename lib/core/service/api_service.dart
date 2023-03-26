
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/constant/app_translation_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/get_storage_service.dart';
import 'package:repository/core/service/shared_preferences_service.dart';
import 'package:repository/data/models/user.dart';
import 'package:repository/data/models/validation_message.dart';

class ApiService extends GetxService {
  GetStorageService storageService = Get.find();
  SharedPreferencesService sharedService = Get.find();
  static late User currentUser;

  @override
  void onInit() {
    if(storageService.storage.hasData(AppSharedKeys.currentUser)) {
      currentUser = storageService.storage.read<User>(AppSharedKeys.currentUser) ?? User();
    } else{
      currentUser = User();// TODO EXIT FROM APP
    }
    super.onInit();
  }

  Future<Either<StatusView, Map>> post({required String url, required Map<String, dynamic> body, required Map<String, String> headers}) async {
    try {
      if(url!=AppApiRoute.register && url!=AppApiRoute.login){
        headers.addAll({
          'Authorization': 'Bearer ${currentUser.rememberToken}',
        });
        HelperLogicFunctions.printNote(currentUser.rememberToken);
      }
      var response = await http.post(Uri.http(AppApiRoute.server, url), body: body, headers: headers);
      if (response.statusCode == StatusCodeRequest.ok || response.statusCode == StatusCodeRequest.badRequest) {
        return Right(jsonDecode(response.body));
      }
      else if (response.statusCode == StatusCodeRequest.unauthorised) {
        HelperDesignFunctions.showErrorSnackBar(title: AppTranslationKeys.youAreOuterSession.tr,message: AppTranslationKeys.yorMustLoginToApp.tr);
        sharedService.sharedPreferences.setBool(AppSharedKeys.isAuthenticated, false);
        Get.offNamed(AppPagesRoutes.registration);
      }
      else {
        HelperLogicFunctions.printNote('post Server Problem ${response.statusCode} ');
        HelperDesignFunctions.showErrorSnackBar(title: AppTranslationKeys.serverProblem.tr,message: AppTranslationKeys.pleaseTryLater.tr);
      }
    } catch (e) {
      HelperLogicFunctions.printNote('post ApiService unKnownException: $e');
      HelperDesignFunctions.showErrorSnackBar(title: AppTranslationKeys.unknownProblem.tr,message: AppTranslationKeys.pleaseTryLater.tr);
    }
    return const Left(StatusView.serverFailure);
  }
  Future<Either<StatusView, Map>> get({required String url, required Map<String, String> headers}) async {
    try {
      headers.addAll({
        'Authorization': 'Bearer ${currentUser.rememberToken}',
      });
      var response = await http.get(Uri.http(AppApiRoute.server, url), headers: headers);
      if (response.statusCode == StatusCodeRequest.ok || response.statusCode == StatusCodeRequest.badRequest) {
        return Right(jsonDecode(response.body));
      } else if (response.statusCode == StatusCodeRequest.unauthorised) {
        HelperDesignFunctions.showErrorSnackBar(title: AppTranslationKeys.youAreOuterSession.tr,message: AppTranslationKeys.yorMustLoginToApp.tr);
        sharedService.sharedPreferences.setBool(AppSharedKeys.isAuthenticated, false);
        Get.offNamed(AppPagesRoutes.registration);
      } else {
        HelperLogicFunctions.printNote('post Server Problem ${response.statusCode}');
        HelperDesignFunctions.showErrorSnackBar(title: AppTranslationKeys.serverProblem.tr,message: AppTranslationKeys.pleaseTryLater.tr);
      }
    } catch (e) {
      HelperLogicFunctions.printNote('post ApiService unKnownException: $e');
      HelperDesignFunctions.showErrorSnackBar(title: AppTranslationKeys.unknownProblem.tr,message: AppTranslationKeys.pleaseTryLater.tr);
    }
    return const Left(StatusView.serverFailure);
  }
  Future<Either<StatusView, Map>> postMultiPart({required String url, required Map<String, String> body, required Map<String, String> headers, File? file}) async {
    try {
      if(file==null) {
        return post(url: url,headers: {},body: body);
      }
      headers.addAll({
        'Authorization': 'Bearer ${currentUser.rememberToken}',
        'Content-Type': 'multipart/form-data'
      });
      http.MultipartRequest request = http.MultipartRequest("POST", Uri.http(AppApiRoute.server, url));
      request.fields.addAll(body);
      request.files.add(await http.MultipartFile.fromPath('photo', file.path, filename: file.path.split('/').last,),);
      request.headers.addAll(headers);
      http.StreamedResponse res=await request.send();
      http.Response response = await http.Response.fromStream(res);
      if (response.statusCode == StatusCodeRequest.ok || response.statusCode == StatusCodeRequest.badRequest) {
        return Right(jsonDecode(response.body));
      }
      else if (response.statusCode == StatusCodeRequest.unauthorised) {
        HelperDesignFunctions.showErrorSnackBar(title: AppTranslationKeys.youAreOuterSession.tr,message: AppTranslationKeys.yorMustLoginToApp.tr);
        sharedService.sharedPreferences.setBool(AppSharedKeys.isAuthenticated, false);
        Get.offNamed(AppPagesRoutes.registration);
      } else {
        HelperLogicFunctions.printNote('post Server Problem ${response.statusCode}');
        HelperDesignFunctions.showErrorSnackBar(title: AppTranslationKeys.serverProblem.tr,message: AppTranslationKeys.pleaseTryLater.tr);
      }
    } catch (e) {
      HelperLogicFunctions.printNote('post ApiService unKnownException: $e');
      HelperDesignFunctions.showErrorSnackBar(title: AppTranslationKeys.unknownProblem.tr,message: AppTranslationKeys.pleaseTryLater.tr);
    }
    return const Left(StatusView.serverFailure);
  }

  static Future<bool> sendRequest(
      {required Future Function() request,
      Future Function(dynamic response)? onSuccess,
      Future Function(StatusView statusView,ValidationMessage message)? onFailure}) async {
    var response = await request.call();
    if (response is! StatusView) {
      if (response is! ValidationMessage) {
        if (onSuccess != null) {
          await onSuccess.call(response);
          return true;
        }
      } else {
        if (onFailure != null) {
          await onFailure.call(StatusView.none,response);
        }
      }
    } else {
      if (onFailure != null) {
        await onFailure.call(response,ValidationMessage(''));
      }
    }
    return false;
  }

}