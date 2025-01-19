import 'package:driver/app/modules/reset_owner_password/controllers/reset_owner_pass_controller.dart';
import 'package:get/get.dart';

class ResetOwnerPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ResetOwnerPassController(),
    );
  }
}
