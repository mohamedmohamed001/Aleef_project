class PetModel {
  final String? id;
  final String? name;
  final String? type;
  final String? gender;
  final String? profilePic;

  PetModel({
    this.id,
    this.name,
    this.type,
    this.gender,
    this.profilePic,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      gender: json['gender'],
      profilePic: json['profilePic'],
    );
  }
}