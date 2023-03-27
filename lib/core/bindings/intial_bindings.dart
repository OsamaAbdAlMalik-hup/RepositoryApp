
import 'package:get/get.dart';
import 'package:repository/core/service/api_service.dart';

class InitialBindings extends Bindings {

  @override
  dependencies() async {
    Get.put(ApiService());
  }
}
