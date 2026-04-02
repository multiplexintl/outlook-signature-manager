class SignatureTemplate {
  final String id;
  final String name;

  // Greeting
  final bool showGreeting;
  final String greetingText;

  // Name row
  final int nameFontSize;
  final String nameColor;
  final bool nameBold;

  // Title row
  final int titleFontSize;
  final String titleColor;

  // Contact rows
  final int contactFontSize;
  final String contactTextColor;
  final String accentColor;

  // Font
  final String fontFamily;

  // Eco line
  final bool showEcoLine;

  // Disclaimer
  final bool showDisclaimer;

  // Banner defaults (can be overridden per employee)
  final int bannerWidth;
  final int bannerHeight;

  final DateTime createdAt;

  const SignatureTemplate({
    required this.id,
    required this.name,
    this.showGreeting = true,
    this.greetingText = 'Best Regards',
    this.nameFontSize = 14,
    this.nameColor = '#1a1a1a',
    this.nameBold = true,
    this.titleFontSize = 12,
    this.titleColor = '#555555',
    this.contactFontSize = 11,
    this.contactTextColor = '#333333',
    this.accentColor = '#C8102E',
    this.fontFamily = 'Arial, Helvetica, sans-serif',
    this.showEcoLine = true,
    this.showDisclaimer = true,
    this.bannerWidth = 658,
    this.bannerHeight = 162,
    required this.createdAt,
  });

  factory SignatureTemplate.defaultTemplate() {
    return SignatureTemplate(
      id: 'template_1',
      name: 'Multiplex Standard',
      showGreeting: true,
      greetingText: 'Best Regards',
      nameFontSize: 14,
      nameColor: '#1a1a1a',
      nameBold: true,
      titleFontSize: 12,
      titleColor: '#555555',
      contactFontSize: 11,
      contactTextColor: '#333333',
      accentColor: '#C8102E',
      fontFamily: 'Arial, Helvetica, sans-serif',
      showEcoLine: true,
      showDisclaimer: true,
      bannerWidth: 658,
      bannerHeight: 162,
      createdAt: DateTime(2025, 1, 1),
    );
  }

  SignatureTemplate copyWith({
    String? id,
    String? name,
    bool? showGreeting,
    String? greetingText,
    int? nameFontSize,
    String? nameColor,
    bool? nameBold,
    int? titleFontSize,
    String? titleColor,
    int? contactFontSize,
    String? contactTextColor,
    String? accentColor,
    String? fontFamily,
    bool? showEcoLine,
    bool? showDisclaimer,
    int? bannerWidth,
    int? bannerHeight,
    DateTime? createdAt,
  }) {
    return SignatureTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      showGreeting: showGreeting ?? this.showGreeting,
      greetingText: greetingText ?? this.greetingText,
      nameFontSize: nameFontSize ?? this.nameFontSize,
      nameColor: nameColor ?? this.nameColor,
      nameBold: nameBold ?? this.nameBold,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      titleColor: titleColor ?? this.titleColor,
      contactFontSize: contactFontSize ?? this.contactFontSize,
      contactTextColor: contactTextColor ?? this.contactTextColor,
      accentColor: accentColor ?? this.accentColor,
      fontFamily: fontFamily ?? this.fontFamily,
      showEcoLine: showEcoLine ?? this.showEcoLine,
      showDisclaimer: showDisclaimer ?? this.showDisclaimer,
      bannerWidth: bannerWidth ?? this.bannerWidth,
      bannerHeight: bannerHeight ?? this.bannerHeight,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'showGreeting': showGreeting,
      'greetingText': greetingText,
      'nameFontSize': nameFontSize,
      'nameColor': nameColor,
      'nameBold': nameBold,
      'titleFontSize': titleFontSize,
      'titleColor': titleColor,
      'contactFontSize': contactFontSize,
      'contactTextColor': contactTextColor,
      'accentColor': accentColor,
      'fontFamily': fontFamily,
      'showEcoLine': showEcoLine,
      'showDisclaimer': showDisclaimer,
      'bannerWidth': bannerWidth,
      'bannerHeight': bannerHeight,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SignatureTemplate.fromMap(Map<String, dynamic> map) {
    return SignatureTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      showGreeting: map['showGreeting'] ?? true,
      greetingText: map['greetingText'] ?? 'Best Regards',
      nameFontSize: map['nameFontSize'] ?? 14,
      nameColor: map['nameColor'] ?? '#1a1a1a',
      nameBold: map['nameBold'] ?? true,
      titleFontSize: map['titleFontSize'] ?? 12,
      titleColor: map['titleColor'] ?? '#555555',
      contactFontSize: map['contactFontSize'] ?? 11,
      contactTextColor: map['contactTextColor'] ?? '#333333',
      accentColor: map['accentColor'] ?? '#C8102E',
      fontFamily: map['fontFamily'] ?? 'Arial, Helvetica, sans-serif',
      showEcoLine: map['showEcoLine'] ?? true,
      showDisclaimer: map['showDisclaimer'] ?? true,
      bannerWidth: map['bannerWidth'] ?? 658,
      bannerHeight: map['bannerHeight'] ?? 162,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
