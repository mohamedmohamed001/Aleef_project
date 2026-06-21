
class ReviewModel {
  final String id;
  final String doctorId;
  final String user_name;
  final String user_pic;
  final int rate;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.doctorId,
    required this.rate,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.user_name,
    required this.user_pic,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      doctorId: json['doctor'] ?? '',
      rate: (json['rate'] ?? 0) as int,
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      user_name: json['user_name'] ?? '',
      user_pic: json['user_pic'] ?? '',
    );
  }
}
