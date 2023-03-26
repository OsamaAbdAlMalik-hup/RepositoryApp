
import  'package:get/get.dart';
import 'package:repository/core/constant/app_translation_keys.dart';

abstract class Validate {
  static const String none='';
  static const String phone='phone';
  static const String email='email';
  static const String num='num';
  static const String negativeNum='negativeNum';
  static const String positiveNum='positiveNum';

  static String? valid(String val, {String type=none,double minLength=1,double maxLength=20,double minVal=0,double maxVal=double.infinity}) {
    if (val.isEmpty) {
      return "Can 'not be empty";
    }
    if(type == phone && !GetUtils.isPhoneNumber(val)) {
      return AppTranslationKeys.phoneNumberNotValid.tr;
    }
    if(type == email && !GetUtils.isEmail(val)) {
      return AppTranslationKeys.phoneNumberNotValid.tr;
    }
    if(type == positiveNum) {
      if (!GetUtils.isNum(val)) {
        return AppTranslationKeys.numberNotValid.tr;
      }
      if (double.parse(val) <= 0) {
        return AppTranslationKeys.numberNotBeNegative.tr;
      }
      if(double.parse(val) < minVal){
        return "${AppTranslationKeys.numberNotBeSmaller.tr} $minVal";
      }
      if(double.parse(val) > maxVal) {
        return "${AppTranslationKeys.numberNotBeGreater.tr} $maxVal";
      }
    }
    if(val.length < minLength) {
      return "${AppTranslationKeys.numberNotBeSmaller.tr} $minLength letters";
    }
    if(val.length > maxLength) {
      return "${AppTranslationKeys.numberNotBeGreater.tr} $maxLength letters";
    }
    return null;
  }
}
