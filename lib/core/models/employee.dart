class Employee {
  final String id;
  final String name;
  final String title;
  final String department;
  final String phone;
  final String mobile;
  final String email;
  final String address;
  final String photoUrl;
  final String websiteUrl;
  final String bannerImageUrl;
  final int bannerWidth;
  final int bannerHeight;

  const Employee({
    required this.id,
    required this.name,
    required this.title,
    this.department = '',
    this.phone = '',
    this.mobile = '',
    required this.email,
    this.address = 'Multiplex International LLC, 113-106, 90, Bayan Building, DIP Ring Street, DIP 1, Dubai, UAE.',
    this.photoUrl = '',
    this.websiteUrl = 'www.multiplexinternational.com',
    this.bannerImageUrl = '',
    this.bannerWidth = 658,
    this.bannerHeight = 162,
  });

  Employee copyWith({
    String? id,
    String? name,
    String? title,
    String? department,
    String? phone,
    String? mobile,
    String? email,
    String? address,
    String? photoUrl,
    String? websiteUrl,
    String? bannerImageUrl,
    int? bannerWidth,
    int? bannerHeight,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      department: department ?? this.department,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      bannerWidth: bannerWidth ?? this.bannerWidth,
      bannerHeight: bannerHeight ?? this.bannerHeight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'department': department,
      'phone': phone,
      'mobile': mobile,
      'email': email,
      'address': address,
      'photoUrl': photoUrl,
      'websiteUrl': websiteUrl,
      'bannerImageUrl': bannerImageUrl,
      'bannerWidth': bannerWidth,
      'bannerHeight': bannerHeight,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      department: map['department'] ?? '',
      phone: map['phone'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? 'Multiplex International LLC, 113-106, 90, Bayan Building, DIP Ring Street, DIP 1, Dubai, UAE.',
      photoUrl: map['photoUrl'] ?? '',
      websiteUrl: map['websiteUrl'] ?? 'www.multiplexinternational.com',
      bannerImageUrl: map['bannerImageUrl'] ?? '',
      bannerWidth: map['bannerWidth'] ?? 658,
      bannerHeight: map['bannerHeight'] ?? 162,
    );
  }
}
