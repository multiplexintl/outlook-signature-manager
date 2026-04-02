import 'package:get/get.dart';

import '../../core/models/signature_template.dart';
import '../repositories/template_repository.dart';

/// In-memory implementation. Replace with Firebase/Supabase provider later.
class LocalTemplateProvider extends GetxService implements TemplateRepository {
  final _templates = <String, SignatureTemplate>{};

  @override
  void onInit() {
    super.onInit();
    // Pre-populate with the default template.
    final def = SignatureTemplate.defaultTemplate();
    _templates[def.id] = def;
  }

  @override
  List<SignatureTemplate> getAll() => _templates.values.toList();

  @override
  SignatureTemplate? getById(String id) => _templates[id];

  @override
  void save(SignatureTemplate template) {
    _templates[template.id] = template;
  }

  @override
  void delete(String id) {
    _templates.remove(id);
  }

  /// Returns the first template available, or the default if none exist.
  SignatureTemplate getActiveTemplate() {
    if (_templates.isEmpty) {
      final def = SignatureTemplate.defaultTemplate();
      _templates[def.id] = def;
      return def;
    }
    return _templates.values.first;
  }
}
