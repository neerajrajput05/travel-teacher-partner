import 'package:driver/app/modules/login_owner_screen/controllers/login_owner_controller.dart';
import 'package:get/get.dart';

class LoginOwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      LoginOnwerController(),
    );
  }
}
