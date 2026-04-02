import '../models/employee.dart';
import '../models/signature_template.dart';

class HtmlTemplateEngine {
  /// Base HTTPS URL where signature images are hosted.
  /// Update this to your actual domain before deploying.
  static const String imageBaseUrl =
      'https://signatures.multiplexinternational.com/images';

  /// Generates the full Outlook-compatible HTML signature for the given employee,
  /// styled according to the provided [template].
  /// - Table-based layout only (no divs, no flexbox)
  /// - Inline styles only
  /// - Transparent background
  /// - Absolute HTTPS image URLs
  static String generate(Employee emp, SignatureTemplate template) {
    final String font = template.fontFamily;
    final String accent = template.accentColor;
    final String contactColor = template.contactTextColor;
    final int cfs = template.contactFontSize;

    final String emailHref = 'mailto:${emp.email}';
    final String websiteHref = emp.websiteUrl.startsWith('http')
        ? emp.websiteUrl
        : 'https://${emp.websiteUrl}';

    // Greeting row
    final String greetingHtml = template.showGreeting
        ? '''  <tr>
    <td style="padding-bottom: 4px; font-family: $font; font-size: 13px; color: #333333; line-height: 18px;">
      ${_esc(template.greetingText)}
    </td>
  </tr>'''
        : '';

    // Name row
    final String nameWeight = template.nameBold ? 'font-weight: bold; ' : '';
    final String nameHtml = '''  <tr>
    <td style="padding-bottom: 2px; font-family: $font; font-size: ${template.nameFontSize}px; ${nameWeight}color: ${template.nameColor}; line-height: ${template.nameFontSize + 6}px;">
      ${_esc(emp.name)}
    </td>
  </tr>''';

    // Title row
    final String titleHtml = '''  <tr>
    <td style="padding-bottom: 4px; font-family: $font; font-size: ${template.titleFontSize}px; color: ${template.titleColor}; line-height: ${template.titleFontSize + 5}px;">
      ${_esc(emp.title)}
    </td>
  </tr>''';

    // Address line
    final String addressLine =
        '<span style="font-family: $font; font-size: ${cfs}px; color: $contactColor;">'
        '<b>A:</b> ${_esc(emp.address)}</span>';

    // Contact line 2: T | M | E | W
    final String sep =
        '&nbsp;<span style="font-family: $font; font-size: ${cfs}px; color: #999999;">|</span>&nbsp;';
    final StringBuffer line2 = StringBuffer();
    if (emp.phone.isNotEmpty) {
      line2.write(
        '<span style="font-family: $font; font-size: ${cfs}px; color: $contactColor;">'
        '<b>T:</b> ${_esc(emp.phone)}</span>',
      );
    }
    if (emp.mobile.isNotEmpty) {
      if (line2.isNotEmpty) line2.write(sep);
      line2.write(
        '<span style="font-family: $font; font-size: ${cfs}px; color: $contactColor;">'
        '<b>M:</b> ${_esc(emp.mobile)}</span>',
      );
    }
    if (line2.isNotEmpty) line2.write(sep);
    line2.write(
      '<span style="font-family: $font; font-size: ${cfs}px; color: $contactColor;">'
      '<b>E:</b> <a href="$emailHref" style="color: $accent; text-decoration: none;">${_esc(emp.email)}</a></span>'
      '$sep'
      '<span style="font-family: $font; font-size: ${cfs}px; color: $contactColor;">'
      '<b>W:</b> <a href="$websiteHref" style="color: $accent; text-decoration: none;">${_esc(emp.websiteUrl)}</a></span>',
    );

    // Banner — use employee override if set, otherwise template defaults
    final int bw =
        emp.bannerWidth > 0 ? emp.bannerWidth : template.bannerWidth;
    final int bh =
        emp.bannerHeight > 0 ? emp.bannerHeight : template.bannerHeight;
    final String bannerHtml = emp.bannerImageUrl.isNotEmpty
        ? '''  <tr>
    <td style="padding-top: 8px; padding-bottom: 4px;">
      <img src="${_esc(emp.bannerImageUrl)}"
           width="$bw" height="$bh"
           alt="Multiplex"
           style="display: block; border: 0;" />
    </td>
  </tr>'''
        : '';

    // Eco line
    final String ecoHtml = template.showEcoLine
        ? '''  <tr>
    <td style="padding-top: 8px; padding-bottom: 6px;">
      <b><span style="color: #006600; font-size: 18pt; font-family: Webdings;">P </span></b><span style="font-family: $font; font-size: 11px; font-style: italic; color: #4a7c3f; line-height: 16px;">Give tomorrow a better chance, think before you print.</span>
    </td>
  </tr>'''
        : '';

    // Disclaimer
    final String disclaimerHtml = template.showDisclaimer
        ? '''  <tr>
    <td style="padding-top: 4px; font-family: $font; font-size: 9px; color: #888888; line-height: 13px;">
      The message (including any attachments) is confidential and may be privileged. If you are not the intended recipient of this message, kindly notify the sender immediately and destroy this message. The unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change. We shall not be liable for the improper or incomplete transmission of the information contained in this communication nor shall we be liable for any delay in its receipt or damage to your system. Multiplex International LLC does neither guarantee that the integrity of this communication has been maintained nor that this communication is free of viruses, interceptions or interference.
    </td>
  </tr>'''
        : '';

    return '''<table cellpadding="0" cellspacing="0" border="0" style="background-color: transparent;">
$greetingHtml
$nameHtml
$titleHtml
  <tr>
    <td style="padding-bottom: 2px; line-height: 16px;">
      $addressLine
    </td>
  </tr>
  <tr>
    <td style="padding-bottom: 8px; line-height: 16px;">
      ${line2.toString()}
    </td>
  </tr>
$bannerHtml
$ecoHtml
$disclaimerHtml
</table>
''';
  }

