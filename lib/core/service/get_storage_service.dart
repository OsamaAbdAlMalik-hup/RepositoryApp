
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class GetStorageService extends GetxService {
  
  late GetStorage storage;
  Future<GetStorageService> init() async {
    await GetStorage.init();
    storage = GetStorage();
    return this;
  }
}


