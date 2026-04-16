import '../../../auth/data/models/user_model.dart';

class ReviewModel {
  final String id;
  final String doctorId;
  final UserModel user;
  final int rate;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.doctorId,
    required this.user,
    required this.rate,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      doctorId: json['doctor'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      rate: (json['rate'] ?? 0) as int,
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}