import 'dart:js_interop' show StringToJSString;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;

import 'template_builder_controller.dart';

// ── Font family options ──────────────────────────────────────────────────────
const _fontOptions = [
  ('Arial, Helvetica, sans-serif', 'Arial'),
  ('Verdana, Geneva, sans-serif', 'Verdana'),
  ('Georgia, serif', 'Georgia'),
  ('Tahoma, Geneva, sans-serif', 'Tahoma'),
  ('Times New Roman, Times, serif', 'Times New Roman'),
];

// ── Preset color swatches ────────────────────────────────────────────────────
const _swatches = [
  '#C8102E', // Multiplex red
  '#1a1a1a', // Near black
  '#333333', // Dark grey
  '#555555', // Mid grey
  '#888888', // Light grey
  '#FFFFFF', // White
  '#0057A8', // Corporate blue
  '#006600', // Green
  '#FF6600', // Orange
  '#8B0000', // Dark red
  '#2C2C7A', // Navy
  '#4a7c3f', // Eco green
];

// ── Root view ─────────────────────────────────────────────────────────────────
class TemplateBuilderView extends GetView<TemplateBuilderController> {
  const TemplateBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Obx(() => Text(
              controller.templateName.value.isEmpty
                  ? 'New Template'
                  : controller.templateName.value,
            )),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: controller.save,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save Template'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFC8102E),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left panel: settings form ────────────────────────────────────
          SizedBox(
            width: 380,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
              child: _FormPanel(controller: controller),
            ),
          ),
          // ── Right panel: live preview ────────────────────────────────────
          Expanded(
            child: _PreviewPanel(controller: controller),
          ),
        ],
      ),
    );
  }
}

