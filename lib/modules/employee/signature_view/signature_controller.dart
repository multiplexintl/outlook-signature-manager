import 'package:get/get.dart';

import '../../../core/models/employee.dart';
import '../../../core/utils/html_template_engine.dart';
import '../../../core/utils/clipboard_helper.dart';
import '../../../data/providers/local_employee_provider.dart';
import '../../../data/providers/local_template_provider.dart';

class SignatureController extends GetxController {
  final LocalEmployeeProvider _repo = Get.find();
  final LocalTemplateProvider _templateProvider = Get.find();

  final employee = Rxn<Employee>();
  final signatureHtml = ''.obs;
  final copySuccess = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Accept Employee object passed directly, or look up by route param id.
    final arg = Get.arguments;
    if (arg is Employee) {
      employee.value = arg;
    } else {
      final id = Get.parameters['id'] ?? '';
      employee.value = _repo.getById(id);
    }

    if (employee.value != null) {
      final template = _templateProvider.getActiveTemplate();
      signatureHtml.value = HtmlTemplateEngine.generate(employee.value!, template);
    }
  }

  Future<void> copySignature() async {
    if (signatureHtml.value.isEmpty) return;
    final ok = await ClipboardHelper.copyHtml(signatureHtml.value);
    copySuccess.value = ok;
    if (ok) {
      Get.snackbar(
        'Copied!',
        'Paste your signature into Outlook → File → Options → Mail → Signatures.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } else {
      Get.snackbar('Failed', 'Could not copy to clipboard.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
