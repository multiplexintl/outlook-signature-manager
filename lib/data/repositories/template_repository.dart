import '../../core/models/signature_template.dart';

/// Abstract contract — swap implementation for Firebase/Supabase later.
abstract class TemplateRepository {
  List<SignatureTemplate> getAll();
  SignatureTemplate? getById(String id);
  void save(SignatureTemplate template);
  void delete(String id);
}