// ── Form panel ────────────────────────────────────────────────────────────────
class _FormPanel extends StatelessWidget {
  final TemplateBuilderController controller;
  const _FormPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── General ──────────────────────────────────────────────────────
          _Section(
            title: 'General',
            children: [
              const _FieldLabel('Template Name'),
              _ControlledTextField(
                initialValue: controller.templateName.value,
                hint: 'e.g. Multiplex Standard',
                onChanged: (v) => controller.templateName.value = v,
              ),
              const SizedBox(height: 12),
              const _FieldLabel('Font Family'),
              Obx(() => InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    child: DropdownButton<String>(
                      value: controller.fontFamily.value,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      isDense: true,
                      items: _fontOptions
                          .map((o) => DropdownMenuItem(
                                value: o.$1,
                                child: Text(o.$2),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) controller.fontFamily.value = v;
                      },
                    ),
                  )),
              const SizedBox(height: 12),
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.showGreeting.value,
                        onChanged: (v) =>
                            controller.showGreeting.value = v ?? true,
                        activeColor: const Color(0xFFC8102E),
                      ),
                      const Text('Show greeting line'),
                    ],
                  )),
              Obx(() => controller.showGreeting.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('Greeting Text'),
                          _ControlledTextField(
                            initialValue: controller.greetingText.value,
                            hint: 'Best Regards',
                            onChanged: (v) =>
                                controller.greetingText.value = v,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
          const SizedBox(height: 16),

          // ── Name ─────────────────────────────────────────────────────────
          _Section(
            title: 'Name',
            children: [
              const _FieldLabel('Font Size'),
              Obx(() => _SliderRow(
                    value: controller.nameFontSize.value,
                    min: 10,
                    max: 24,
                    onChanged: (v) => controller.nameFontSize.value = v,
                  )),
              const SizedBox(height: 8),
              const _FieldLabel('Color'),
              Obx(() => _ColorPicker(
                    value: controller.nameColor.value,
                    onChanged: (c) => controller.nameColor.value = c,
                  )),
              const SizedBox(height: 8),
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.nameBold.value,
                        onChanged: (v) =>
                            controller.nameBold.value = v ?? true,
                        activeColor: const Color(0xFFC8102E),
                      ),
                      const Text('Bold'),
                    ],
                  )),
            ],
          ),
          const SizedBox(height: 16),

          // ── Title ─────────────────────────────────────────────────────────
          _Section(
            title: 'Title',
            children: [
              const _FieldLabel('Font Size'),
              Obx(() => _SliderRow(
                    value: controller.titleFontSize.value,
                    min: 10,
                    max: 20,
                    onChanged: (v) => controller.titleFontSize.value = v,
                  )),
              const SizedBox(height: 8),
              const _FieldLabel('Color'),
              Obx(() => _ColorPicker(
                    value: controller.titleColor.value,
                    onChanged: (c) => controller.titleColor.value = c,
                  )),
            ],
          ),
          const SizedBox(height: 16),

          // ── Contact ───────────────────────────────────────────────────────
          _Section(
            title: 'Contact',
            children: [
              const _FieldLabel('Font Size'),
              Obx(() => _SliderRow(
                    value: controller.contactFontSize.value,
                    min: 8,
                    max: 14,
                    onChanged: (v) => controller.contactFontSize.value = v,
                  )),
              const SizedBox(height: 8),
              const _FieldLabel('Text Color'),
              Obx(() => _ColorPicker(
                    value: controller.contactTextColor.value,
                    onChanged: (c) => controller.contactTextColor.value = c,
                  )),
              const SizedBox(height: 8),
              const _FieldLabel('Accent Color (links + separator)'),
              Obx(() => _ColorPicker(
                    value: controller.accentColor.value,
                    onChanged: (c) => controller.accentColor.value = c,
                  )),
            ],
          ),
          const SizedBox(height: 16),

          // ── Banner Defaults ───────────────────────────────────────────────
          _Section(
            title: 'Banner Defaults',
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Width (px)'),
                        _ControlledTextField(
                          initialValue: controller.bannerWidth.value,
                          hint: '658',
                          digitsOnly: true,
                          onChanged: (v) => controller.bannerWidth.value = v,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Height (px)'),
                        _ControlledTextField(
                          initialValue: controller.bannerHeight.value,
                          hint: '162',
                          digitsOnly: true,
                          onChanged: (v) => controller.bannerHeight.value = v,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Footer ────────────────────────────────────────────────────────
          _Section(
            title: 'Footer',
            children: [
              Obx(() => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Show eco line',
                        style: TextStyle(fontSize: 14)),
                    value: controller.showEcoLine.value,
                    onChanged: (v) =>
                        controller.showEcoLine.value = v ?? true,
                    activeColor: const Color(0xFFC8102E),
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
              Obx(() => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Show disclaimer',
                        style: TextStyle(fontSize: 14)),
                    value: controller.showDisclaimer.value,
                    onChanged: (v) =>
                        controller.showDisclaimer.value = v ?? true,
                    activeColor: const Color(0xFFC8102E),
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Preview panel ─────────────────────────────────────────────────────────────
class _PreviewPanel extends StatelessWidget {
  final TemplateBuilderController controller;
  const _PreviewPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Preview',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black45,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() => _LivePreviewIframe(
                      html: controller.previewHtml.value,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Live preview iframe ───────────────────────────────────────────────────────
/// Registers the view factory once. When [html] changes, re-writes the
/// iframe content directly via contentDocument — no re-registration needed.
class _LivePreviewIframe extends StatefulWidget {
  final String html;
  const _LivePreviewIframe({required this.html});

  @override
  State<_LivePreviewIframe> createState() => _LivePreviewIframeState();
}

class _LivePreviewIframeState extends State<_LivePreviewIframe> {
  late final String _viewId;
  web.HTMLIFrameElement? _iframe;
  double _height = 400;

  @override
  void initState() {
    super.initState();
    _viewId = 'tpl-preview-${DateTime.now().millisecondsSinceEpoch}';

    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final iframe =
          web.document.createElement('iframe') as web.HTMLIFrameElement;
      iframe.style.border = 'none';
      iframe.style.width = '100%';
      iframe.style.height = '${_height.toInt()}px';
      iframe.style.backgroundColor = 'white';
      iframe.setAttribute('scrolling', 'no');

      _iframe = iframe;

      iframe.onLoad.listen((_) {
        _writeContent(iframe);
      });

      iframe.src = 'about:blank';
      return iframe;
    });
  }

  void _writeContent(web.HTMLIFrameElement iframe) {
    final doc = iframe.contentDocument;
    if (doc == null) return;
    doc.open();
    doc.write(
      (
        '<html><head><style>'
        'body { margin: 0; padding: 8px; background: white; }'
        '</style></head><body>'
        '${widget.html}'
        '</body></html>'
      ).toJS,
    );
    doc.close();

    Future.delayed(const Duration(milliseconds: 150), () {
      final scrollH = iframe.contentDocument?.body?.scrollHeight ?? 0;
      if (scrollH > 0) {
        final newH = scrollH.toDouble() + 24;
        iframe.style.height = '${newH.toInt()}px';
        if (mounted) setState(() => _height = newH);
      }
    });
  }

  @override
  void didUpdateWidget(_LivePreviewIframe oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.html != widget.html) {
      final iframe = _iframe;
      if (iframe != null) {
        _writeContent(iframe);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: double.infinity,
      child: HtmlElementView(viewType: _viewId),
    );
  }
}

// ── Reusable form helpers ─────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }
}

/// A TextField that owns its own TextEditingController.
/// Avoids the deprecated `controller.text = ...` pattern inside Obx.
/// The [initialValue] is only used once at construction time.
class _ControlledTextField extends StatefulWidget {
  final String initialValue;
  final String hint;
  final bool digitsOnly;
  final ValueChanged<String> onChanged;

  const _ControlledTextField({
    required this.initialValue,
    required this.onChanged,
    this.hint = '',
    this.digitsOnly = false,
  });

  @override
  State<_ControlledTextField> createState() => _ControlledTextFieldState();
}

class _ControlledTextFieldState extends State<_ControlledTextField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      decoration: InputDecoration(
        hintText: widget.hint,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      keyboardType:
          widget.digitsOnly ? TextInputType.number : TextInputType.text,
      inputFormatters: widget.digitsOnly
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      onChanged: widget.onChanged,
    );
  }
}

class _SliderRow extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  const _SliderRow({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFC8102E),
              thumbColor: const Color(0xFFC8102E),
              overlayColor: const Color(0x29C8102E),
              inactiveTrackColor: const Color(0xFFE0E0E0),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: (max - min).round(),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            value.round().toString(),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

/// Simple color picker: 12 preset swatches + a hex text field.
class _ColorPicker extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _ColorPicker({required this.value, required this.onChanged});

  @override
  State<_ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync when the swatch selection changes the value externally.
    if (oldWidget.value != widget.value &&
        _textCtrl.text != widget.value) {
      _textCtrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Color _parseHex(String hex) {
    final h = hex.replaceAll('#', '');
    if (h.length == 6) {
      try {
        return Color(int.parse('FF$h', radix: 16));
      } catch (_) {}
    }
    return Colors.grey;
  }

  bool _isLight(String hex) {
    final c = _parseHex(hex);
    final luminance = (0.299 * c.r + 0.587 * c.g + 0.114 * c.b);
    return luminance > 0.6;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _swatches.map((hex) {
            final isSelected =
                widget.value.toLowerCase() == hex.toLowerCase();
            return GestureDetector(
              onTap: () {
                widget.onChanged(hex);
                _textCtrl.text = hex;
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _parseHex(hex),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFC8102E)
                        : Colors.black26,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: _isLight(hex) ? Colors.black87 : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _textCtrl,
          decoration: const InputDecoration(
            hintText: '#RRGGBB',
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[#0-9a-fA-F]')),
            LengthLimitingTextInputFormatter(7),
          ],
          onChanged: (v) {
            if (v.startsWith('#') && v.length == 7) {
              widget.onChanged(v);
            }
          },
        ),
      ],
    );
  }
}
