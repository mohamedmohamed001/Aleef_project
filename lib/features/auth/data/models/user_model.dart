class UserModel {
  final String name;
  final String email;
  final String phone;
  final String profilePic;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }
}
