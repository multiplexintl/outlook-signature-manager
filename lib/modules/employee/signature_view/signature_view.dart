import 'dart:js_interop' show StringToJSString;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;

import 'signature_controller.dart';

class SignatureView extends GetView<SignatureController> {
  const SignatureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Obx(() => Text(controller.employee.value?.name ?? 'Signature')),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(
            () => TextButton.icon(
              onPressed: controller.signatureHtml.value.isEmpty
                  ? null
                  : () => _showHtmlDialog(
                      context,
                      controller.signatureHtml.value,
                    ),
              icon: const Icon(Icons.code, color: Colors.white, size: 18),
              label: const Text(
                'View HTML',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final emp = controller.employee.value;
        final html = controller.signatureHtml.value;

        if (emp == null) {
          return const Center(child: Text('Employee not found.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions card
                  Card(
                    color: const Color(0xFFFFF8E1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFFFFE082)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to add this signature to Outlook:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '1. Click "Copy Signature" below.\n'
                            '2. Open Outlook → File → Options → Mail → Signatures.\n'
                            '3. Create a new signature and paste (Ctrl+V / Cmd+V).\n'
                            '4. Set it as your default for New messages and Replies.',
                            style: TextStyle(fontSize: 12, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Signature preview card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Preview',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SignatureIframe(html: html),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Copy button
                  FilledButton.icon(
                    onPressed: controller.copySignature,
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text(
                      'Copy Signature',
                      style: TextStyle(fontSize: 15),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFC8102E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

void _showHtmlDialog(BuildContext context, String html) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text(
                    'HTML Source',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      html,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Color(0xFFD4D4D4),
                        height: 1.5,
                      ),
                    ),
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

/// Renders the signature HTML in an iframe so it is isolated from
/// Flutter's DOM and can be selected/copied as rich text.
class _SignatureIframe extends StatefulWidget {
  final String html;
  const _SignatureIframe({required this.html});

  @override
  State<_SignatureIframe> createState() => _SignatureIframeState();
}

class _SignatureIframeState extends State<_SignatureIframe> {
  late final String _viewId;
  double _height = 300;

  @override
  void initState() {
    super.initState();
    _viewId = 'sig-iframe-${DateTime.now().millisecondsSinceEpoch}';

    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final iframe =
          web.document.createElement('iframe') as web.HTMLIFrameElement;
      iframe.style.border = 'none';
      iframe.style.width = '100%';
      iframe.style.height = '300px';
      iframe.style.backgroundColor = 'transparent';
      iframe.setAttribute('scrolling', 'no');
      iframe.setAttribute('allowtransparency', 'true');

      iframe.onLoad.listen((_) {
        final doc = iframe.contentDocument;
        if (doc == null) return;
        doc.open();
        final content = (
          '<html><head><style>'
          'body { margin: 0; padding: 8px; background: transparent; }'
          '</style></head><body>'
          '${widget.html}'
          '</body></html>'
        ).toJS;
        doc.write(content);
        doc.close();

        // After writing, measure the content height and resize to fit.
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
