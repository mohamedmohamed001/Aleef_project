class ScheduledDayModel {
  final String date;
  final String display;

  ScheduledDayModel({
    required this.date,
    required this.display,
  });

  factory ScheduledDayModel.fromJson(Map<String, dynamic> json) {
    return ScheduledDayModel(
      date: json["date"] ?? "",
      display: json["display"] ?? "",
    );
  }
}