import 'dart:js_interop' show StringToJSString;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;

import 'employee_form_controller.dart';

class EmployeeFormView extends GetView<EmployeeFormController> {
  const EmployeeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Employee' : 'Add Employee'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!controller.isEditing)
            TextButton.icon(
              onPressed: controller.fillDemo,
              icon: const Icon(Icons.auto_fix_high, color: Colors.white, size: 18),
              label: const Text('Fill Demo', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _section('Personal Info'),
                _field('Full Name *', controller.nameCtrl),
                _field('Job Title *', controller.titleCtrl),
                _field('Department', controller.departmentCtrl),
                const SizedBox(height: 16),
                _section('Contact'),
                _field('Email *', controller.emailCtrl,
                    keyboardType: TextInputType.emailAddress),
                _field('Phone (T)', controller.phoneCtrl,
                    keyboardType: TextInputType.phone),
                _field('Mobile (M)', controller.mobileCtrl,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _section('Company'),
                _field('Address', controller.addressCtrl, maxLines: 2),
                _field('Website', controller.websiteCtrl),
                const SizedBox(height: 16),
                _section('Banner Image'),
                _field('Banner Image URL', controller.bannerImageUrlCtrl),
                Row(
                  children: [
                    Expanded(
                      child: _field('Width (px)', controller.bannerWidthCtrl,
                          keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field('Height (px)', controller.bannerHeightCtrl,
                          keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                if (controller.isEditing)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final html = controller.buildPreviewHtml();
                            _showPreviewDialog(context, html);
                          },
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          label: const Text('Preview', style: TextStyle(fontSize: 15)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFC8102E),
                            side: const BorderSide(color: Color(0xFFC8102E)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: controller.save,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFC8102E),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Save Changes', style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ],
                  )
                else
                  FilledButton(
                    onPressed: controller.save,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFC8102E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Add Employee', style: TextStyle(fontSize: 15)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPreviewDialog(BuildContext context, String html) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760, maxHeight: 560),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Signature Preview',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: _PreviewIframe(html: html),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 4),
        child: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black54,
                letterSpacing: 0.8)),
      );

  Widget _field(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      );
}

class _PreviewIframe extends StatefulWidget {
  final String html;
  const _PreviewIframe({required this.html});

  @override
  State<_PreviewIframe> createState() => _PreviewIframeState();
}

class _PreviewIframeState extends State<_PreviewIframe> {
  late final String _viewId;
  double _height = 300;

  @override
  void initState() {
    super.initState();
    _viewId = 'preview-iframe-${DateTime.now().millisecondsSinceEpoch}';

    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;
      iframe.style.border = 'none';
      iframe.style.width = '100%';
      iframe.style.height = '300px';
      iframe.style.backgroundColor = 'white';
      iframe.setAttribute('scrolling', 'no');

      iframe.onLoad.listen((_) {
        final doc = iframe.contentDocument;
        if (doc == null) return;
        doc.open();
        doc.write((
          '<html><head><style>'
          'body { margin: 0; padding: 8px; background: white; }'
          '</style></head><body>'
          '${widget.html}'
          '</body></html>'
        ).toJS);
        doc.close();

        Future.delayed(const Duration(milliseconds: 100), () {
          final scrollH = iframe.contentDocument?.body?.scrollHeight ?? 0;
          if (scrollH > 0) {
            final newHeight = scrollH.toDouble() + 16;
            iframe.style.height = '${newHeight.toInt()}px';
            if (mounted) setState(() => _height = newHeight);
          }
        });
      });

      iframe.src = 'about:blank';
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: _height, child: HtmlElementView(viewType: _viewId));
  }
}
