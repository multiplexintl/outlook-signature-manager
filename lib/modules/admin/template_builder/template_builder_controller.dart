import 'package:get/get.dart';

import '../../../core/models/signature_template.dart';
import '../../../core/utils/html_template_engine.dart';
import '../../../data/providers/local_template_provider.dart';

class TemplateBuilderController extends GetxController {
  final LocalTemplateProvider _provider = Get.find();

  late String _editingId;
  late DateTime _createdAt;

  // ── Observable fields ──────────────────────────────────────────────────────
  final templateName = ''.obs;

  final showGreeting = true.obs;
  final greetingText = 'Best Regards'.obs;

  final nameFontSize = 14.0.obs;
  final nameColor = '#1a1a1a'.obs;
  final nameBold = true.obs;

  final titleFontSize = 12.0.obs;
  final titleColor = '#555555'.obs;

  final contactFontSize = 11.0.obs;
  final contactTextColor = '#333333'.obs;
  final accentColor = '#C8102E'.obs;

  final fontFamily = 'Arial, Helvetica, sans-serif'.obs;

  final showEcoLine = true.obs;
  final showDisclaimer = true.obs;

  final bannerWidth = '658'.obs;
  final bannerHeight = '162'.obs;

  // ── Live preview HTML ──────────────────────────────────────────────────────
  final previewHtml = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;
    if (arg is SignatureTemplate) {
      _editingId = arg.id;
      _createdAt = arg.createdAt;
      templateName.value = arg.name;
      showGreeting.value = arg.showGreeting;
      greetingText.value = arg.greetingText;
      nameFontSize.value = arg.nameFontSize.toDouble();
      nameColor.value = arg.nameColor;
      nameBold.value = arg.nameBold;
      titleFontSize.value = arg.titleFontSize.toDouble();
      titleColor.value = arg.titleColor;
      contactFontSize.value = arg.contactFontSize.toDouble();
      contactTextColor.value = arg.contactTextColor;
      accentColor.value = arg.accentColor;
      fontFamily.value = arg.fontFamily;
      showEcoLine.value = arg.showEcoLine;
      showDisclaimer.value = arg.showDisclaimer;
      bannerWidth.value = arg.bannerWidth.toString();
      bannerHeight.value = arg.bannerHeight.toString();
    } else {
      _editingId = DateTime.now().millisecondsSinceEpoch.toString();
      _createdAt = DateTime.now();
    }

    // Regenerate preview whenever any field changes.
    _rebuildPreview();
    ever(templateName, (_) => _rebuildPreview());
    ever(showGreeting, (_) => _rebuildPreview());
    ever(greetingText, (_) => _rebuildPreview());
    ever(nameFontSize, (_) => _rebuildPreview());
    ever(nameColor, (_) => _rebuildPreview());
    ever(nameBold, (_) => _rebuildPreview());
    ever(titleFontSize, (_) => _rebuildPreview());
    ever(titleColor, (_) => _rebuildPreview());
    ever(contactFontSize, (_) => _rebuildPreview());
    ever(contactTextColor, (_) => _rebuildPreview());
    ever(accentColor, (_) => _rebuildPreview());
    ever(fontFamily, (_) => _rebuildPreview());
    ever(showEcoLine, (_) => _rebuildPreview());
    ever(showDisclaimer, (_) => _rebuildPreview());
    ever(bannerWidth, (_) => _rebuildPreview());
    ever(bannerHeight, (_) => _rebuildPreview());
  }

  void _rebuildPreview() {
    previewHtml.value =
        HtmlTemplateEngine.generatePreview(_buildTemplate());
  }

  SignatureTemplate _buildTemplate() {
    return SignatureTemplate(
      id: _editingId,
      name: templateName.value,
      showGreeting: showGreeting.value,
      greetingText: greetingText.value,
      nameFontSize: nameFontSize.value.round(),
      nameColor: nameColor.value,
      nameBold: nameBold.value,
      titleFontSize: titleFontSize.value.round(),
      titleColor: titleColor.value,
      contactFontSize: contactFontSize.value.round(),
      contactTextColor: contactTextColor.value,
      accentColor: accentColor.value,
      fontFamily: fontFamily.value,
      showEcoLine: showEcoLine.value,
      showDisclaimer: showDisclaimer.value,
      bannerWidth: int.tryParse(bannerWidth.value) ?? 658,
      bannerHeight: int.tryParse(bannerHeight.value) ?? 162,
      createdAt: _createdAt,
    );
  }

  void save() {
    if (templateName.value.trim().isEmpty) {
      Get.snackbar(
        'Missing name',
        'Please enter a template name.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    _provider.save(_buildTemplate().copyWith(name: templateName.value.trim()));
    Get.back();
  }
}
