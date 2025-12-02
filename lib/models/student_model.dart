class Student {
  final String? id;
  final String name;
  final String email;
  final String studentId;

  Student({
    this.id,
    required this.name,
    required this.email,
    required this.studentId,
  });

  // 1. FROM JSON (Receiving data from Backend -> Flutter)
  // This factory constructor takes the JSON map and turns it into a Student object
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      studentId: json['studentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'studentId': studentId};
  }
}
