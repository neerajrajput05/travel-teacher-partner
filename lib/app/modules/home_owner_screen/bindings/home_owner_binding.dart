import 'package:driver/app/modules/home_owner_screen/controllers/home_owner_controller.dart';
import 'package:get/get.dart';

class HomeOwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeOwnerController>(
      () => HomeOwnerController(),
    );
  }
}
