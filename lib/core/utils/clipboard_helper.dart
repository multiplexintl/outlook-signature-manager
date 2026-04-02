import 'dart:js_interop';

import 'package:web/web.dart' as web;

// Calls the global JS function we inject below.
@JS('copyHtmlToClipboard')
external JSPromise<JSBoolean> _copyHtmlToClipboard(JSString html);

class ClipboardHelper {
  static bool _scriptInjected = false;

  /// Copies [html] to the clipboard as rich text (text/html MIME type).
  /// Uses the modern Clipboard API so Outlook receives real HTML on paste.
  static Future<bool> copyHtml(String html) async {
    _ensureScript();
    try {
      final result = await _copyHtmlToClipboard(html.toJS).toDart;
      return result.toDart;
    } catch (_) {
      return false;
    }
  }

  /// Injects a small JS helper into the page once.
  static void _ensureScript() {
    if (_scriptInjected) return;
    _scriptInjected = true;

    const js = '''
window.copyHtmlToClipboard = async function(html) {
  try {
    const blob = new Blob([html], { type: 'text/html' });
    const item = new ClipboardItem({ 'text/html': blob });
    await navigator.clipboard.write([item]);
    return true;
  } catch (e) {
    // Fallback: execCommand via off-screen div
    try {
      const div = document.createElement('div');
      div.innerHTML = html;
      div.style.position = 'fixed';
      div.style.left = '-9999px';
      div.style.top = '0';
      div.style.opacity = '0';
      document.body.appendChild(div);
      const sel = window.getSelection();
      sel.removeAllRanges();
      const range = document.createRange();
      range.selectNodeContents(div);
      sel.addRange(range);
      const ok = document.execCommand('copy');
      sel.removeAllRanges();
      document.body.removeChild(div);
      return ok;
    } catch (e2) {
      return false;
    }
  }
};
''';

    final script =
        web.document.createElement('script') as web.HTMLScriptElement;
    script.textContent = js;
    web.document.head!.appendChild(script);
  }
}
