
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class StorageServices extends GetxService {

  static late SharedPreferences sharedPreferences;
  static late GetStorage getStorage;

  Future<StorageServices> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await GetStorage.init();
    getStorage = GetStorage();
    return this;
  }

  readDateFromStorage<T>(String key){
    if(getStorage.hasData(key)) {
      var data=getStorage.read(key);
      if(data is T){
        return data;
      } else {

      }
    }
  }

}


