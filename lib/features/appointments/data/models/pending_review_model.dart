class PendingReviewModel {
  final String appointmentId;
  final String doctorId;
  final String doctorName;
  final String doctorImage;
  final String specialization;

  PendingReviewModel({
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorImage,
    required this.specialization,
  });

  factory PendingReviewModel.fromJson(Map<String, dynamic> json) {
    final doctor = json["doctor"] ?? {};

    return PendingReviewModel(
      appointmentId: json["appointmentid"] ?? "",
      doctorId: doctor["id"] ?? "",
      doctorName: doctor["name"] ?? "",
      doctorImage: doctor["profilePic"] ?? "",
      specialization: doctor["specialization"] ?? "",
    );
  }
}