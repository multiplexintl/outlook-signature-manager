import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/signature_template.dart';
import '../../../data/providers/local_template_provider.dart';
import '../../../app/routes/app_pages.dart';

/// A dialog-style screen listing all saved templates.
/// Accessible from the Admin Dashboard AppBar.
class TemplatesListView extends StatelessWidget {
  const TemplatesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Get.find<LocalTemplateProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Signature Templates'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () => Get.toNamed(Routes.templateBuilder),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Template'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFC8102E),
              ),
            ),
          ),
        ],
      ),
      body: _TemplateListBody(provider: provider),
    );
  }
}

class _TemplateListBody extends StatefulWidget {
  final LocalTemplateProvider provider;
  const _TemplateListBody({required this.provider});

  @override
  State<_TemplateListBody> createState() => _TemplateListBodyState();
}

class _TemplateListBodyState extends State<_TemplateListBody> {
  List<SignatureTemplate> _templates = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _templates = widget.provider.getAll();
    });
  }

  void _edit(SignatureTemplate t) async {
    await Get.toNamed(Routes.templateBuilder, arguments: t);
    _refresh();
  }

  void _delete(BuildContext context, SignatureTemplate t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text('Delete "${t.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Get.back();
              widget.provider.delete(t.id);
              _refresh();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFC8102E),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_templates.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.style_outlined, size: 64, color: Colors.black26),
            SizedBox(height: 16),
            Text(
              'No templates yet.',
              style: TextStyle(color: Colors.black45, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Click "New Template" to get started.',
              style: TextStyle(color: Colors.black38),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _templates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) {
        final t = _templates[i];
        return Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: _parseAccent(t.accentColor),
              child: const Icon(Icons.style, color: Colors.white, size: 20),
            ),
            title: Text(
              t.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Font: ${_fontLabel(t.fontFamily)}  •  Accent: ${t.accentColor}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit_outlined,
                      color: Colors.black54),
                  onPressed: () => _edit(t),
                ),
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.black38),
                  onPressed: () => _delete(ctx, t),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _parseAccent(String hex) {
    final h = hex.replaceAll('#', '');
    if (h.length == 6) {
      try {
        return Color(int.parse('FF$h', radix: 16));
      } catch (_) {}
    }
    return const Color(0xFFC8102E);
  }

  String _fontLabel(String fontFamily) {
    if (fontFamily.startsWith('Arial')) return 'Arial';
    if (fontFamily.startsWith('Verdana')) return 'Verdana';
    if (fontFamily.startsWith('Georgia')) return 'Georgia';
    if (fontFamily.startsWith('Tahoma')) return 'Tahoma';
    if (fontFamily.startsWith('Times')) return 'Times New Roman';
    return fontFamily;
  }
}
