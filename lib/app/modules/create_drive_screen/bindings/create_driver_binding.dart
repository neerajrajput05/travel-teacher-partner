import 'package:driver/app/modules/create_drive_screen/controllers/create_driver_controller.dart';
import 'package:get/get.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      CreateDriverController(),
    );
  }
}
