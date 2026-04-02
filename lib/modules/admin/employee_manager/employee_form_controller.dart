import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/employee.dart';
import '../../../core/utils/html_template_engine.dart';
import '../../../data/providers/local_employee_provider.dart';
import '../../../data/providers/local_template_provider.dart';

class EmployeeFormController extends GetxController {
  final LocalEmployeeProvider _repo = Get.find();
  final LocalTemplateProvider _templateProvider = Get.find();

  // If an Employee is passed as argument, we're editing; otherwise adding.
  Employee? _editing;
  bool get isEditing => _editing != null;

  final nameCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final departmentCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final bannerImageUrlCtrl = TextEditingController();
  final bannerWidthCtrl = TextEditingController();
  final bannerHeightCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _editing = Get.arguments as Employee?;
    if (_editing != null) {
      nameCtrl.text = _editing!.name;
      titleCtrl.text = _editing!.title;
      departmentCtrl.text = _editing!.department;
      phoneCtrl.text = _editing!.phone;
      mobileCtrl.text = _editing!.mobile;
      emailCtrl.text = _editing!.email;
      addressCtrl.text = _editing!.address;
      websiteCtrl.text = _editing!.websiteUrl;
      bannerImageUrlCtrl.text = _editing!.bannerImageUrl;
      bannerWidthCtrl.text = _editing!.bannerWidth.toString();
      bannerHeightCtrl.text = _editing!.bannerHeight.toString();
    } else {
      addressCtrl.text =
          'Multiplex International LLC, 113-106, 90, Bayan Building, DIP Ring Street, DIP 1, Dubai, UAE.';
      websiteCtrl.text = 'www.multiplexinternational.com';
      bannerImageUrlCtrl.text =
          'https://multiplexmeeting.com/images/mailsigns/email_sign_multiplex.jpg';
      bannerWidthCtrl.text = '658';
      bannerHeightCtrl.text = '162';
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    titleCtrl.dispose();
    departmentCtrl.dispose();
    phoneCtrl.dispose();
    mobileCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    websiteCtrl.dispose();
    bannerImageUrlCtrl.dispose();
    bannerWidthCtrl.dispose();
    bannerHeightCtrl.dispose();
    super.onClose();
  }

  void fillDemo() {
    nameCtrl.text = 'Amjadh CK';
    titleCtrl.text = 'Software Developer';
    departmentCtrl.text = 'IT';
    emailCtrl.text = 'amjadh@multiplex.ae';
    phoneCtrl.text = '+971 4 429 5900';
    mobileCtrl.text = '+971 52 173 9494';
    addressCtrl.text =
        'Multiplex International LLC, 113-106, 90, Bayan Building, DIP Ring Street, DIP 1, Dubai, UAE.';
    websiteCtrl.text = 'www.multiplexinternational.com';
    bannerImageUrlCtrl.text =
        'https://multiplexmeeting.com/images/mailsigns/email_sign_multiplex.jpg';
    bannerWidthCtrl.text = '658';
    bannerHeightCtrl.text = '162';
  }

  /// Builds a temporary Employee from current form state and returns the generated HTML.
  String buildPreviewHtml() {
    final emp = Employee(
      id: _editing?.id ?? 'preview',
      name: nameCtrl.text.trim(),
      title: titleCtrl.text.trim(),
      department: departmentCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      mobile: mobileCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      websiteUrl: websiteCtrl.text.trim(),
      bannerImageUrl: bannerImageUrlCtrl.text.trim(),
      bannerWidth: int.tryParse(bannerWidthCtrl.text.trim()) ?? 658,
      bannerHeight: int.tryParse(bannerHeightCtrl.text.trim()) ?? 162,
    );
    final template = _templateProvider.getActiveTemplate();
    return HtmlTemplateEngine.generate(emp, template);
  }

  void save() {
    if (nameCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Missing fields',
        'Name and Email are required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final id = _editing?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final emp = Employee(
      id: id,
      name: nameCtrl.text.trim(),
      title: titleCtrl.text.trim(),
      department: departmentCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      mobile: mobileCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      websiteUrl: websiteCtrl.text.trim(),
      bannerImageUrl: bannerImageUrlCtrl.text.trim(),
      bannerWidth: int.tryParse(bannerWidthCtrl.text.trim()) ?? 560,
      bannerHeight: int.tryParse(bannerHeightCtrl.text.trim()) ?? 80,
    );

    _repo.save(emp);
    Get.back();
  }
}