  /// Generates a preview HTML using dummy employee data.
  /// Used by the Template Builder to show a live preview.
  static String generatePreview(SignatureTemplate template) {
    const Employee dummyEmp = Employee(
      id: 'preview',
      name: 'Jane Smith',
      title: 'Senior Project Manager',
      department: 'Operations',
      phone: '+971 4 429 5900',
      mobile: '+971 52 000 0000',
      email: 'jane.smith@multiplexinternational.com',
      address:
          'Multiplex International LLC, 113-106, 90, Bayan Building, DIP Ring Street, DIP 1, Dubai, UAE.',
      websiteUrl: 'www.multiplexinternational.com',
      bannerImageUrl:
          'https://multiplexmeeting.com/images/mailsigns/email_sign_multiplex.jpg',
      bannerWidth: 658,
      bannerHeight: 162,
    );
    return generate(dummyEmp, template);
  }

  /// Returns the raw HTML template with {{placeholders}} — used in template editor preview.
  static String get templateWithPlaceholders => '''
<table cellpadding="0" cellspacing="0" border="0" style="background-color: transparent;">
  <tr>
    <td style="padding-bottom: 4px; font-family: Arial, Helvetica, sans-serif; font-size: 13px; color: #333333; line-height: 18px;">
      Best Regards
    </td>
  </tr>
  <tr>
    <td style="padding-bottom: 2px; font-family: Arial, Helvetica, sans-serif; font-size: 14px; font-weight: bold; color: #1a1a1a; line-height: 20px;">
      {{name}}
    </td>
  </tr>
  <tr>
    <td style="padding-bottom: 6px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #555555; line-height: 17px;">
      {{title}}
    </td>
  </tr>
  <tr>
    <td style="padding-bottom: 8px; line-height: 16px;">
      <span style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #333333;"><b>A:</b> {{address}}</span>
      &nbsp;&nbsp;<span style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #333333;"><b>T:</b> {{phone}}</span>
      &nbsp;&nbsp;<span style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #333333;"><b>M:</b> {{mobile}}</span>
      &nbsp;&nbsp;<span style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #333333;"><b>E:</b> <a href="mailto:{{email}}" style="color: #C8102E; text-decoration: none;">{{email}}</a></span>
      &nbsp;&nbsp;<span style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #333333;"><b>W:</b> <a href="https://{{websiteUrl}}" style="color: #C8102E; text-decoration: none;">{{websiteUrl}}</a></span>
    </td>
  </tr>
</table>
''';

  static String _esc(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}
