import 'package:get/get.dart';

import 'employee_form_controller.dart';

class EmployeeFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeFormController>(() => EmployeeFormController());
  }
}
