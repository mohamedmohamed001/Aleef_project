class MedicalRecordDetailsModel {
  final String id;
  final String condition;
  final String title;
  final String description;
  final List<String> attachments;
  final String date;
  final String createdAt;
  final String doctorId;
  final String doctorName;
  final String doctorPic;

  MedicalRecordDetailsModel({
    required this.id,
    required this.condition,
    required this.title,
    required this.description,
    required this.attachments,
    required this.date,
    required this.createdAt,
    required this.doctorId,
    required this.doctorName,
    required this.doctorPic,
  });

  factory MedicalRecordDetailsModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordDetailsModel(
      id: json['id']?.toString() ?? '',
      condition: json['condition']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      attachments: json['attachments'] == null
          ? []
          : List<String>.from(
        (json['attachments'] as List).map((e) => e.toString()),
      ),
      date: json['date']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString() ?? '',
      doctorName: json['doctor_name']?.toString() ?? '',
      doctorPic: json['doctor_pic']?.toString() ?? '',
    );
  }
}