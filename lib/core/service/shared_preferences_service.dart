
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SharedPreferencesService extends GetxService {
  
  late SharedPreferences sharedPreferences;
  Future<SharedPreferencesService> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}


