class User {
  final String id;
  final String email;
  final String fullName;
  final String role; // 'EMPLOYEE' or 'MANAGER'
  final String? department;
  final String? phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.department,
    this.phoneNumber,
  });

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      role: data['role'] ?? 'EMPLOYEE',
      department: data['department'],
      phoneNumber: data['phoneNumber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      if (department != null) 'department': department,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }
}