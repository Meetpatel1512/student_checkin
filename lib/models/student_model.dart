class Student {
  final String? id;
  final String name;
  final String email;
  final String studentId;
  final String? pincode;
  final String? district;
  final String? state;
  final String? country;

  Student({
    this.id,
    required this.name,
    required this.email,
    required this.studentId,
    this.pincode,
    this.district,
    this.state,
    this.country,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      studentId: json['studentId'],
      pincode: json['pincode'],
      district: json['district'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'studentId': studentId,
      'pincode': pincode,
      'district': district,
      'state': state,
      'country': country,
    };
  }
}
