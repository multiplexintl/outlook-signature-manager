import 'package:get/get.dart';

import 'template_builder_controller.dart';

class TemplateBuilderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplateBuilderController>(() => TemplateBuilderController());
  }
}
